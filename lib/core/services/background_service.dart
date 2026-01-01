import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:tube_filter/core/constants/api_keys.dart';
import 'package:tube_filter/core/database/app_database.dart';
import 'package:tube_filter/core/services/youtube_service.dart';
import 'package:tube_filter/features/home/data/video_repository.dart';

// Top-level function for WorkManager
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'fetchNewVideos') {
      try {
        final db = AppDatabase();
        final api = YouTubeService(apiKey: ApiKeys.youtubeApiKey);
        final repo = VideoRepository(db, api);

        // Get existing video IDs BEFORE refresh
        final videosBefore = await db.getVideos();
        final existingIds = videosBefore.map((v) => v.id).toSet();

        await repo.refreshFeed();

        // Get videos AFTER refresh
        final videosAfter = await db.getVideos();
        
        // Find truly NEW videos
        final newVideos = videosAfter.where((v) => !existingIds.contains(v.id)).toList();

        if (newVideos.isNotEmpty) {
          // Get channel info for new videos
          final channels = await db.getAllChannels();
          final channelMap = {for (var c in channels) c.id: c.name};

          // Group by channel
          final Map<String, int> channelCounts = {};
          for (final video in newVideos) {
            final channelName = channelMap[video.channelId] ?? 'Unknown';
            channelCounts[channelName] = (channelCounts[channelName] ?? 0) + 1;
          }

          // Build notification message
          String title;
          String body;

          if (channelCounts.length == 1) {
            // Single channel - show channel name
            final channelName = channelCounts.keys.first;
            final count = channelCounts.values.first;
            title = channelName;
            body = count == 1 
                ? 'Uploaded a new video!' 
                : 'Uploaded $count new videos!';
          } else {
            // Multiple channels
            title = 'New Videos!';
            final channelList = channelCounts.entries
                .map((e) => '${e.key} (${e.value})')
                .take(3) // Limit to 3 channels
                .join(', ');
            body = 'From: $channelList';
          }

          await BackgroundService.showNotification(title, body);
        }

        await db.close();
        return Future.value(true);
      } catch (e) {
        debugPrint('Background fetch failed: $e');
        return Future.value(false);
      }
    }
    return Future.value(true);
  });
}

class BackgroundService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    const settings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(settings);

    await Workmanager().initialize(callbackDispatcher);

    // Register periodic task (every 5 mins for faster video detection)
    // Note: Android may still enforce 15-min minimum for battery optimization
    await Workmanager().registerPeriodicTask(
      "1",
      "fetchNewVideos",
      frequency: const Duration(minutes: 5),
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  static Future<void> showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'tube_filter_channel',
      'FixTube Updates',
      channelDescription: 'Notifications for new filtered videos',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(''),
    );
    const details = NotificationDetails(android: androidDetails);

    await _notifications.show(0, title, body, details);
  }
}
