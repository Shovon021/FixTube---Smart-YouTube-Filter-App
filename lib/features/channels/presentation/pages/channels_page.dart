import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_filter/core/constants/app_colors.dart';
import 'package:tube_filter/core/database/app_database.dart';
import 'package:tube_filter/core/widgets/empty_state_widget.dart';
import 'package:tube_filter/features/channels/presentation/dialogs/add_channel_dialog.dart';
import 'package:tube_filter/features/channels/presentation/sheets/filter_settings_sheet.dart';
import 'package:tube_filter/features/channels/providers/channel_provider.dart';

// kChannelCategories is exported from add_channel_dialog.dart

class ChannelsPage extends StatelessWidget {
  const ChannelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Managed Channels')),
      body: StreamBuilder<List<Channel>>(
        stream: context.watch<ChannelProvider>().channels,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final channels = snapshot.data!;

          if (channels.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.subscriptions_outlined,
              title: 'No Channels Yet',
              message:
                  'Add your favorite YouTube channels to start building your curated feed.',
              actionLabel: 'Add Channel',
              onActionPressed: () => _showAddDialog(context),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: channels.length,
            itemBuilder: (context, index) {
              final channel = channels[index];
              return Dismissible(
                key: Key(channel.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Channel?'),
                      content: Text('Remove "${channel.name}" and all its filters?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ) ?? false;
                },
                onDismissed: (_) {
                  context.read<ChannelProvider>().deleteChannel(channel.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${channel.name} removed')),
                  );
                },
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundImage: channel.thumbnailUrl != null
                          ? CachedNetworkImageProvider(channel.thumbnailUrl!)
                          : null,
                      child: channel.thumbnailUrl == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(
                      channel.name,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 16),
                    ),
                    subtitle: Row(
                      children: [
                        if (channel.category.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withAlpha(30),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              channel.category,
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? Colors.white70
                                    : Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        else
                          const Text(
                            'No category',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit Category Button
                        IconButton(
                          icon: const Icon(
                            Icons.label_outline,
                            color: Colors.grey,
                          ),
                          onPressed: () => _showCategoryPicker(context, channel),
                          tooltip: 'Change Category',
                        ),
                        // Filter Settings Button
                        IconButton(
                          icon: Icon(
                            Icons.tune_rounded,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () => _showFilterSheet(context, channel),
                          tooltip: 'Filter Settings',
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => const AddChannelDialog());
  }

  void _showFilterSheet(BuildContext context, Channel channel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterSettingsSheet(channel: channel),
    );
  }

  void _showCategoryPicker(BuildContext context, Channel channel) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Category for ${channel.name}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: kChannelCategories.map((cat) {
              final isSelected = cat == channel.category;
              return ListTile(
                title: Text(cat.isEmpty ? 'No Category' : cat),
                leading: Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected ? AppColors.primary : Colors.grey,
                ),
                onTap: () {
                  context.read<ChannelProvider>().updateChannelCategory(
                    channel.id,
                    cat,
                  );
                  Navigator.pop(ctx);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
