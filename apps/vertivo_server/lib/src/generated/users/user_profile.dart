/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:vertivo_server/src/generated/protocol.dart' as _i2;

abstract class UserProfile
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UserProfile._({
    this.id,
    required this.userId,
    required this.segment,
    this.familySize,
    this.dietaryPreferences,
    this.gardeningExperience,
    this.businessType,
    this.businessName,
    this.qualityRequirements,
    this.supplyChainGoals,
    this.complianceRequirements,
    this.sustainabilityGoals,
    this.erpIntegration,
    this.certifications,
    this.capabilities,
    this.workSchedule,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile({
    int? id,
    required String userId,
    required String segment,
    int? familySize,
    List<String>? dietaryPreferences,
    String? gardeningExperience,
    String? businessType,
    String? businessName,
    String? qualityRequirements,
    String? supplyChainGoals,
    List<String>? complianceRequirements,
    String? sustainabilityGoals,
    String? erpIntegration,
    List<String>? certifications,
    List<String>? capabilities,
    String? workSchedule,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserProfileImpl;

  factory UserProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfile(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      segment: jsonSerialization['segment'] as String,
      familySize: jsonSerialization['familySize'] as int?,
      dietaryPreferences: jsonSerialization['dietaryPreferences'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['dietaryPreferences'],
            ),
      gardeningExperience: jsonSerialization['gardeningExperience'] as String?,
      businessType: jsonSerialization['businessType'] as String?,
      businessName: jsonSerialization['businessName'] as String?,
      qualityRequirements: jsonSerialization['qualityRequirements'] as String?,
      supplyChainGoals: jsonSerialization['supplyChainGoals'] as String?,
      complianceRequirements:
          jsonSerialization['complianceRequirements'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['complianceRequirements'],
            ),
      sustainabilityGoals: jsonSerialization['sustainabilityGoals'] as String?,
      erpIntegration: jsonSerialization['erpIntegration'] as String?,
      certifications: jsonSerialization['certifications'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['certifications'],
            ),
      capabilities: jsonSerialization['capabilities'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['capabilities'],
            ),
      workSchedule: jsonSerialization['workSchedule'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = UserProfileTable();

  static const db = UserProfileRepository._();

  @override
  int? id;

  String userId;

  String segment;

  int? familySize;

  List<String>? dietaryPreferences;

  String? gardeningExperience;

  String? businessType;

  String? businessName;

  String? qualityRequirements;

  String? supplyChainGoals;

  List<String>? complianceRequirements;

  String? sustainabilityGoals;

  String? erpIntegration;

  List<String>? certifications;

  List<String>? capabilities;

  String? workSchedule;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserProfile copyWith({
    int? id,
    String? userId,
    String? segment,
    int? familySize,
    List<String>? dietaryPreferences,
    String? gardeningExperience,
    String? businessType,
    String? businessName,
    String? qualityRequirements,
    String? supplyChainGoals,
    List<String>? complianceRequirements,
    String? sustainabilityGoals,
    String? erpIntegration,
    List<String>? certifications,
    List<String>? capabilities,
    String? workSchedule,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserProfile',
      if (id != null) 'id': id,
      'userId': userId,
      'segment': segment,
      if (familySize != null) 'familySize': familySize,
      if (dietaryPreferences != null)
        'dietaryPreferences': dietaryPreferences?.toJson(),
      if (gardeningExperience != null)
        'gardeningExperience': gardeningExperience,
      if (businessType != null) 'businessType': businessType,
      if (businessName != null) 'businessName': businessName,
      if (qualityRequirements != null)
        'qualityRequirements': qualityRequirements,
      if (supplyChainGoals != null) 'supplyChainGoals': supplyChainGoals,
      if (complianceRequirements != null)
        'complianceRequirements': complianceRequirements?.toJson(),
      if (sustainabilityGoals != null)
        'sustainabilityGoals': sustainabilityGoals,
      if (erpIntegration != null) 'erpIntegration': erpIntegration,
      if (certifications != null) 'certifications': certifications?.toJson(),
      if (capabilities != null) 'capabilities': capabilities?.toJson(),
      if (workSchedule != null) 'workSchedule': workSchedule,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserProfile',
      if (id != null) 'id': id,
      'userId': userId,
      'segment': segment,
      if (familySize != null) 'familySize': familySize,
      if (dietaryPreferences != null)
        'dietaryPreferences': dietaryPreferences?.toJson(),
      if (gardeningExperience != null)
        'gardeningExperience': gardeningExperience,
      if (businessType != null) 'businessType': businessType,
      if (businessName != null) 'businessName': businessName,
      if (qualityRequirements != null)
        'qualityRequirements': qualityRequirements,
      if (supplyChainGoals != null) 'supplyChainGoals': supplyChainGoals,
      if (complianceRequirements != null)
        'complianceRequirements': complianceRequirements?.toJson(),
      if (sustainabilityGoals != null)
        'sustainabilityGoals': sustainabilityGoals,
      if (erpIntegration != null) 'erpIntegration': erpIntegration,
      if (certifications != null) 'certifications': certifications?.toJson(),
      if (capabilities != null) 'capabilities': capabilities?.toJson(),
      if (workSchedule != null) 'workSchedule': workSchedule,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static UserProfileInclude include() {
    return UserProfileInclude._();
  }

  static UserProfileIncludeList includeList({
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProfileTable>? orderByList,
    UserProfileInclude? include,
  }) {
    return UserProfileIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserProfile.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserProfile.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserProfileImpl extends UserProfile {
  _UserProfileImpl({
    int? id,
    required String userId,
    required String segment,
    int? familySize,
    List<String>? dietaryPreferences,
    String? gardeningExperience,
    String? businessType,
    String? businessName,
    String? qualityRequirements,
    String? supplyChainGoals,
    List<String>? complianceRequirements,
    String? sustainabilityGoals,
    String? erpIntegration,
    List<String>? certifications,
    List<String>? capabilities,
    String? workSchedule,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         segment: segment,
         familySize: familySize,
         dietaryPreferences: dietaryPreferences,
         gardeningExperience: gardeningExperience,
         businessType: businessType,
         businessName: businessName,
         qualityRequirements: qualityRequirements,
         supplyChainGoals: supplyChainGoals,
         complianceRequirements: complianceRequirements,
         sustainabilityGoals: sustainabilityGoals,
         erpIntegration: erpIntegration,
         certifications: certifications,
         capabilities: capabilities,
         workSchedule: workSchedule,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserProfile copyWith({
    Object? id = _Undefined,
    String? userId,
    String? segment,
    Object? familySize = _Undefined,
    Object? dietaryPreferences = _Undefined,
    Object? gardeningExperience = _Undefined,
    Object? businessType = _Undefined,
    Object? businessName = _Undefined,
    Object? qualityRequirements = _Undefined,
    Object? supplyChainGoals = _Undefined,
    Object? complianceRequirements = _Undefined,
    Object? sustainabilityGoals = _Undefined,
    Object? erpIntegration = _Undefined,
    Object? certifications = _Undefined,
    Object? capabilities = _Undefined,
    Object? workSchedule = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      segment: segment ?? this.segment,
      familySize: familySize is int? ? familySize : this.familySize,
      dietaryPreferences: dietaryPreferences is List<String>?
          ? dietaryPreferences
          : this.dietaryPreferences?.map((e0) => e0).toList(),
      gardeningExperience: gardeningExperience is String?
          ? gardeningExperience
          : this.gardeningExperience,
      businessType: businessType is String? ? businessType : this.businessType,
      businessName: businessName is String? ? businessName : this.businessName,
      qualityRequirements: qualityRequirements is String?
          ? qualityRequirements
          : this.qualityRequirements,
      supplyChainGoals: supplyChainGoals is String?
          ? supplyChainGoals
          : this.supplyChainGoals,
      complianceRequirements: complianceRequirements is List<String>?
          ? complianceRequirements
          : this.complianceRequirements?.map((e0) => e0).toList(),
      sustainabilityGoals: sustainabilityGoals is String?
          ? sustainabilityGoals
          : this.sustainabilityGoals,
      erpIntegration: erpIntegration is String?
          ? erpIntegration
          : this.erpIntegration,
      certifications: certifications is List<String>?
          ? certifications
          : this.certifications?.map((e0) => e0).toList(),
      capabilities: capabilities is List<String>?
          ? capabilities
          : this.capabilities?.map((e0) => e0).toList(),
      workSchedule: workSchedule is String? ? workSchedule : this.workSchedule,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserProfileUpdateTable extends _i1.UpdateTable<UserProfileTable> {
  UserProfileUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> segment(String value) => _i1.ColumnValue(
    table.segment,
    value,
  );

  _i1.ColumnValue<int, int> familySize(int? value) => _i1.ColumnValue(
    table.familySize,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> dietaryPreferences(
    List<String>? value,
  ) => _i1.ColumnValue(
    table.dietaryPreferences,
    value,
  );

  _i1.ColumnValue<String, String> gardeningExperience(String? value) =>
      _i1.ColumnValue(
        table.gardeningExperience,
        value,
      );

  _i1.ColumnValue<String, String> businessType(String? value) =>
      _i1.ColumnValue(
        table.businessType,
        value,
      );

  _i1.ColumnValue<String, String> businessName(String? value) =>
      _i1.ColumnValue(
        table.businessName,
        value,
      );

  _i1.ColumnValue<String, String> qualityRequirements(String? value) =>
      _i1.ColumnValue(
        table.qualityRequirements,
        value,
      );

  _i1.ColumnValue<String, String> supplyChainGoals(String? value) =>
      _i1.ColumnValue(
        table.supplyChainGoals,
        value,
      );

  _i1.ColumnValue<List<String>, List<String>> complianceRequirements(
    List<String>? value,
  ) => _i1.ColumnValue(
    table.complianceRequirements,
    value,
  );

  _i1.ColumnValue<String, String> sustainabilityGoals(String? value) =>
      _i1.ColumnValue(
        table.sustainabilityGoals,
        value,
      );

  _i1.ColumnValue<String, String> erpIntegration(String? value) =>
      _i1.ColumnValue(
        table.erpIntegration,
        value,
      );

  _i1.ColumnValue<List<String>, List<String>> certifications(
    List<String>? value,
  ) => _i1.ColumnValue(
    table.certifications,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> capabilities(
    List<String>? value,
  ) => _i1.ColumnValue(
    table.capabilities,
    value,
  );

  _i1.ColumnValue<String, String> workSchedule(String? value) =>
      _i1.ColumnValue(
        table.workSchedule,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class UserProfileTable extends _i1.Table<int?> {
  UserProfileTable({super.tableRelation}) : super(tableName: 'user_profiles') {
    updateTable = UserProfileUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    segment = _i1.ColumnString(
      'segment',
      this,
    );
    familySize = _i1.ColumnInt(
      'familySize',
      this,
    );
    dietaryPreferences = _i1.ColumnSerializable<List<String>>(
      'dietaryPreferences',
      this,
    );
    gardeningExperience = _i1.ColumnString(
      'gardeningExperience',
      this,
    );
    businessType = _i1.ColumnString(
      'businessType',
      this,
    );
    businessName = _i1.ColumnString(
      'businessName',
      this,
    );
    qualityRequirements = _i1.ColumnString(
      'qualityRequirements',
      this,
    );
    supplyChainGoals = _i1.ColumnString(
      'supplyChainGoals',
      this,
    );
    complianceRequirements = _i1.ColumnSerializable<List<String>>(
      'complianceRequirements',
      this,
    );
    sustainabilityGoals = _i1.ColumnString(
      'sustainabilityGoals',
      this,
    );
    erpIntegration = _i1.ColumnString(
      'erpIntegration',
      this,
    );
    certifications = _i1.ColumnSerializable<List<String>>(
      'certifications',
      this,
    );
    capabilities = _i1.ColumnSerializable<List<String>>(
      'capabilities',
      this,
    );
    workSchedule = _i1.ColumnString(
      'workSchedule',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final UserProfileUpdateTable updateTable;

  late final _i1.ColumnString userId;

  late final _i1.ColumnString segment;

  late final _i1.ColumnInt familySize;

  late final _i1.ColumnSerializable<List<String>> dietaryPreferences;

  late final _i1.ColumnString gardeningExperience;

  late final _i1.ColumnString businessType;

  late final _i1.ColumnString businessName;

  late final _i1.ColumnString qualityRequirements;

  late final _i1.ColumnString supplyChainGoals;

  late final _i1.ColumnSerializable<List<String>> complianceRequirements;

  late final _i1.ColumnString sustainabilityGoals;

  late final _i1.ColumnString erpIntegration;

  late final _i1.ColumnSerializable<List<String>> certifications;

  late final _i1.ColumnSerializable<List<String>> capabilities;

  late final _i1.ColumnString workSchedule;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    segment,
    familySize,
    dietaryPreferences,
    gardeningExperience,
    businessType,
    businessName,
    qualityRequirements,
    supplyChainGoals,
    complianceRequirements,
    sustainabilityGoals,
    erpIntegration,
    certifications,
    capabilities,
    workSchedule,
    createdAt,
    updatedAt,
  ];
}

class UserProfileInclude extends _i1.IncludeObject {
  UserProfileInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UserProfile.t;
}

class UserProfileIncludeList extends _i1.IncludeList {
  UserProfileIncludeList._({
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserProfile.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserProfile.t;
}

class UserProfileRepository {
  const UserProfileRepository._();

  /// Returns a list of [UserProfile]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<UserProfile>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProfileTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserProfile>(
      where: where?.call(UserProfile.t),
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserProfile] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<UserProfile?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProfileTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserProfile>(
      where: where?.call(UserProfile.t),
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserProfile] by its [id] or null if no such row exists.
  Future<UserProfile?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserProfile>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserProfile]s in the list and returns the inserted rows.
  ///
  /// The returned [UserProfile]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<UserProfile>> insert(
    _i1.Session session,
    List<UserProfile> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<UserProfile>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [UserProfile] and returns the inserted row.
  ///
  /// The returned [UserProfile] will have its `id` field set.
  Future<UserProfile> insertRow(
    _i1.Session session,
    UserProfile row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserProfile]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserProfile>> update(
    _i1.Session session,
    List<UserProfile> rows, {
    _i1.ColumnSelections<UserProfileTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserProfile>(
      rows,
      columns: columns?.call(UserProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserProfile]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserProfile> updateRow(
    _i1.Session session,
    UserProfile row, {
    _i1.ColumnSelections<UserProfileTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserProfile>(
      row,
      columns: columns?.call(UserProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserProfile] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserProfile?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<UserProfileUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserProfile>(
      id,
      columnValues: columnValues(UserProfile.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserProfile]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserProfile>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<UserProfileUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<UserProfileTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserProfileTable>? orderBy,
    _i1.OrderByListBuilder<UserProfileTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserProfile>(
      columnValues: columnValues(UserProfile.t.updateTable),
      where: where(UserProfile.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserProfile]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserProfile>> delete(
    _i1.Session session,
    List<UserProfile> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserProfile>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserProfile].
  Future<UserProfile> deleteRow(
    _i1.Session session,
    UserProfile row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserProfile>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserProfileTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserProfile>(
      where: where(UserProfile.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserProfile>(
      where: where?.call(UserProfile.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserProfile] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserProfileTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserProfile>(
      where: where(UserProfile.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
