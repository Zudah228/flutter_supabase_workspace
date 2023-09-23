sealed class SupabasePostgresChange<T> {
  SupabasePostgresChange({required this.data, required this.timestamp});

  static SupabasePostgresChange<T> fromPayload<T>(
    dynamic payload, {
    required T Function(Map<String, dynamic> json) fromJson,
    required String Function(Map<String, dynamic> json) getPrimaryKey,
  }) {
    final data = payload as Map<String, dynamic>;

    final eventType = data['eventType'] as String;
    final timestamp = DateTime.parse(data['commit_timestamp'] as String);

    T getNew() => fromJson(data['new'] as Map<String, dynamic>);

    final result = switch (eventType) {
      'INSERT' => SupabasePostgresInsertChange(
          timestamp: timestamp,
          after: getNew(),
        ),
      'UPDATE' => SupabasePostgresUpdateChange(
          timestamp: timestamp,
          after: getNew(),
        ),
      'DELETE' => SupabasePostgresDeleteChange<T>(
          timestamp: timestamp,
          primaryKey: getPrimaryKey(data['old'] as Map<String, dynamic>),
        ),
      _ => throw UnsupportedError('payload の eventType の取得に失敗しました')
    };

    return result;
  }

  final T? data;
  final DateTime timestamp;

  void when({
    required void Function(SupabasePostgresInsertChange<T> change) onInsert,
    required void Function(SupabasePostgresUpdateChange<T> change) onUpdate,
    required void Function(SupabasePostgresDeleteChange<T> change) onDelete,
  });
}

class SupabasePostgresInitialChange<T> implements SupabasePostgresChange<T> {
  SupabasePostgresInitialChange({
    required this.data,
    required DateTime timestamp,
  }) : _timestamp = timestamp;

  @override
  final T data;
  final DateTime _timestamp;

  @override
  DateTime get timestamp => _timestamp;

  @override
  void when({
    required void Function(SupabasePostgresInsertChange<T> change) onInsert,
    required void Function(SupabasePostgresUpdateChange<T> change) onUpdate,
    required void Function(SupabasePostgresDeleteChange<T> change) onDelete,
  }) {}
}

class SupabasePostgresInsertChange<T> implements SupabasePostgresChange<T> {
  SupabasePostgresInsertChange({
    required this.after,
    required DateTime timestamp,
  }) : _timestamp = timestamp;

  final T after;
  final DateTime _timestamp;

  @override
  DateTime get timestamp => _timestamp;

  @override
  void when({
    required void Function(SupabasePostgresInsertChange<T> change) onInsert,
    required void Function(SupabasePostgresUpdateChange<T> change) onUpdate,
    required void Function(SupabasePostgresDeleteChange<T> change) onDelete,
  }) {
    onInsert(this);
  }

  @override
  T get data => after;
}

class SupabasePostgresUpdateChange<T> implements SupabasePostgresChange<T> {
  SupabasePostgresUpdateChange({
    required this.after,
    required DateTime timestamp,
  }) : _timestamp = timestamp;

  final T after;
  final DateTime _timestamp;

  @override
  DateTime get timestamp => _timestamp;

  @override
  void when({
    required void Function(SupabasePostgresInsertChange<T> change) onInsert,
    required void Function(SupabasePostgresUpdateChange<T> change) onUpdate,
    required void Function(SupabasePostgresDeleteChange<T> change) onDelete,
  }) {
    onUpdate(this);
  }

  @override
  T get data => after;
}

class SupabasePostgresDeleteChange<T> implements SupabasePostgresChange<T> {
  SupabasePostgresDeleteChange({
    required DateTime timestamp,
    required this.primaryKey,
  }) : _timestamp = timestamp;

  final DateTime _timestamp;

  final String primaryKey;

  @override
  DateTime get timestamp => _timestamp;

  @override
  void when({
    required void Function(SupabasePostgresInsertChange<T> change) onInsert,
    required void Function(SupabasePostgresUpdateChange<T> change) onUpdate,
    required void Function(SupabasePostgresDeleteChange<T> change) onDelete,
  }) {
    onDelete(this);
  }

  @override
  T? get data => null;
}
