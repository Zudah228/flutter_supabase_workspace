import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_workspace/infrastructure/isar/all_data_manager/all_data_manager.dart';
import 'package:flutter_supabase_workspace/utils/extensions/num_extension.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const routeName = '/settings';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const SettingsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: <Widget>[
          Consumer(
            builder: (context, ref, _) {
              final size = ref.watch(isarCacheSizeProvider);

              return ListTile(
                title: const Text('キャッシュ'),
                trailing: Text(size.toByteString()),
              );
            },
          ),
          Consumer(
            builder: (context, ref, _) {
              return ListTile(
                title: const Text('キャッシュクリア'),
                onTap: () {
                  ref.read(isarAllDataManagerProvider).clearAll();
                },
              );
            },
          ),
        ].indexed.map((e) {
          final (index, child) = e;

          return Padding(
            padding: EdgeInsets.only(
              top: index != 0 ? 16 : 0,
            ),
            child: child,
          );
        }).toList(),
      ),
    );
  }
}
