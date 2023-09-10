import 'package:flutter/material.dart';
import 'package:flutter_supabase_workspace/presentation/pages/todo/todo_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoPage(),
    );
  }
}
