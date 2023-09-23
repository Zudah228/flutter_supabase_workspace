import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:flutter_supabase_workspace/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseCoreProvider =
    riverpod.Provider.autoDispose((_) => SupabaseCore(Supabase.instance));

class SupabaseCore {
  const SupabaseCore(this._supabase);

  final Supabase _supabase;

  static Future<void> init() async {
    await Supabase.initialize(
      url: supabaseSettings.url,
      anonKey: supabaseSettings.apiKey,
    );
  }

  T run<T>(T Function(SupabaseClient supabase) handler) {
    try {
      return handler(_supabase.client);
    } on Exception catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);

      rethrow;
    }
  }

  T runSync<T>(T Function(SupabaseClient supabase) handler) {
    try {
      return handler(_supabase.client);
    } on Exception catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);

      rethrow;
    }
  }
}
