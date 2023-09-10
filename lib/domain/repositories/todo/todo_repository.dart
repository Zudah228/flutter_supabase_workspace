import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../entities/todo/todo.dart';

final todoRepository = riverpod.Provider.autoDispose((_) {
  return TodoRepository(Supabase.instance.client);
});

class TodoRepository {
  const TodoRepository(this._supabase);
  final SupabaseClient _supabase;

  static const String table = 'todos';

  Future<void> add({required String title}) async {
    await _supabase.from(table).insert({'title': title, 'is_done': false});
  }

  Future<List<Todo>> list() async {
    return _supabase
        .from(table)
        .select<PostgrestList>()
        .eq('is_done', false)
        .order('created_at', ascending: true)
        .withConverter(
          (data) => data.map(Todo.fromJson).toList(),
        );
  }
}
