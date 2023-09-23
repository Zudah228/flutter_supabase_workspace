import 'package:flutter_supabase_workspace/infrastructure/isar/isar_infrastructure.dart';
import 'package:isar/isar.dart';

class IsarQueryCacheManager<T> {
  IsarQueryCacheManager(this._isar);

  final IsarInfrastructure _isar;

  Future<void> save(T data) {
    return _isar.run(
      (isar) => isar.writeTxn(
        () => isar.collection<T>().put(data),
      ),
    );
  }

  Future<void> saveAll(List<T> data) {
    return _isar.run(
      (isar) => isar.writeTxn(
        () => isar.collection<T>().putAll(data),
      ),
    );
  }

  R fetch<R>(R Function(Query<T> query) buildQuery) {
    return _isar.runSync(
      (isar) => buildQuery(
        isar.collection<T>().buildQuery<T>(),
      ),
    );
  }
}
