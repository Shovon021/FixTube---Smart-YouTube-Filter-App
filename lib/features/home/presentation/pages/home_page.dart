import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_filter/core/constants/app_colors.dart';
import 'package:tube_filter/core/database/app_database.dart';
import 'package:tube_filter/features/channels/presentation/pages/channels_page.dart';
import 'package:tube_filter/features/home/presentation/pages/bookmarks_page.dart'; // Added
import 'package:tube_filter/features/home/presentation/pages/settings_page.dart';
import 'package:tube_filter/features/home/presentation/widgets/video_card.dart';
import 'package:tube_filter/features/home/presentation/widgets/video_card_skeleton.dart';
import 'package:tube_filter/features/home/providers/feed_provider.dart';
import 'package:tube_filter/core/widgets/empty_state_widget.dart';
import 'package:tube_filter/core/widgets/animated_logo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Auto-refresh on start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<FeedProvider>();
      provider.refresh();

      // Listen for errors
      provider.errorStream.listen((message) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Key for glassmorphism
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // 0. Home Feed with Collapsible Header
          Scaffold(
            backgroundColor: Colors.transparent, // Let main scaffold bg show
            body: Consumer<FeedProvider>(
              builder: (context, provider, child) {
                return StreamBuilder<List<MatchedVideo>>(
                  stream: provider.feed,
                  builder: (context, snapshot) {
                    // Loading
                    if (provider.isLoading &&
                        (!snapshot.hasData || snapshot.data!.isEmpty)) {
                      return CustomScrollView(
                        slivers: [
                          _buildSliverAppBar(context),
                          SliverPadding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 16,
                              bottom: 100,
                            ),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => const VideoCardSkeleton(),
                                childCount: 5,
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return CustomScrollView(
                        slivers: [
                          _buildSliverAppBar(context),
                          SliverFillRemaining(
                            child: EmptyStateWidget(
                              icon: Icons.filter_alt_off_outlined,
                              title: 'Feed is Empty',
                              message:
                                  'Add channels and set your filters to start seeing curated videos here.',
                              actionLabel: 'Add Channel',
                              onActionPressed: () => setState(
                                () => _currentIndex = 2,
                              ), // Go to Channels tab
                            ),
                          ),
                        ],
                      );
                    }

                    // Content
                    final videos = snapshot.data!;
                    return RefreshIndicator(
                      onRefresh: () => provider.refresh(),
                      edgeOffset: 100, // Push refresh indicator down
                      color: AppColors.primary,
                      child: CustomScrollView(
                        slivers: [
                          _buildSliverAppBar(context),
                          SliverPadding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 16,
                              bottom: 100,
                            ), // Bottom padding for nav bar
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) =>
                                    VideoCard(video: videos[index]),
                                childCount: videos.length,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // 1. Saved (Bookmarks) - Needs its own Scaffold wrapper for consistency if needed, but existing page is fine except nav bar covers it
          const Padding(
            padding: EdgeInsets.only(bottom: 80), // Padding for nav bar
            child: BookmarksPage(),
          ),

          // 2. Channels
          const Padding(
            padding: EdgeInsets.only(bottom: 80),
            child: ChannelsPage(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withAlpha(204),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent, // Important
              selectedItemColor: AppColors.primary,
              unselectedItemColor: Colors.grey,
              elevation: 0,
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_filled),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark_border),
                  activeIcon: Icon(Icons.bookmark),
                  label: 'Saved',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.subscriptions_outlined),
                  activeIcon: Icon(Icons.subscriptions),
                  label: 'Channels',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    final provider = context.watch<FeedProvider>();

    return SliverAppBar(
      floating: true,
      pinned: true,
      snap: false,
      expandedHeight: 100,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor.withAlpha(230),
      surfaceTintColor: Colors.transparent,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const AnimatedLogo(size: 32),
          ),
          const SizedBox(width: 10),
          Text(
            'FixTube',
            style: TextStyle(
              fontFamily: 'Playball',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettingsPage()),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: FutureBuilder<List<String>>(
          future: provider.getAvailableCategories(),
          builder: (context, snapshot) {
            final categories = ['All', ...(snapshot.data ?? [])];
            final selected = provider.selectedCategory.isEmpty
                ? 'All'
                : provider.selectedCategory;

            return SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = cat == selected;
                  return FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) {
                      provider.setCategory(cat == 'All' ? '' : cat);
                    },
                    selectedColor: AppColors.primary.withAlpha(50),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : Colors.grey,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
