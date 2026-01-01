import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:tube_filter/core/database/app_database.dart';
import 'package:tube_filter/core/services/youtube_service.dart';

class VideoRepository {
  final AppDatabase _db;
  final YouTubeService _api;

  VideoRepository(this._db, this._api);

  // Expose database for category filtering in FeedProvider
  AppDatabase get database => _db;

  // Use .watch() for reactive stream that updates when data changes
  Stream<List<MatchedVideo>> watchFeed() {
    return _db.watchVideos();
  }

  // Watch bookmarked videos reactively
  Stream<List<MatchedVideo>> watchBookmarks() {
    return _db.watchBookmarkedVideos();
  }

  // Refresh feed with improved filtering logic
  Future<void> refreshFeed({bool forceRefresh = false}) async {
    debugPrint('📡 [VideoRepository] Starting refresh...');

    // 1. Get all channels
    final channels = await _db.getAllChannels();
    debugPrint('📡 [VideoRepository] Found ${channels.length} channels');

    if (channels.isEmpty) {
      debugPrint('⚠️ [VideoRepository] No channels found! Add a channel first.');
      return;
    }

    for (final channel in channels) {
      debugPrint('📡 [VideoRepository] Processing channel: ${channel.name}');
      debugPrint('   - uploadPlaylistId: ${channel.uploadPlaylistId}');
      debugPrint('   - lastChecked: ${channel.lastChecked}');

      // 2. Check if we should update (limit to once every 5 mins to save quota)
      // Skip this check if forceRefresh is true
      if (!forceRefresh &&
          channel.lastChecked != null &&
          DateTime.now().difference(channel.lastChecked!).inMinutes < 5) {
        debugPrint('⏭️ [VideoRepository] Skipping ${channel.name} - checked recently');
        continue;
      }

      // 2b. If forceRefresh, delete old non-bookmarked videos for this channel
      // This ensures filter changes are properly applied
      if (forceRefresh) {
        debugPrint('🗑️ [VideoRepository] Clearing old videos for ${channel.name} (filter changed)');
        await (_db.delete(_db.matchedVideos)
          ..where((t) => t.channelId.equals(channel.id))
          ..where((t) => t.isBookmarked.equals(false))
        ).go();
      }

      // 3. Get filters for this channel
      final filters = await _db.getFiltersForChannel(channel.id);
      debugPrint('📡 [VideoRepository] Found ${filters.length} filters for ${channel.name}');

      final includeKeywords = filters
          .where((f) => f.type == 0)
          .map((f) => f.keyword.toLowerCase())
          .toList();
      final excludeKeywords = filters
          .where((f) => f.type == 1)
          .map((f) => f.keyword.toLowerCase())
          .toList();

      debugPrint('   - Include keywords: $includeKeywords');
      debugPrint('   - Exclude keywords: $excludeKeywords');

      // NOTE: Empty filters = show ALL videos (no filtering)

      // 4. Fetch latest videos from YouTube API
      debugPrint('📡 [VideoRepository] Fetching videos from YouTube...');
      final videos = await _api.getPlaylistVideos(channel.uploadPlaylistId);
      debugPrint('📡 [VideoRepository] Fetched ${videos.length} videos from API');

      if (videos.isEmpty) {
        debugPrint('⚠️ [VideoRepository] No videos returned from API for ${channel.name}');
        // Still update lastChecked to avoid hammering API
        await _db
            .update(_db.channels)
            .replace(channel.copyWith(lastChecked: Value(DateTime.now())));
        continue;
      }

      // 5. Fetch Durations for Shorts Filtering
      List<Map<String, dynamic>> videosToProcess = [];
      final videoIds = videos.map((v) => v['id'] as String).toList();
      final durations = await _api.getVideoDurations(videoIds);
      debugPrint('📡 [VideoRepository] Fetched durations for ${durations.length} videos');

      int shortsSkipped = 0;
      for (final video in videos) {
        final durationStr = durations[video['id']];
        if (durationStr != null && _isShort(durationStr)) {
          shortsSkipped++;
          continue; // Skip Shorts
        }
        videosToProcess.add(video);
      }
      debugPrint('📡 [VideoRepository] After Shorts filter: ${videosToProcess.length} videos (skipped $shortsSkipped Shorts)');

      int savedCount = 0;
      for (final videoData in videosToProcess) {
        final title = (videoData['title'] as String).toLowerCase();
        final rawDesc = (videoData['description'] as String).toLowerCase();
        final truncatedDesc = rawDesc.length > 100 
            ? rawDesc.substring(0, 100) 
            : rawDesc;

        // 6. Apply Exclude Logic First
        bool isExcluded = false;
        for (final ex in excludeKeywords) {
          // Check title OR truncated description
          if (title.contains(ex) || truncatedDesc.contains(ex)) {
            isExcluded = true;
            debugPrint('   ❌ VIDEO EXCLUDED: "${videoData['title']}" matched exclude: "$ex"');
            break;
          }
        }
        if (isExcluded) continue;

        // 7. Apply Include Logic
        String matchedKeyword = 'all'; // Default for "show all"

        if (includeKeywords.isNotEmpty) {
          matchedKeyword = ''; // Reset
          for (final inc in includeKeywords) {
            // PRIORITY CHECK:
            // 1. Check strict Title match first
            if (title.contains(inc)) {
              matchedKeyword = inc;
              debugPrint('   ✅ TITLE MATCH: "${videoData['title']}" matched include: "$inc"');
              break; 
            }
            // 2. Check Truncated Description (Secondary)
            if (truncatedDesc.contains(inc)) {
              matchedKeyword = inc;
              debugPrint('   ✅ DESC MATCH: "${videoData['title']}" matched include: "$inc" (in description)');
              break;
            }
          }
          // If no include keyword matched, skip this video
          if (matchedKeyword.isEmpty) {
            debugPrint('   ⏭️ NO MATCH: "${videoData['title']}" - skipped (no include keyword found)');
            continue;
          }
        } else {
          debugPrint('   📺 NO FILTERS: "${videoData['title']}" - showing (no include filters)');
        }

        // 8. Preserve existing bookmark status
        final existingVideo = await _db.getVideoById(videoData['id']);
        final isBookmarked = existingVideo?.isBookmarked ?? false;

        // 9. Save to DB
        await _db.insertVideo(
          MatchedVideo(
            id: videoData['id'],
            title: videoData['title'],
            description: videoData['description'],
            thumbnailUrl: videoData['thumbnail'],
            publishedAt: DateTime.parse(videoData['publishedAt']),
            channelId: channel.id,
            matchedKeyword: matchedKeyword,
            isBookmarked: isBookmarked,
          ),
        );
        savedCount++;
      }

      debugPrint('✅ [VideoRepository] Saved $savedCount videos for ${channel.name}');

      // 10. Update Last Checked
      await _db
          .update(_db.channels)
          .replace(channel.copyWith(lastChecked: Value(DateTime.now())));
    }

    debugPrint('✅ [VideoRepository] Refresh complete!');
  }

  bool _isShort(String duration) {
    try {
      final match = RegExp(
        r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?',
      ).firstMatch(duration);
      if (match == null) return false;

      final hours = int.tryParse(match.group(1) ?? '0') ?? 0;
      final minutes = int.tryParse(match.group(2) ?? '0') ?? 0;
      final seconds = int.tryParse(match.group(3) ?? '0') ?? 0;

      final totalSeconds = hours * 3600 + minutes * 60 + seconds;
      return totalSeconds <= 60;
    } catch (e) {
      return false;
    }
  }

  Future<void> toggleBookmark(String videoId, bool currentStatus) async {
    await (_db.update(_db.matchedVideos)..where((t) => t.id.equals(videoId)))
        .write(MatchedVideosCompanion(isBookmarked: Value(!currentStatus)));
  }
}
