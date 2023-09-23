import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_workspace/domain/todo/entities/todo/todo.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart' as path_lib;

final isarInfrastructureProvider = Provider.autoDispose<IsarInfrastructure>(
  (_) => IsarInfrastructure.instance,
);

class IsarInfrastructure {
  const IsarInfrastructure(this._isar);

  final Isar _isar;

  static late final IsarInfrastructure instance;

  static Future<void> init() async {
    final directory = await path_lib.getApplicationDocumentsDirectory();
    final path = directory.path;

    const schemes = <CollectionSchema<dynamic>>[TodoSchema];

    if (schemes.isEmpty) {
      return;
    }

    final isar = await Isar.open(schemes, directory: path);

    instance = IsarInfrastructure(isar);
  }

  Future<T> run<T>(FutureOr<T> Function(Isar isar) run) async {
    try {
      return await run(_isar);
    } on Exception catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);

      rethrow;
    }
  }

  T runSync<T>(T Function(Isar isar) run) {
    try {
      return run(_isar);
    } on Exception catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);

      rethrow;
    }
  }
}
