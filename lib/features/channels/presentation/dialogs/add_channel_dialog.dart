import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_filter/core/constants/app_colors.dart';
import 'package:tube_filter/features/channels/providers/channel_provider.dart';
import 'package:tube_filter/features/home/providers/feed_provider.dart';
import 'package:tube_filter/core/services/youtube_service.dart';

// Predefined categories
const List<String> kChannelCategories = [
  '',
  'Tech',
  'Gaming',
  'Music',
  'Education',
  'Entertainment',
  'News',
  'Sports',
  'Other',
];

class AddChannelDialog extends StatefulWidget {
  const AddChannelDialog({super.key});

  @override
  State<AddChannelDialog> createState() => _AddChannelDialogState();
}

class _AddChannelDialogState extends State<AddChannelDialog> {
  final _controller = TextEditingController();
  bool _isLoading = false;
  String? _error;
  List<Map<String, dynamic>> _searchResults = [];
  Timer? _debounce;
  String _selectedCategory = '';

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // Search logic with debounce
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() => _isLoading = true);
      try {
        final api = context.read<YouTubeService>();
        final results = await api.searchChannels(query);
        if (mounted) {
          setState(() {
            _searchResults = results;
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
  }

  Future<void> _addChannel(String input) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final success = await context.read<ChannelProvider>().addChannel(
        input,
        category: _selectedCategory,
      );
      if (success && mounted) {
        // CRITICAL: Trigger feed refresh so videos load immediately!
        context.read<FeedProvider>().refresh();
        
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Channel added! Loading videos...')),
        );
      } else if (mounted) {
        setState(() => _error = 'Could not find channel.');
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Channel',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search Channel (e.g. "MKBHD")',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
              ),
              onChanged: _onSearchChanged,
              onSubmitted: (val) {
                if (val.isNotEmpty) _addChannel(val);
              },
            ),
            const SizedBox(height: 12),

            // Category Selector
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category (Optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
              ),
              items: kChannelCategories
                  .map(
                    (cat) => DropdownMenuItem(
                      value: cat,
                      child: Text(cat.isEmpty ? 'No Category' : cat),
                    ),
                  )
                  .toList(),
              onChanged: (val) => setState(() => _selectedCategory = val ?? ''),
            ),

            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),

            const SizedBox(height: 12),

            // Results List
            Flexible(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _searchResults.isEmpty
                    ? const SizedBox.shrink()
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final item = _searchResults[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(item['thumbnail']),
                            ),
                            title: Text(
                              item['title'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.add_circle_outline,
                                color: AppColors.primary,
                              ),
                              onPressed: () => _addChannel(item['id']),
                            ),
                          );
                        },
                      ),
              ),
            ),

            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
