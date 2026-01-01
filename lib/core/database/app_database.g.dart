// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ChannelsTable extends Channels with TableInfo<$ChannelsTable, Channel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChannelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uploadPlaylistIdMeta = const VerificationMeta(
    'uploadPlaylistId',
  );
  @override
  late final GeneratedColumn<String> uploadPlaylistId = GeneratedColumn<String>(
    'upload_playlist_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thumbnailUrlMeta = const VerificationMeta(
    'thumbnailUrl',
  );
  @override
  late final GeneratedColumn<String> thumbnailUrl = GeneratedColumn<String>(
    'thumbnail_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _lastCheckedMeta = const VerificationMeta(
    'lastChecked',
  );
  @override
  late final GeneratedColumn<DateTime> lastChecked = GeneratedColumn<DateTime>(
    'last_checked',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    uploadPlaylistId,
    thumbnailUrl,
    category,
    lastChecked,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'channels';
  @override
  VerificationContext validateIntegrity(
    Insertable<Channel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('upload_playlist_id')) {
      context.handle(
        _uploadPlaylistIdMeta,
        uploadPlaylistId.isAcceptableOrUnknown(
          data['upload_playlist_id']!,
          _uploadPlaylistIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_uploadPlaylistIdMeta);
    }
    if (data.containsKey('thumbnail_url')) {
      context.handle(
        _thumbnailUrlMeta,
        thumbnailUrl.isAcceptableOrUnknown(
          data['thumbnail_url']!,
          _thumbnailUrlMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('last_checked')) {
      context.handle(
        _lastCheckedMeta,
        lastChecked.isAcceptableOrUnknown(
          data['last_checked']!,
          _lastCheckedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Channel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Channel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      uploadPlaylistId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}upload_playlist_id'],
      )!,
      thumbnailUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_url'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      lastChecked: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_checked'],
      ),
    );
  }

  @override
  $ChannelsTable createAlias(String alias) {
    return $ChannelsTable(attachedDatabase, alias);
  }
}

