import 'dart:convert';
import 'package:home_widget/home_widget.dart';
import 'package:tube_filter/core/database/app_database.dart';

/// Service to sync video data with the Android home screen widget
class WidgetService {
  static const String appGroupId = 'group.com.tubefilter.widget';
  static const String widgetName = 'HomeWidgetReceiver';

  /// Initialize home widget (call in main.dart)
  static Future<void> initialize() async {
    await HomeWidget.setAppGroupId(appGroupId);
  }

  /// Update widget with latest videos
  static Future<void> updateWidget(List<MatchedVideo> videos) async {
    // Take first 3 videos
    final latestVideos = videos.take(3).toList();

    // Prepare data as JSON
    final videoData = latestVideos
        .map((v) => {'id': v.id, 'title': v.title, 'thumbnail': v.thumbnailUrl})
        .toList();

    // Save to shared preferences for native widget
    await HomeWidget.saveWidgetData<String>('videos', jsonEncode(videoData));
    await HomeWidget.saveWidgetData<int>('count', latestVideos.length);
    await HomeWidget.saveWidgetData<String>(
      'lastUpdated',
      DateTime.now().toIso8601String(),
    );

    // Request widget update
    await HomeWidget.updateWidget(name: widgetName, androidName: widgetName);
  }

  /// Clear widget data
  static Future<void> clearWidget() async {
    await HomeWidget.saveWidgetData<String>('videos', '[]');
    await HomeWidget.saveWidgetData<int>('count', 0);
    await HomeWidget.updateWidget(name: widgetName, androidName: widgetName);
  }
}
