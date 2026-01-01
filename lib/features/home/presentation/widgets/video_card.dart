import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tube_filter/core/constants/app_colors.dart';
import 'package:tube_filter/core/database/app_database.dart';
import 'package:tube_filter/features/home/data/video_repository.dart';
import 'package:tube_filter/features/home/presentation/pages/video_player_page.dart';

class VideoCard extends StatefulWidget {
  final MatchedVideo video;

  const VideoCard({super.key, required this.video});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _bookmarkAnimController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _bookmarkAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
        ]).animate(
          CurvedAnimation(
            parent: _bookmarkAnimController,
            curve: Curves.elasticOut,
          ),
        );
  }

  @override
  void dispose() {
    _bookmarkAnimController.dispose();
    super.dispose();
  }

  void _launchVideo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoPlayerPage(
          videoId: widget.video.id,
          title: widget.video.title,
          description: widget.video.description,
        ),
      ),
    );
  }

  void _toggleBookmark() {
    _bookmarkAnimController.forward(from: 0);
    context.read<VideoRepository>().toggleBookmark(
      widget.video.id,
      widget.video.isBookmarked,
    );
  }

  @override
  Widget build(BuildContext context) {
    final video = widget.video;
    final isNew = DateTime.now().difference(video.publishedAt).inHours < 24;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _launchVideo(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: isDark ? Theme.of(context).cardColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : AppColors.cardShadow,
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Hero(
              tag: video.id,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: CachedNetworkImage(
                        imageUrl: video.thumbnailUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey.shade100),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  if (isNew)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'New',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.transparent,
                        child: Icon(
                          Icons.smart_display_outlined,
                          size: 16,
                          color: isDark ? Colors.grey.shade400 : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          DateFormat.yMMMd().format(video.publishedAt),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      // Matched Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey.shade800
                              : AppColors.chipBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.local_offer_outlined,
                              size: 14,
                              color: isDark
                                  ? Colors.white70
                                  : AppColors.textPrimary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              video.matchedKeyword,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? Colors.white70
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Animated Bookmark Button
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: IconButton(
                          icon: Icon(
                            video.isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: video.isBookmarked
                                ? AppColors.primary
                                : Colors.grey,
                          ),
                          onPressed: _toggleBookmark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
