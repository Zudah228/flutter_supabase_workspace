import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_workspace/infrastructure/isar/isar_infrastructure.dart';

final isarAllDataManagerProvider = Provider.autoDispose(
  (ref) => IsarAllDataManager(ref, ref.watch(isarInfrastructureProvider)),
);

final isarCacheSizeProvider = Provider.autoDispose<int>(
  (ref) => ref.watch(isarAllDataManagerProvider).getSizeSync(),
);

class IsarAllDataManager {
  IsarAllDataManager(this._ref, this._isar);

  final Ref _ref;
  final IsarInfrastructure _isar;

  Future<void> clearAll() async {
    await _isar.run((isar) => isar.writeTxn(() => isar.clear()));

    _ref.invalidate(isarCacheSizeProvider);
  }

  Future<int> getSize() {
    return _isar.run(
      (isar) => isar.getSize(includeIndexes: true).then((value) => value),
    );
  }

  int getSizeSync() {
    return _isar.runSync(
      (isar) => isar.getSizeSync(includeIndexes: true),
    );
  }
}
