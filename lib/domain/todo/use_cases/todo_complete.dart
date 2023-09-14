import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_workspace/domain/todo/repositories/todo_repository.dart';

final todoCompleteProvider = Provider.autoDispose(TodoComplete.new);

class TodoComplete {
  const TodoComplete(this._ref);
  final Ref _ref;

  Future<void> call({required String id}) async {
    await _ref.read(todoRepositoryProvider).complete(id: id);
  }
}
