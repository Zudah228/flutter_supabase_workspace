import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_workspace/app.dart';
import 'package:flutter_supabase_workspace/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseSettings.url,
    anonKey: supabaseSettings.apiKey,
  );

  // Intl.defaultLocale = 'ja_JP';

  runApp(const ProviderScope(child: App()));
}
