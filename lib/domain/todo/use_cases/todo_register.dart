import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_workspace/domain/todo/repositories/todo_repository.dart';

final todoRegisterProvider = Provider.autoDispose(TodoRegister.new);

class TodoRegister {
  const TodoRegister(this._ref);
  final Ref _ref;

  Future<void> call({required String title}) async {
    await _ref.read(todoRepositoryProvider).add(title: title);
  }
}
