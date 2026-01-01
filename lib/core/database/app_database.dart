import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:tube_filter/core/database/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Channels, FilterRules, MatchedVideos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          await m.addColumn(matchedVideos, matchedVideos.isBookmarked);
        }
        if (from < 3) {
          await m.addColumn(channels, channels.category);
        }
      },
    );
  }

  // CRUD Operations

  // Channels
  Future<List<Channel>> getAllChannels() => select(channels).get();
  Future<void> insertChannel(Channel channel) =>
      into(channels).insertOnConflictUpdate(channel);
  Future<void> deleteChannel(String id) =>
      (delete(channels)..where((tbl) => tbl.id.equals(id))).go();

  // Filters
  Future<List<FilterRule>> getFiltersForChannel(String channelId) {
    return (select(
      filterRules,
    )..where((tbl) => tbl.channelId.equals(channelId))).get();
  }

  Future<void> insertFilter(FilterRulesCompanion filter) =>
      into(filterRules).insert(filter);
  Future<void> deleteFilter(int id) =>
      (delete(filterRules)..where((tbl) => tbl.id.equals(id))).go();

  // Videos
  Future<List<MatchedVideo>> getVideos() {
    return (select(matchedVideos)..orderBy([
          (t) =>
              OrderingTerm(expression: t.publishedAt, mode: OrderingMode.desc),
        ]))
        .get();
  }

  // Reactive stream for videos - updates automatically when data changes
  Stream<List<MatchedVideo>> watchVideos() {
    return (select(matchedVideos)..orderBy([
          (t) =>
              OrderingTerm(expression: t.publishedAt, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  Future<List<MatchedVideo>> getBookmarkedVideos() {
    return (select(matchedVideos)
          ..where((t) => t.isBookmarked.equals(true))
          ..orderBy([
            (t) => OrderingTerm(
              expression: t.publishedAt,
              mode: OrderingMode.desc,
            ),
          ]))
        .get();
  }

  // Watch bookmarked videos reactively
  Stream<List<MatchedVideo>> watchBookmarkedVideos() {
    return (select(matchedVideos)
          ..where((t) => t.isBookmarked.equals(true))
          ..orderBy([
            (t) => OrderingTerm(
              expression: t.publishedAt,
              mode: OrderingMode.desc,
            ),
          ]))
        .watch();
  }

  // Get single video by ID (to check if exists and preserve bookmark)
  Future<MatchedVideo?> getVideoById(String id) {
    return (select(
      matchedVideos,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertVideo(MatchedVideo video) =>
      into(matchedVideos).insertOnConflictUpdate(video);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'tube_filter.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
