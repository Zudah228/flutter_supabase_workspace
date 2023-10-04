import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_workspace/app.dart';
import 'package:flutter_supabase_workspace/infrastructure/isar/isar_infrastructure.dart';
import 'package:flutter_supabase_workspace/infrastructure/supabase/supabase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Intl.defaultLocale = 'ja_JP';
  final container = ProviderContainer();
  
  try {
    await Future.wait([SupabaseCore.init(), IsarInfrastructure.init()]);
  } catch (e, s) {
    debugPrintStack(label: e.toString(), stackTrace: s);
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const App(),
    ),
  );
}