class Channel extends DataClass implements Insertable<Channel> {
  final String id;
  final String name;
  final String uploadPlaylistId;
  final String? thumbnailUrl;
  final String category;
  final DateTime? lastChecked;
  const Channel({
    required this.id,
    required this.name,
    required this.uploadPlaylistId,
    this.thumbnailUrl,
    required this.category,
    this.lastChecked,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['upload_playlist_id'] = Variable<String>(uploadPlaylistId);
    if (!nullToAbsent || thumbnailUrl != null) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl);
    }
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || lastChecked != null) {
      map['last_checked'] = Variable<DateTime>(lastChecked);
    }
    return map;
  }

  ChannelsCompanion toCompanion(bool nullToAbsent) {
    return ChannelsCompanion(
      id: Value(id),
      name: Value(name),
      uploadPlaylistId: Value(uploadPlaylistId),
      thumbnailUrl: thumbnailUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailUrl),
      category: Value(category),
      lastChecked: lastChecked == null && nullToAbsent
          ? const Value.absent()
          : Value(lastChecked),
    );
  }

  factory Channel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Channel(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      uploadPlaylistId: serializer.fromJson<String>(json['uploadPlaylistId']),
      thumbnailUrl: serializer.fromJson<String?>(json['thumbnailUrl']),
      category: serializer.fromJson<String>(json['category']),
      lastChecked: serializer.fromJson<DateTime?>(json['lastChecked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'uploadPlaylistId': serializer.toJson<String>(uploadPlaylistId),
      'thumbnailUrl': serializer.toJson<String?>(thumbnailUrl),
      'category': serializer.toJson<String>(category),
      'lastChecked': serializer.toJson<DateTime?>(lastChecked),
    };
  }

  Channel copyWith({
    String? id,
    String? name,
    String? uploadPlaylistId,
    Value<String?> thumbnailUrl = const Value.absent(),
    String? category,
    Value<DateTime?> lastChecked = const Value.absent(),
  }) => Channel(
    id: id ?? this.id,
    name: name ?? this.name,
    uploadPlaylistId: uploadPlaylistId ?? this.uploadPlaylistId,
    thumbnailUrl: thumbnailUrl.present ? thumbnailUrl.value : this.thumbnailUrl,
    category: category ?? this.category,
    lastChecked: lastChecked.present ? lastChecked.value : this.lastChecked,
  );
  Channel copyWithCompanion(ChannelsCompanion data) {
    return Channel(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      uploadPlaylistId: data.uploadPlaylistId.present
          ? data.uploadPlaylistId.value
          : this.uploadPlaylistId,
      thumbnailUrl: data.thumbnailUrl.present
          ? data.thumbnailUrl.value
          : this.thumbnailUrl,
      category: data.category.present ? data.category.value : this.category,
      lastChecked: data.lastChecked.present
          ? data.lastChecked.value
          : this.lastChecked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Channel(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('uploadPlaylistId: $uploadPlaylistId, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('category: $category, ')
          ..write('lastChecked: $lastChecked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    uploadPlaylistId,
    thumbnailUrl,
    category,
    lastChecked,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Channel &&
          other.id == this.id &&
          other.name == this.name &&
          other.uploadPlaylistId == this.uploadPlaylistId &&
          other.thumbnailUrl == this.thumbnailUrl &&
          other.category == this.category &&
          other.lastChecked == this.lastChecked);
}

class ChannelsCompanion extends UpdateCompanion<Channel> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> uploadPlaylistId;
  final Value<String?> thumbnailUrl;
  final Value<String> category;
  final Value<DateTime?> lastChecked;
  final Value<int> rowid;
  const ChannelsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.uploadPlaylistId = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.category = const Value.absent(),
    this.lastChecked = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChannelsCompanion.insert({
    required String id,
    required String name,
    required String uploadPlaylistId,
    this.thumbnailUrl = const Value.absent(),
    this.category = const Value.absent(),
    this.lastChecked = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       uploadPlaylistId = Value(uploadPlaylistId);
  static Insertable<Channel> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? uploadPlaylistId,
    Expression<String>? thumbnailUrl,
    Expression<String>? category,
    Expression<DateTime>? lastChecked,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (uploadPlaylistId != null) 'upload_playlist_id': uploadPlaylistId,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      if (category != null) 'category': category,
      if (lastChecked != null) 'last_checked': lastChecked,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChannelsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? uploadPlaylistId,
    Value<String?>? thumbnailUrl,
    Value<String>? category,
    Value<DateTime?>? lastChecked,
    Value<int>? rowid,
  }) {
    return ChannelsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      uploadPlaylistId: uploadPlaylistId ?? this.uploadPlaylistId,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      category: category ?? this.category,
      lastChecked: lastChecked ?? this.lastChecked,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (uploadPlaylistId.present) {
      map['upload_playlist_id'] = Variable<String>(uploadPlaylistId.value);
    }
    if (thumbnailUrl.present) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (lastChecked.present) {
      map['last_checked'] = Variable<DateTime>(lastChecked.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChannelsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('uploadPlaylistId: $uploadPlaylistId, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('category: $category, ')
          ..write('lastChecked: $lastChecked, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FilterRulesTable extends FilterRules
    with TableInfo<$FilterRulesTable, FilterRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FilterRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
    'channel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES channels (id)',
    ),
  );
  static const VerificationMeta _keywordMeta = const VerificationMeta(
    'keyword',
  );
  @override
  late final GeneratedColumn<String> keyword = GeneratedColumn<String>(
    'keyword',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, channelId, keyword, type];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'filter_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<FilterRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('keyword')) {
      context.handle(
        _keywordMeta,
        keyword.isAcceptableOrUnknown(data['keyword']!, _keywordMeta),
      );
    } else if (isInserting) {
      context.missing(_keywordMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FilterRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FilterRule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_id'],
      )!,
      keyword: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}keyword'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
    );
  }

  @override
  $FilterRulesTable createAlias(String alias) {
    return $FilterRulesTable(attachedDatabase, alias);
  }
}

class FilterRule extends DataClass implements Insertable<FilterRule> {
  final int id;
  final String channelId;
  final String keyword;
  final int type;
  const FilterRule({
    required this.id,
    required this.channelId,
    required this.keyword,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['channel_id'] = Variable<String>(channelId);
    map['keyword'] = Variable<String>(keyword);
    map['type'] = Variable<int>(type);
    return map;
  }

  FilterRulesCompanion toCompanion(bool nullToAbsent) {
    return FilterRulesCompanion(
      id: Value(id),
      channelId: Value(channelId),
      keyword: Value(keyword),
      type: Value(type),
    );
  }

  factory FilterRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FilterRule(
      id: serializer.fromJson<int>(json['id']),
      channelId: serializer.fromJson<String>(json['channelId']),
      keyword: serializer.fromJson<String>(json['keyword']),
      type: serializer.fromJson<int>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'channelId': serializer.toJson<String>(channelId),
      'keyword': serializer.toJson<String>(keyword),
      'type': serializer.toJson<int>(type),
    };
  }

  FilterRule copyWith({
    int? id,
    String? channelId,
    String? keyword,
    int? type,
  }) => FilterRule(
    id: id ?? this.id,
    channelId: channelId ?? this.channelId,
    keyword: keyword ?? this.keyword,
    type: type ?? this.type,
  );
  FilterRule copyWithCompanion(FilterRulesCompanion data) {
    return FilterRule(
      id: data.id.present ? data.id.value : this.id,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      keyword: data.keyword.present ? data.keyword.value : this.keyword,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FilterRule(')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('keyword: $keyword, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, channelId, keyword, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FilterRule &&
          other.id == this.id &&
          other.channelId == this.channelId &&
          other.keyword == this.keyword &&
          other.type == this.type);
}

class FilterRulesCompanion extends UpdateCompanion<FilterRule> {
  final Value<int> id;
  final Value<String> channelId;
  final Value<String> keyword;
  final Value<int> type;
  const FilterRulesCompanion({
    this.id = const Value.absent(),
    this.channelId = const Value.absent(),
    this.keyword = const Value.absent(),
    this.type = const Value.absent(),
  });
  FilterRulesCompanion.insert({
    this.id = const Value.absent(),
    required String channelId,
    required String keyword,
    this.type = const Value.absent(),
  }) : channelId = Value(channelId),
       keyword = Value(keyword);
  static Insertable<FilterRule> custom({
    Expression<int>? id,
    Expression<String>? channelId,
    Expression<String>? keyword,
    Expression<int>? type,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (channelId != null) 'channel_id': channelId,
      if (keyword != null) 'keyword': keyword,
      if (type != null) 'type': type,
    });
  }

  FilterRulesCompanion copyWith({
    Value<int>? id,
    Value<String>? channelId,
    Value<String>? keyword,
    Value<int>? type,
  }) {
    return FilterRulesCompanion(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      keyword: keyword ?? this.keyword,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (keyword.present) {
      map['keyword'] = Variable<String>(keyword.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FilterRulesCompanion(')
          ..write('id: $id, ')
          ..write('channelId: $channelId, ')
          ..write('keyword: $keyword, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $MatchedVideosTable extends MatchedVideos
    with TableInfo<$MatchedVideosTable, MatchedVideo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MatchedVideosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thumbnailUrlMeta = const VerificationMeta(
    'thumbnailUrl',
  );
  @override
  late final GeneratedColumn<String> thumbnailUrl = GeneratedColumn<String>(
    'thumbnail_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _publishedAtMeta = const VerificationMeta(
    'publishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
    'published_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _channelIdMeta = const VerificationMeta(
    'channelId',
  );
  @override
  late final GeneratedColumn<String> channelId = GeneratedColumn<String>(
    'channel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES channels (id)',
    ),
  );
  static const VerificationMeta _matchedKeywordMeta = const VerificationMeta(
    'matchedKeyword',
  );
  @override
  late final GeneratedColumn<String> matchedKeyword = GeneratedColumn<String>(
    'matched_keyword',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isBookmarkedMeta = const VerificationMeta(
    'isBookmarked',
  );
  @override
  late final GeneratedColumn<bool> isBookmarked = GeneratedColumn<bool>(
    'is_bookmarked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_bookmarked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    thumbnailUrl,
    publishedAt,
    channelId,
    matchedKeyword,
    isBookmarked,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'matched_videos';
  @override
  VerificationContext validateIntegrity(
    Insertable<MatchedVideo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('thumbnail_url')) {
      context.handle(
        _thumbnailUrlMeta,
        thumbnailUrl.isAcceptableOrUnknown(
          data['thumbnail_url']!,
          _thumbnailUrlMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_thumbnailUrlMeta);
    }
    if (data.containsKey('published_at')) {
      context.handle(
        _publishedAtMeta,
        publishedAt.isAcceptableOrUnknown(
          data['published_at']!,
          _publishedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_publishedAtMeta);
    }
    if (data.containsKey('channel_id')) {
      context.handle(
        _channelIdMeta,
        channelId.isAcceptableOrUnknown(data['channel_id']!, _channelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_channelIdMeta);
    }
    if (data.containsKey('matched_keyword')) {
      context.handle(
        _matchedKeywordMeta,
        matchedKeyword.isAcceptableOrUnknown(
          data['matched_keyword']!,
          _matchedKeywordMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_matchedKeywordMeta);
    }
    if (data.containsKey('is_bookmarked')) {
      context.handle(
        _isBookmarkedMeta,
        isBookmarked.isAcceptableOrUnknown(
          data['is_bookmarked']!,
          _isBookmarkedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MatchedVideo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MatchedVideo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      thumbnailUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_url'],
      )!,
      publishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}published_at'],
      )!,
      channelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel_id'],
      )!,
      matchedKeyword: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}matched_keyword'],
      )!,
      isBookmarked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_bookmarked'],
      )!,
    );
  }

  @override
  $MatchedVideosTable createAlias(String alias) {
    return $MatchedVideosTable(attachedDatabase, alias);
  }
}

class MatchedVideo extends DataClass implements Insertable<MatchedVideo> {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final DateTime publishedAt;
  final String channelId;
  final String matchedKeyword;
  final bool isBookmarked;
  const MatchedVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.publishedAt,
    required this.channelId,
    required this.matchedKeyword,
    required this.isBookmarked,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['thumbnail_url'] = Variable<String>(thumbnailUrl);
    map['published_at'] = Variable<DateTime>(publishedAt);
    map['channel_id'] = Variable<String>(channelId);
    map['matched_keyword'] = Variable<String>(matchedKeyword);
    map['is_bookmarked'] = Variable<bool>(isBookmarked);
    return map;
  }

  MatchedVideosCompanion toCompanion(bool nullToAbsent) {
    return MatchedVideosCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      thumbnailUrl: Value(thumbnailUrl),
      publishedAt: Value(publishedAt),
      channelId: Value(channelId),
      matchedKeyword: Value(matchedKeyword),
      isBookmarked: Value(isBookmarked),
    );
  }

  factory MatchedVideo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MatchedVideo(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      thumbnailUrl: serializer.fromJson<String>(json['thumbnailUrl']),
      publishedAt: serializer.fromJson<DateTime>(json['publishedAt']),
      channelId: serializer.fromJson<String>(json['channelId']),
      matchedKeyword: serializer.fromJson<String>(json['matchedKeyword']),
      isBookmarked: serializer.fromJson<bool>(json['isBookmarked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'thumbnailUrl': serializer.toJson<String>(thumbnailUrl),
      'publishedAt': serializer.toJson<DateTime>(publishedAt),
      'channelId': serializer.toJson<String>(channelId),
      'matchedKeyword': serializer.toJson<String>(matchedKeyword),
      'isBookmarked': serializer.toJson<bool>(isBookmarked),
    };
  }

  MatchedVideo copyWith({
    String? id,
    String? title,
    String? description,
    String? thumbnailUrl,
    DateTime? publishedAt,
    String? channelId,
    String? matchedKeyword,
    bool? isBookmarked,
  }) => MatchedVideo(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    publishedAt: publishedAt ?? this.publishedAt,
    channelId: channelId ?? this.channelId,
    matchedKeyword: matchedKeyword ?? this.matchedKeyword,
    isBookmarked: isBookmarked ?? this.isBookmarked,
  );
  MatchedVideo copyWithCompanion(MatchedVideosCompanion data) {
    return MatchedVideo(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      thumbnailUrl: data.thumbnailUrl.present
          ? data.thumbnailUrl.value
          : this.thumbnailUrl,
      publishedAt: data.publishedAt.present
          ? data.publishedAt.value
          : this.publishedAt,
      channelId: data.channelId.present ? data.channelId.value : this.channelId,
      matchedKeyword: data.matchedKeyword.present
          ? data.matchedKeyword.value
          : this.matchedKeyword,
      isBookmarked: data.isBookmarked.present
          ? data.isBookmarked.value
          : this.isBookmarked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MatchedVideo(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('channelId: $channelId, ')
          ..write('matchedKeyword: $matchedKeyword, ')
          ..write('isBookmarked: $isBookmarked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    thumbnailUrl,
    publishedAt,
    channelId,
    matchedKeyword,
    isBookmarked,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MatchedVideo &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.thumbnailUrl == this.thumbnailUrl &&
          other.publishedAt == this.publishedAt &&
          other.channelId == this.channelId &&
          other.matchedKeyword == this.matchedKeyword &&
          other.isBookmarked == this.isBookmarked);
}

class MatchedVideosCompanion extends UpdateCompanion<MatchedVideo> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> thumbnailUrl;
  final Value<DateTime> publishedAt;
  final Value<String> channelId;
  final Value<String> matchedKeyword;
  final Value<bool> isBookmarked;
  final Value<int> rowid;
  const MatchedVideosCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.channelId = const Value.absent(),
    this.matchedKeyword = const Value.absent(),
    this.isBookmarked = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MatchedVideosCompanion.insert({
    required String id,
    required String title,
    required String description,
    required String thumbnailUrl,
    required DateTime publishedAt,
    required String channelId,
    required String matchedKeyword,
    this.isBookmarked = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       description = Value(description),
       thumbnailUrl = Value(thumbnailUrl),
       publishedAt = Value(publishedAt),
       channelId = Value(channelId),
       matchedKeyword = Value(matchedKeyword);
  static Insertable<MatchedVideo> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? thumbnailUrl,
    Expression<DateTime>? publishedAt,
    Expression<String>? channelId,
    Expression<String>? matchedKeyword,
    Expression<bool>? isBookmarked,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      if (publishedAt != null) 'published_at': publishedAt,
      if (channelId != null) 'channel_id': channelId,
      if (matchedKeyword != null) 'matched_keyword': matchedKeyword,
      if (isBookmarked != null) 'is_bookmarked': isBookmarked,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MatchedVideosCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? description,
    Value<String>? thumbnailUrl,
    Value<DateTime>? publishedAt,
    Value<String>? channelId,
    Value<String>? matchedKeyword,
    Value<bool>? isBookmarked,
    Value<int>? rowid,
  }) {
    return MatchedVideosCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      channelId: channelId ?? this.channelId,
      matchedKeyword: matchedKeyword ?? this.matchedKeyword,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (thumbnailUrl.present) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (channelId.present) {
      map['channel_id'] = Variable<String>(channelId.value);
    }
    if (matchedKeyword.present) {
      map['matched_keyword'] = Variable<String>(matchedKeyword.value);
    }
    if (isBookmarked.present) {
      map['is_bookmarked'] = Variable<bool>(isBookmarked.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MatchedVideosCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('channelId: $channelId, ')
          ..write('matchedKeyword: $matchedKeyword, ')
          ..write('isBookmarked: $isBookmarked, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ChannelsTable channels = $ChannelsTable(this);
  late final $FilterRulesTable filterRules = $FilterRulesTable(this);
  late final $MatchedVideosTable matchedVideos = $MatchedVideosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    channels,
    filterRules,
    matchedVideos,
  ];
}

typedef $$ChannelsTableCreateCompanionBuilder =
    ChannelsCompanion Function({
      required String id,
      required String name,
      required String uploadPlaylistId,
      Value<String?> thumbnailUrl,
      Value<String> category,
      Value<DateTime?> lastChecked,
      Value<int> rowid,
    });
typedef $$ChannelsTableUpdateCompanionBuilder =
    ChannelsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> uploadPlaylistId,
      Value<String?> thumbnailUrl,
      Value<String> category,
      Value<DateTime?> lastChecked,
      Value<int> rowid,
    });

final class $$ChannelsTableReferences
    extends BaseReferences<_$AppDatabase, $ChannelsTable, Channel> {
  $$ChannelsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FilterRulesTable, List<FilterRule>>
  _filterRulesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.filterRules,
    aliasName: $_aliasNameGenerator(db.channels.id, db.filterRules.channelId),
  );

  $$FilterRulesTableProcessedTableManager get filterRulesRefs {
    final manager = $$FilterRulesTableTableManager(
      $_db,
      $_db.filterRules,
    ).filter((f) => f.channelId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_filterRulesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MatchedVideosTable, List<MatchedVideo>>
  _matchedVideosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.matchedVideos,
    aliasName: $_aliasNameGenerator(db.channels.id, db.matchedVideos.channelId),
  );

  $$MatchedVideosTableProcessedTableManager get matchedVideosRefs {
    final manager = $$MatchedVideosTableTableManager(
      $_db,
      $_db.matchedVideos,
    ).filter((f) => f.channelId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_matchedVideosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ChannelsTableFilterComposer
    extends Composer<_$AppDatabase, $ChannelsTable> {
  $$ChannelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uploadPlaylistId => $composableBuilder(
    column: $table.uploadPlaylistId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastChecked => $composableBuilder(
    column: $table.lastChecked,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> filterRulesRefs(
    Expression<bool> Function($$FilterRulesTableFilterComposer f) f,
  ) {
    final $$FilterRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.filterRules,
      getReferencedColumn: (t) => t.channelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FilterRulesTableFilterComposer(
            $db: $db,
            $table: $db.filterRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> matchedVideosRefs(
    Expression<bool> Function($$MatchedVideosTableFilterComposer f) f,
  ) {
    final $$MatchedVideosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matchedVideos,
      getReferencedColumn: (t) => t.channelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchedVideosTableFilterComposer(
            $db: $db,
            $table: $db.matchedVideos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChannelsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChannelsTable> {
  $$ChannelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uploadPlaylistId => $composableBuilder(
    column: $table.uploadPlaylistId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastChecked => $composableBuilder(
    column: $table.lastChecked,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChannelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChannelsTable> {
  $$ChannelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get uploadPlaylistId => $composableBuilder(
    column: $table.uploadPlaylistId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get lastChecked => $composableBuilder(
    column: $table.lastChecked,
    builder: (column) => column,
  );

  Expression<T> filterRulesRefs<T extends Object>(
    Expression<T> Function($$FilterRulesTableAnnotationComposer a) f,
  ) {
    final $$FilterRulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.filterRules,
      getReferencedColumn: (t) => t.channelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FilterRulesTableAnnotationComposer(
            $db: $db,
            $table: $db.filterRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> matchedVideosRefs<T extends Object>(
    Expression<T> Function($$MatchedVideosTableAnnotationComposer a) f,
  ) {
    final $$MatchedVideosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.matchedVideos,
      getReferencedColumn: (t) => t.channelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MatchedVideosTableAnnotationComposer(
            $db: $db,
            $table: $db.matchedVideos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChannelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChannelsTable,
          Channel,
          $$ChannelsTableFilterComposer,
          $$ChannelsTableOrderingComposer,
          $$ChannelsTableAnnotationComposer,
          $$ChannelsTableCreateCompanionBuilder,
          $$ChannelsTableUpdateCompanionBuilder,
          (Channel, $$ChannelsTableReferences),
          Channel,
          PrefetchHooks Function({bool filterRulesRefs, bool matchedVideosRefs})
        > {
  $$ChannelsTableTableManager(_$AppDatabase db, $ChannelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChannelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChannelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChannelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> uploadPlaylistId = const Value.absent(),
                Value<String?> thumbnailUrl = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<DateTime?> lastChecked = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelsCompanion(
                id: id,
                name: name,
                uploadPlaylistId: uploadPlaylistId,
                thumbnailUrl: thumbnailUrl,
                category: category,
                lastChecked: lastChecked,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String uploadPlaylistId,
                Value<String?> thumbnailUrl = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<DateTime?> lastChecked = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChannelsCompanion.insert(
                id: id,
                name: name,
                uploadPlaylistId: uploadPlaylistId,
                thumbnailUrl: thumbnailUrl,
                category: category,
                lastChecked: lastChecked,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChannelsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({filterRulesRefs = false, matchedVideosRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (filterRulesRefs) db.filterRules,
                    if (matchedVideosRefs) db.matchedVideos,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (filterRulesRefs)
                        await $_getPrefetchedData<
                          Channel,
                          $ChannelsTable,
                          FilterRule
                        >(
                          currentTable: table,
                          referencedTable: $$ChannelsTableReferences
                              ._filterRulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChannelsTableReferences(
                                db,
                                table,
                                p0,
                              ).filterRulesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.channelId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (matchedVideosRefs)
                        await $_getPrefetchedData<
                          Channel,
                          $ChannelsTable,
                          MatchedVideo
                        >(
                          currentTable: table,
                          referencedTable: $$ChannelsTableReferences
                              ._matchedVideosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChannelsTableReferences(
                                db,
                                table,
                                p0,
                              ).matchedVideosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.channelId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ChannelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChannelsTable,
      Channel,
      $$ChannelsTableFilterComposer,
      $$ChannelsTableOrderingComposer,
      $$ChannelsTableAnnotationComposer,
      $$ChannelsTableCreateCompanionBuilder,
      $$ChannelsTableUpdateCompanionBuilder,
      (Channel, $$ChannelsTableReferences),
      Channel,
      PrefetchHooks Function({bool filterRulesRefs, bool matchedVideosRefs})
    >;
typedef $$FilterRulesTableCreateCompanionBuilder =
    FilterRulesCompanion Function({
      Value<int> id,
      required String channelId,
      required String keyword,
      Value<int> type,
    });
typedef $$FilterRulesTableUpdateCompanionBuilder =
    FilterRulesCompanion Function({
      Value<int> id,
      Value<String> channelId,
      Value<String> keyword,
      Value<int> type,
    });

final class $$FilterRulesTableReferences
    extends BaseReferences<_$AppDatabase, $FilterRulesTable, FilterRule> {
  $$FilterRulesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChannelsTable _channelIdTable(_$AppDatabase db) =>
      db.channels.createAlias(
        $_aliasNameGenerator(db.filterRules.channelId, db.channels.id),
      );

  $$ChannelsTableProcessedTableManager get channelId {
    final $_column = $_itemColumn<String>('channel_id')!;

    final manager = $$ChannelsTableTableManager(
      $_db,
      $_db.channels,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_channelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FilterRulesTableFilterComposer
    extends Composer<_$AppDatabase, $FilterRulesTable> {
  $$FilterRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keyword => $composableBuilder(
    column: $table.keyword,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  $$ChannelsTableFilterComposer get channelId {
    final $$ChannelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.channelId,
      referencedTable: $db.channels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChannelsTableFilterComposer(
            $db: $db,
            $table: $db.channels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FilterRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $FilterRulesTable> {
  $$FilterRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keyword => $composableBuilder(
    column: $table.keyword,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChannelsTableOrderingComposer get channelId {
    final $$ChannelsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.channelId,
      referencedTable: $db.channels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChannelsTableOrderingComposer(
            $db: $db,
            $table: $db.channels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FilterRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FilterRulesTable> {
  $$FilterRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get keyword =>
      $composableBuilder(column: $table.keyword, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  $$ChannelsTableAnnotationComposer get channelId {
    final $$ChannelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.channelId,
      referencedTable: $db.channels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChannelsTableAnnotationComposer(
            $db: $db,
            $table: $db.channels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FilterRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FilterRulesTable,
          FilterRule,
          $$FilterRulesTableFilterComposer,
          $$FilterRulesTableOrderingComposer,
          $$FilterRulesTableAnnotationComposer,
          $$FilterRulesTableCreateCompanionBuilder,
          $$FilterRulesTableUpdateCompanionBuilder,
          (FilterRule, $$FilterRulesTableReferences),
          FilterRule,
          PrefetchHooks Function({bool channelId})
        > {
  $$FilterRulesTableTableManager(_$AppDatabase db, $FilterRulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FilterRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FilterRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FilterRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> channelId = const Value.absent(),
                Value<String> keyword = const Value.absent(),
                Value<int> type = const Value.absent(),
              }) => FilterRulesCompanion(
                id: id,
                channelId: channelId,
                keyword: keyword,
                type: type,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String channelId,
                required String keyword,
                Value<int> type = const Value.absent(),
              }) => FilterRulesCompanion.insert(
                id: id,
                channelId: channelId,
                keyword: keyword,
                type: type,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FilterRulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({channelId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (channelId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.channelId,
                                referencedTable: $$FilterRulesTableReferences
                                    ._channelIdTable(db),
                                referencedColumn: $$FilterRulesTableReferences
                                    ._channelIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FilterRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FilterRulesTable,
      FilterRule,
      $$FilterRulesTableFilterComposer,
      $$FilterRulesTableOrderingComposer,
      $$FilterRulesTableAnnotationComposer,
      $$FilterRulesTableCreateCompanionBuilder,
      $$FilterRulesTableUpdateCompanionBuilder,
      (FilterRule, $$FilterRulesTableReferences),
      FilterRule,
      PrefetchHooks Function({bool channelId})
    >;
typedef $$MatchedVideosTableCreateCompanionBuilder =
    MatchedVideosCompanion Function({
      required String id,
      required String title,
      required String description,
      required String thumbnailUrl,
      required DateTime publishedAt,
      required String channelId,
      required String matchedKeyword,
      Value<bool> isBookmarked,
      Value<int> rowid,
    });
typedef $$MatchedVideosTableUpdateCompanionBuilder =
    MatchedVideosCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> description,
      Value<String> thumbnailUrl,
      Value<DateTime> publishedAt,
      Value<String> channelId,
      Value<String> matchedKeyword,
      Value<bool> isBookmarked,
      Value<int> rowid,
    });

final class $$MatchedVideosTableReferences
    extends BaseReferences<_$AppDatabase, $MatchedVideosTable, MatchedVideo> {
  $$MatchedVideosTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ChannelsTable _channelIdTable(_$AppDatabase db) =>
      db.channels.createAlias(
        $_aliasNameGenerator(db.matchedVideos.channelId, db.channels.id),
      );

  $$ChannelsTableProcessedTableManager get channelId {
    final $_column = $_itemColumn<String>('channel_id')!;

    final manager = $$ChannelsTableTableManager(
      $_db,
      $_db.channels,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_channelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MatchedVideosTableFilterComposer
    extends Composer<_$AppDatabase, $MatchedVideosTable> {
  $$MatchedVideosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get matchedKeyword => $composableBuilder(
    column: $table.matchedKeyword,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBookmarked => $composableBuilder(
    column: $table.isBookmarked,
    builder: (column) => ColumnFilters(column),
  );

  $$ChannelsTableFilterComposer get channelId {
    final $$ChannelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.channelId,
      referencedTable: $db.channels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChannelsTableFilterComposer(
            $db: $db,
            $table: $db.channels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MatchedVideosTableOrderingComposer
    extends Composer<_$AppDatabase, $MatchedVideosTable> {
  $$MatchedVideosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get matchedKeyword => $composableBuilder(
    column: $table.matchedKeyword,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBookmarked => $composableBuilder(
    column: $table.isBookmarked,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChannelsTableOrderingComposer get channelId {
    final $$ChannelsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.channelId,
      referencedTable: $db.channels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChannelsTableOrderingComposer(
            $db: $db,
            $table: $db.channels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MatchedVideosTableAnnotationComposer
    extends Composer<_$AppDatabase, $MatchedVideosTable> {
  $$MatchedVideosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get thumbnailUrl => $composableBuilder(
    column: $table.thumbnailUrl,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get matchedKeyword => $composableBuilder(
    column: $table.matchedKeyword,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isBookmarked => $composableBuilder(
    column: $table.isBookmarked,
    builder: (column) => column,
  );

  $$ChannelsTableAnnotationComposer get channelId {
    final $$ChannelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.channelId,
      referencedTable: $db.channels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChannelsTableAnnotationComposer(
            $db: $db,
            $table: $db.channels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MatchedVideosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MatchedVideosTable,
          MatchedVideo,
          $$MatchedVideosTableFilterComposer,
          $$MatchedVideosTableOrderingComposer,
          $$MatchedVideosTableAnnotationComposer,
          $$MatchedVideosTableCreateCompanionBuilder,
          $$MatchedVideosTableUpdateCompanionBuilder,
          (MatchedVideo, $$MatchedVideosTableReferences),
          MatchedVideo,
          PrefetchHooks Function({bool channelId})
        > {
  $$MatchedVideosTableTableManager(_$AppDatabase db, $MatchedVideosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MatchedVideosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MatchedVideosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MatchedVideosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> thumbnailUrl = const Value.absent(),
                Value<DateTime> publishedAt = const Value.absent(),
                Value<String> channelId = const Value.absent(),
                Value<String> matchedKeyword = const Value.absent(),
                Value<bool> isBookmarked = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MatchedVideosCompanion(
                id: id,
                title: title,
                description: description,
                thumbnailUrl: thumbnailUrl,
                publishedAt: publishedAt,
                channelId: channelId,
                matchedKeyword: matchedKeyword,
                isBookmarked: isBookmarked,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String description,
                required String thumbnailUrl,
                required DateTime publishedAt,
                required String channelId,
                required String matchedKeyword,
                Value<bool> isBookmarked = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MatchedVideosCompanion.insert(
                id: id,
                title: title,
                description: description,
                thumbnailUrl: thumbnailUrl,
                publishedAt: publishedAt,
                channelId: channelId,
                matchedKeyword: matchedKeyword,
                isBookmarked: isBookmarked,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MatchedVideosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({channelId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (channelId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.channelId,
                                referencedTable: $$MatchedVideosTableReferences
                                    ._channelIdTable(db),
                                referencedColumn: $$MatchedVideosTableReferences
                                    ._channelIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MatchedVideosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MatchedVideosTable,
      MatchedVideo,
      $$MatchedVideosTableFilterComposer,
      $$MatchedVideosTableOrderingComposer,
      $$MatchedVideosTableAnnotationComposer,
      $$MatchedVideosTableCreateCompanionBuilder,
      $$MatchedVideosTableUpdateCompanionBuilder,
      (MatchedVideo, $$MatchedVideosTableReferences),
      MatchedVideo,
      PrefetchHooks Function({bool channelId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ChannelsTableTableManager get channels =>
      $$ChannelsTableTableManager(_db, _db.channels);
  $$FilterRulesTableTableManager get filterRules =>
      $$FilterRulesTableTableManager(_db, _db.filterRules);
  $$MatchedVideosTableTableManager get matchedVideos =>
      $$MatchedVideosTableTableManager(_db, _db.matchedVideos);
}
