import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_workspace/domain/todo/repositories/todo_repository.dart';

final todoDeleteProvider = Provider.autoDispose(TodoDelete.new);

class TodoDelete {
  const TodoDelete(this._ref);
  final Ref _ref;

  Future<void> call({
    required String id,
  }) async {
    await _ref.read(todoRepositoryProvider).delete(
          id: id,
        );
  }
}
