import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_workspace/domain/todo/repositories/todo_repository.dart';
import 'package:flutter_supabase_workspace/domain/todo/use_cases/todo_complete.dart';
import 'package:flutter_supabase_workspace/domain/todo/use_cases/todo_delete.dart';
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

  final _cacheStrategy = AsyncCache<void>.ephemeral();

  Future<void> _save() async {
    try {
      await _cacheStrategy.fetch(
        () async {
          await ref.read(todoRegisterProvider)(
            title: _textController.text,
          );

          _textController.clear();
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final scaffoldBackgroundColor = theme.scaffoldBackgroundColor;

    final todoListAsync = ref.watch(
      todoListProvider,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Todo')),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: scaffoldBackgroundColor,
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _textController,
                    ),
                  ),
                  const SizedBox(width: 24),
                  FilledButton(
                    onPressed: _textController.text.isEmpty ? null : _save,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
          todoListAsync.when(
            data: (todoList) {
              if (todoList.visibleList.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      '👆 追加しようぜ 👆',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              } else {
                return SliverMainAxisGroup(
                  slivers: [
                    SliverList.builder(
                      itemCount: todoList.visibleList.length,
                      itemBuilder: (context, index) {
                        final todo = todoList.visibleList[index];

                        return Dismissible(
                          key: ValueKey(todo.data!.id),
                          confirmDismiss: (_) async {
                            try {
                              await ref.read(todoDeleteProvider)(
                                id: todo.data!.id,
                              );
                              return true;
                            } on Exception catch (_) {
                              return false;
                            }
                          },
                          background: ColoredBox(color: colorScheme.error),
                          child: CheckboxListTile(
                            value: todo.data!.isDone,
                            title: Text(todo.data!.title),
                            subtitle: Text(
                              DateFormat.yMEd().format(todo.data!.createdAt),
                            ),
                            onChanged: (_) {
                              ref.read(todoCompleteProvider)(id: todo.data!.id);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                );
              }
            },
            error: (_, __) {
              return SliverFillRemaining(
                child: Center(
                  child: Icon(
                    Icons.error,
                    color: colorScheme.error,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
