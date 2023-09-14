import 'package:flutter_supabase_workspace/core/supabase/supabase_postgres_change.dart';

import '../todo.dart';

class TodoList {
  TodoList({required List<Todo> list})
      : listWithPostgresChanges = list
            .map(
              (e) => SupabasePostgresInitialChange<Todo>(
                data: e,
                timestamp: DateTime.now(),
              ),
            )
            .toList();

  TodoList.withPostgresChanges({required this.listWithPostgresChanges});

  factory TodoList.empty() => TodoList(list: []);

  List<Todo> get visibleList => [
        for (final changes in listWithPostgresChanges)
          if (changes.data != null) changes.data!,
      ];

  final List<SupabasePostgresChange<Todo>> listWithPostgresChanges;

  TodoList added(SupabasePostgresChange<Todo> data) {
    return TodoList.withPostgresChanges(
      listWithPostgresChanges: [
        data,
        ...listWithPostgresChanges,
      ],
    );
  }
}
