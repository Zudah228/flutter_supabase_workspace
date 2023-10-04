import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_workspace/domain/todo/entities/todo_list/todo_list.dart';
import 'package:flutter_supabase_workspace/domain/todo/repositories/todo_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final todoListProvider =
    AsyncNotifierProvider.autoDispose<TodoListNotifier, TodoList>(
  TodoListNotifier.new,
);

class TodoListNotifier extends AutoDisposeAsyncNotifier<TodoList> {
  @override
  FutureOr<TodoList> build() {
    ref.onDispose(unsubscribeChangeListen);

    listenChange();

    return ref.watch(todoRepositoryProvider).list(
      fromCache: (todoList) {
        if (todoList.listWithPostgresChanges.isNotEmpty) {
          state = AsyncData(todoList);
        }
      },
    );
  }

  RealtimeChannel? _realtimeChannel;

  void listenChange() {
    _realtimeChannel = ref.read(todoRepositoryProvider).changes(
      onEvent: (change) {
        state = state.whenData((value) => value.added(change));
      },
    )..subscribe();
  }

  void unsubscribeChangeListen() {
    _realtimeChannel?.unsubscribe();
  }
}
