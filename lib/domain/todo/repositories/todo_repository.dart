import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:flutter_supabase_workspace/core/supabase/supabase_postgres_change.dart';
import 'package:flutter_supabase_workspace/domain/todo/entities/todo_list/todo_list.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../entities/todo.dart';

final todoRepositoryProvider = riverpod.Provider.autoDispose((_) {
  return TodoRepository(Supabase.instance.client);
});

class TodoRepository {
  const TodoRepository(this._supabase);
  final SupabaseClient _supabase;

  static const String table = 'todos';

  Future<void> add({required String title}) async {
    try {
      await _supabase.from(table).insert({'title': title, 'is_done': false});
    } on Exception catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);
    }
  }

  Future<void> complete({required String id}) async {
    try {
      await _supabase.from(table).update({'is_done': true}).eq('id', id);
    } on Exception catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);
    }
  }

  Future<TodoList> list() async {
    try {
      final result = await _supabase
          .from(table)
          .select<PostgrestList>()
          .eq('is_done', false)
          .order('created_at', ascending: false);

      final todoList = result.map(Todo.fromJson).toList();

      return TodoList(list: todoList);
    } on Exception catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);
      return TodoList.empty();
    }
  }

  RealtimeChannel changes({
    void Function(SupabasePostgresChange<Todo> change)? onEvent,
  }) {
    return _supabase.channel('todo-list-changes').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(event: '*', table: 'todos', schema: 'public'),
      (payload, [ref]) {
        onEvent?.call(
          SupabasePostgresChange.fromPayload<Todo>(
            payload,
            fromJson: Todo.fromJson,
          ),
        );
      },
    );
  }
}
