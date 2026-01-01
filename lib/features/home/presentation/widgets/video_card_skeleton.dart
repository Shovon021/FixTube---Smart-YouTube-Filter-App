import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VideoCardSkeleton extends StatelessWidget {
  const VideoCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if dark mode to adjust shimmer colors
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              height: 200, // Approx 16:9
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: double.infinity,
                    color: baseColor,
                  ),
                  const SizedBox(height: 8),
                  Container(height: 16, width: 200, color: baseColor),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(radius: 12, backgroundColor: baseColor),
                      const SizedBox(width: 8),
                      Container(height: 12, width: 100, color: baseColor),
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
