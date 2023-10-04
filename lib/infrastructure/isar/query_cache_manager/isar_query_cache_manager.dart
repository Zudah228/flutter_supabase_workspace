import 'package:flutter_supabase_workspace/infrastructure/isar/isar_infrastructure.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

mixin IsarQueryCacheManager<T> {
  late final IsarInfrastructure _isar;
  late final int limit;
  late final String indexName;

  void init(
    IsarInfrastructure isar, {
    int? limit,
    required String indexName,
  }) {
    _isar = isar;
    this.limit = limit ?? 2 ^ 100000;
    this.indexName = indexName;
  }

  Future<void> saveCache(T data) async {
    await _isar.run(
      (isar) => isar.writeTxn(
        () => isar.collection<T>().putByIndex(indexName, data),
      ),
    );

    await removeCacheIfLimit();
  }

  Future<void> saveCacheAll(List<T> data) async {
    await _isar.run(
      (isar) => isar.writeTxn(
        () => isar.collection<T>().putAllByIndex(indexName, data),
      ),
    );

    await removeCacheIfLimit();
  }

  Future<void> removeCache(String index) async {
    return _isar.run(
      (isar) => isar.writeTxn(
        () => isar
            .collection<T>()
            .buildQuery<PostgrestList>(
              filter: FilterCondition.equalTo(property: 'id', value: index),
            )
            .deleteFirst(),
      ),
    );
  }

  Future<void> removeCacheIfLimit() async {
    return _isar.run(
      (isar) async => isar.writeTxn(
        () => isar.collection<T>().getSize().then(
          (size) async {
            if (size >= limit) {
              await isar.collection<T>().clear();
            }
          },
        ),
      ),
    );
  }

  R fetchCache<R>(R Function(Query<T> query) queryBuilder) {
    return _isar.runSync(
      (isar) => queryBuilder(
        isar.collection<T>().buildQuery<T>(),
      ),
    );
  }
}
