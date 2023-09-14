import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_workspace/app.dart';
import 'package:flutter_supabase_workspace/core/supabase/supabase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Intl.defaultLocale = 'ja_JP';
  final container = ProviderContainer();

  await SupabaseCore.init();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const App(),
    ),
  );
}
