import 'package:flutter/material.dart';
import 'package:tube_filter/core/database/app_database.dart';
import 'package:tube_filter/features/channels/data/channel_repository.dart';
import 'package:tube_filter/core/services/youtube_service.dart';

class ChannelProvider extends ChangeNotifier {
  final ChannelRepository _repo;
  final YouTubeService _api;

  ChannelProvider(this._repo, this._api);

  Stream<List<Channel>> get channels => _repo.watchAllChannels();

  Future<bool> addChannel(String channelId, {String category = ''}) async {
    // 1. Fetch details from API
    final details = await _api.getChannelDetails(channelId);
    if (details != null) {
      // 2. Add to DB
      final channel = Channel(
        id: details['id'],
        name: details['title'],
        uploadPlaylistId: details['uploadPlaylistId'],
        thumbnailUrl: details['thumbnail'],
        category: category,
        lastChecked: null, // FIXED: Set to null so first refresh fetches videos
      );
      await _repo.addChannel(channel);
      return true;
    } else {
      return false;
    }
  }

  Future<void> deleteChannel(String id) => _repo.removeChannel(id);

  Future<void> updateChannelCategory(String channelId, String category) async {
    await _repo.updateChannelCategory(channelId, category);
    notifyListeners();
  }

  Stream<List<FilterRule>> getFilters(String channelId) =>
      _repo.watchFilters(channelId);

  Future<void> addFilter(
    String channelId,
    String keyword,
    bool isInclude,
  ) async {
    await _repo.addFilter(channelId, keyword, isInclude ? 0 : 1);
  }

  Future<void> deleteFilter(int id) => _repo.removeFilter(id);
}
