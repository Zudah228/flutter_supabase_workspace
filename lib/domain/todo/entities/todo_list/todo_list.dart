import 'package:flutter_supabase_workspace/infrastructure/supabase/supabase_postgres_change.dart';

import '../todo/todo.dart';

class TodoList {
  TodoList({
    required List<Todo> list,
    this.fromCache = false,
  }) : listWithPostgresChanges = list
            .map(
              (e) => SupabasePostgresInitialChange<Todo>(
                data: e,
                timestamp: DateTime.now(),
              ),
            )
            .toList();

  TodoList.withPostgresChanges({
    required this.listWithPostgresChanges,
    this.fromCache = false,
  });

  factory TodoList.empty() => TodoList(list: []);

  List<SupabasePostgresChange<Todo>> get visibleList => [
        for (final changes in listWithPostgresChanges)
          if (changes.data != null) changes,
      ];

  final List<SupabasePostgresChange<Todo>> listWithPostgresChanges;
  final bool fromCache;

  TodoList added(SupabasePostgresChange<Todo> data) {
    return TodoList.withPostgresChanges(
      listWithPostgresChanges: switch (data) {
        SupabasePostgresDeleteChange() => [
            for (final e in listWithPostgresChanges)
              if (e.data?.id == data.primaryKey) data else e,
          ],
        SupabasePostgresUpdateChange() => [
            for (final e in listWithPostgresChanges)
              if (e.data?.id == data.data.id) data else e,
          ],
        _ => [data, ...listWithPostgresChanges],
      },
    );
  }
}
