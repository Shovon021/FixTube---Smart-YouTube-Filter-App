import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tube_filter/core/database/app_database.dart';
import 'package:tube_filter/features/home/presentation/widgets/video_card.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Videos')),
      body: StreamBuilder<List<MatchedVideo>>(
        // Use the REACTIVE watch method that updates automatically!
        stream: context.read<AppDatabase>().watchBookmarkedVideos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No saved videos yet.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final videos = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              return VideoCard(video: videos[index]);
            },
          );
        },
      ),
    );
  }
}

// Extension to add query cleanly without modifying DB file again (if possible) or just modify DB.
// Actually, I need to add `getBookmarkedVideos` to AppDatabase first.
