import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tube_filter/core/database/app_database.dart';
import 'package:tube_filter/core/services/widget_service.dart';
import 'package:tube_filter/features/home/data/video_repository.dart';

class FeedProvider extends ChangeNotifier {
  final VideoRepository _repo;
  final AppDatabase _db;
  bool _isLoading = false;
  String _selectedCategory = ''; // Empty means "All"

  FeedProvider(this._repo) : _db = _repo.database;

  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  // Get all unique categories from channels
  Future<List<String>> getAvailableCategories() async {
    final channels = await _db.getAllChannels();
    final categories = channels
        .map((c) => c.category)
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }

  // Watch feed, filtered by category if selected
  Stream<List<MatchedVideo>> get feed async* {
    // Get channel IDs for the selected category
    final channels = await _db.getAllChannels();
    final categoryChannelIds = _selectedCategory.isEmpty
        ? null // null means don't filter by category
        : channels
              .where((c) => c.category == _selectedCategory)
              .map((c) => c.id)
              .toSet();

    await for (final allVideos in _repo.watchFeed()) {
      if (categoryChannelIds == null) {
        yield allVideos;
      } else {
        yield allVideos
            .where((v) => categoryChannelIds.contains(v.channelId))
            .toList();
      }
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Clean way to show errors in UI
  final _errorController = StreamController<String>.broadcast();
  Stream<String> get errorStream => _errorController.stream;

  Future<void> refresh({bool forceRefresh = false}) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repo.refreshFeed(forceRefresh: forceRefresh);

      // Sync widget with latest videos
      final videos = await _db.getVideos();
      await WidgetService.updateWidget(videos);
    } catch (e) {
      debugPrint(e.toString());
      _errorController.add('Failed to refresh: Check Internet Connection.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _errorController.close();
    super.dispose();
  }
}
