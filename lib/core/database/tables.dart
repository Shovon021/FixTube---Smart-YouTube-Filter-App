import 'package:drift/drift.dart';

// Tables
class Channels extends Table {
  TextColumn get id => text()(); // YouTube Channel ID
  TextColumn get name => text()();
  TextColumn get uploadPlaylistId => text()();
  TextColumn get thumbnailUrl => text().nullable()();
  TextColumn get category =>
      text().withDefault(const Constant(''))(); // NEW: Channel category
  DateTimeColumn get lastChecked => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class FilterRules extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get channelId => text().references(Channels, #id)();
  TextColumn get keyword => text()();
  // 0 = Include, 1 = Exclude
  IntColumn get type => integer().withDefault(const Constant(0))();
}

class MatchedVideos extends Table {
  TextColumn get id => text()(); // Video ID
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get thumbnailUrl => text()();
  DateTimeColumn get publishedAt => dateTime()();
  TextColumn get channelId => text().references(Channels, #id)();
  TextColumn get matchedKeyword => text()();
  BoolColumn get isBookmarked => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
