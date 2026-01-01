import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:tube_filter/core/database/app_database.dart';

class BackupService {
  final AppDatabase _db;

  BackupService(this._db);

  /// Exports Channels and Filter Rules to a JSON file.
  Future<String?> exportData() async {
    // 1. Fetch Data
    final channels = await _db.getAllChannels();

    // Complex mapping: Channel -> { ...details, filters: [] }
    final List<Map<String, dynamic>> exportList = [];

    for (final ch in channels) {
      final filters = await _db.getFiltersForChannel(ch.id);

      exportList.add({
        'id': ch.id,
        'name': ch.name,
        'uploadPlaylistId': ch.uploadPlaylistId,
        'thumbnailUrl': ch.thumbnailUrl,
        'filters': filters
            .map((f) => {'keyword': f.keyword, 'type': f.type})
            .toList(),
      });
    }

    // 2. Convert to JSON
    final jsonString = jsonEncode(exportList);

    return jsonString;
  }

  /// Imports data from a JSON string.
  Future<void> importData(String jsonString) async {
    try {
      final List<dynamic> list = jsonDecode(jsonString);

      for (final item in list) {
        // 1. Insert Channel
        final channel = Channel(
          id: item['id'],
          name: item['name'],
          uploadPlaylistId: item['uploadPlaylistId'],
          thumbnailUrl: item['thumbnailUrl'],
          category: item['category'] ?? '', // Default to empty string
          lastChecked: null, // Reset check time
        );
        await _db.insertChannel(channel);

        // 2. Insert Filters
        if (item['filters'] != null) {
          for (final f in item['filters']) {
            await _db.insertFilter(
              FilterRulesCompanion.insert(
                channelId: item['id'],
                keyword: f['keyword'],
                type: Value(f['type']),
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Import failed: $e');
      rethrow;
    }
  }
}
