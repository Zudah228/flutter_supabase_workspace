import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_workspace/domain/todo/repositories/todo_repository.dart';
import 'package:flutter_supabase_workspace/domain/todo/use_cases/todo_list.dart';
import 'package:flutter_supabase_workspace/domain/todo/use_cases/todo_register.dart';
import 'package:intl/intl.dart';

class TodoPage extends ConsumerStatefulWidget {
  const TodoPage({super.key});

  static const routeName = '/todo';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const TodoPage(),
    );
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TodoPageState();
}

class _TodoPageState extends ConsumerState<TodoPage> {
  final _textController = TextEditingController();

  @override
  void initState() {
    _textController.addListener(() {
      setState(() {});
    });

    ref.read(todoRepositoryProvider).changes().subscribe();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final todoListAsync = ref.watch(todoListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Todo')),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.transparent,
            title: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _textController,
                  ),
                ),
                const SizedBox(width: 24),
                ElevatedButton(
                  onPressed: _textController.text.isEmpty
                      ? null
                      : () async {
                          await ref.read(todoRegisterProvider)(
                            title: _textController.text,
                          );
                          _textController.clear();
                        },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
          SliverList.builder(
            itemCount: todoListAsync.valueOrNull?.visibleList.length ?? 0,
            itemBuilder: (context, index) {
              final todo = todoListAsync.value!.visibleList[index];

              return CheckboxListTile(
                value: todo.isDone,
                title: Text(todo.title),
                subtitle: Text(DateFormat.yMEd().format(todo.createdAt)),
                // TODO(tsuda): 完了済みにする処理
                onChanged: (_) {},
              );
            },
          ),
        ],
      ),
    );
  }
}
