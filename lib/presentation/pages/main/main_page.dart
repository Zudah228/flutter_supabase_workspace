import 'package:flutter/material.dart';
import 'package:flutter_supabase_workspace/presentation/pages/todo/todo_page.dart';

import '../settings/settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static const routeName = '/main';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const MainPage(),
    );
  }

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    const pages = [TodoPage(), SettingsPage()];

    return Scaffold(
      body: Stack(
        children: pages.indexed.map((e) {
          final (index, page) = e;

          return Offstage(
            offstage: _currentPage != index,
            child: page,
          );
        }).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Todo'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (value) => setState(() {
          _currentPage = value;
        }),
      ),
    );
  }
}
