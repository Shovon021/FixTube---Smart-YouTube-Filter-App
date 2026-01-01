import 'package:drift/drift.dart';
import 'package:tube_filter/core/database/app_database.dart';

class ChannelRepository {
  final AppDatabase _db;

  ChannelRepository(this._db);

  Stream<List<Channel>> watchAllChannels() {
    return _db.select(_db.channels).watch();
  }

  Future<void> addChannel(Channel channel) async {
    await _db.insertChannel(channel);
  }

  Future<void> removeChannel(String id) async {
    await _db.deleteChannel(id);
  }

  // Filters
  Future<List<FilterRule>> getFilters(String channelId) {
    return _db.getFiltersForChannel(channelId);
  }

  Stream<List<FilterRule>> watchFilters(String channelId) {
    return (_db.select(
      _db.filterRules,
    )..where((t) => t.channelId.equals(channelId))).watch();
  }

  Future<void> addFilter(String channelId, String keyword, int type) async {
    await _db.insertFilter(
      FilterRulesCompanion.insert(
        channelId: channelId,
        keyword: keyword,
        type: Value(type),
      ),
    );
  }

  Future<void> removeFilter(int id) async {
    await _db.deleteFilter(id);
  }

  // Category
  Future<void> updateChannelCategory(String channelId, String category) async {
    await (_db.update(_db.channels)..where((t) => t.id.equals(channelId)))
        .write(ChannelsCompanion(category: Value(category)));
  }
}
