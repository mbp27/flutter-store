import 'package:collection/collection.dart';
import 'package:pitjarusstore/data/models/store.dart';
import 'package:pitjarusstore/data/providers/store_provider.dart';
import 'package:pitjarusstore/data/providers/store_visit_provider.dart';
import 'package:pitjarusstore/data/repositories/store_visit_repository.dart';

class StoreRepository {
  final _storeProvider = StoreProvider();
  final _storeVisitRepository = StoreVisitRepository();

  Future<List<Object?>> batchInsert(List<Store> stores) =>
      _storeProvider.batchInsert(stores);

  Future<Store> insert(Store store) => _storeProvider.insert(store);

  Future<List<Store>> getStores() async {
    try {
      final data = await _storeProvider.getStores();
      final list = data.map((e) => Store.fromMap(e)).toList();
      await Future.forEach(list, (element) async {
        final index = list.indexWhere((l) => l.id == element.id);
        final storeId = element.storeId;
        if (storeId == null) throw 'Terdapat kesalahan';
        final storeVisits = await _storeVisitRepository.getStoreVisits(
          storeId,
          where:
              '${StoreVisitProvider.columnDate} > ? AND ${StoreVisitProvider.columnDate} < ? ',
          whereArgs: [
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ).millisecondsSinceEpoch,
            DateTime.now().millisecondsSinceEpoch
          ],
          limit: 1,
        );
        list[index] = element.copyWith(storeVisit: storeVisits.firstOrNull);
      });
      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<Store?> getStoreDetail(int id) async {
    try {
      final data = await _storeProvider.getStoreDetail(id);
      if (data != null) {
        final store = Store.fromMap(data);
        final storeId = store.storeId;
        if (storeId == null) throw 'Terdapat kesalahan';
        final storeVisits = await _storeVisitRepository.getStoreVisits(
          storeId,
          where:
              '${StoreVisitProvider.columnDate} > ? AND ${StoreVisitProvider.columnDate} < ? ',
          whereArgs: [
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ).millisecondsSinceEpoch,
            DateTime.now().millisecondsSinceEpoch
          ],
          limit: 1,
        );
        return store.copyWith(
          storeVisit: storeVisits.firstOrNull,
        );
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<int?> delete(int id) => _storeProvider.delete(id);

  Future<void> clear() => _storeProvider.clear();

  Future close() => _storeProvider.close();
}
