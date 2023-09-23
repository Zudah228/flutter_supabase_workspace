import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:flutter_supabase_workspace/infrastructure/supabase/supabase_core.dart';
import 'package:flutter_supabase_workspace/infrastructure/supabase/supabase_postgres_change.dart';
import 'package:flutter_supabase_workspace/domain/todo/entities/todo_list/todo_list.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../entities/todo/todo.dart';

final todoRepositoryProvider = riverpod.Provider.autoDispose((ref) {
  return TodoRepository(ref);
});

class TodoRepository {
  const TodoRepository(this._ref);

  final riverpod.Ref _ref;

  SupabaseCore get _supabase => _ref.read(supabaseCoreProvider);

  static const String table = 'todos';

  Future<void> add({required String title}) async {
    await _supabase.run(
      (client) => client.from(table).insert({'title': title, 'is_done': false}),
    );
  }

  Future<void> complete({required String id}) async {
    await _supabase.run(
      (client) => client.from(table).update({'is_done': true}).eq('id', id),
    );
  }

  Future<void> delete({required String id}) async {
    await _supabase.run(
      (client) => client.from(table).delete().eq('id', id),
    );
  }

  Future<TodoList> list() async {
    final result = await _supabase.run(
      (client) => client
          .from(table)
          .select<PostgrestList>()
          .eq('is_done', false)
          .order('created_at', ascending: false),
    );

    final todoList = result.map(Todo.fromJson).toList();

    return TodoList(list: todoList);
  }

  RealtimeChannel changes({
    void Function(SupabasePostgresChange<Todo> change)? onEvent,
  }) {
    return _supabase.run(
      (client) => client.channel('todo-list-changes').on(
        RealtimeListenTypes.postgresChanges,
        ChannelFilter(
          event: '*',
          table: 'todos',
          schema: 'public',
        ),
        (payload, [ref]) {
          onEvent?.call(
            SupabasePostgresChange.fromPayload<Todo>(
              payload,
              fromJson: Todo.fromJson,
              getPrimaryKey: Todo.getPrimaryKey,
            ),
          );
        },
      ),
    );
  }
}
