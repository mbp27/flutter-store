import 'package:pitjarusstore/data/models/store_visit.dart';
import 'package:pitjarusstore/data/providers/store_visit_provider.dart';

class StoreVisitRepository {
  final _storeVisitProvider = StoreVisitProvider();

  Future<List<Object?>> batchInsert(List<StoreVisit> storeVisits) =>
      _storeVisitProvider.batchInsert(storeVisits);

  Future<StoreVisit> insert(StoreVisit storeVisit) =>
      _storeVisitProvider.insert(storeVisit);

  Future<List<StoreVisit>> getStoreVisits(
    String storeId, {
    String? where,
    List<Object?>? whereArgs,
    int? limit,
    String? orderBy,
  }) async {
    try {
      final data = await _storeVisitProvider.getStoreVisits(
        storeId,
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: limit,
      );
      return data.map((e) => StoreVisit.fromMap(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<StoreVisit?> getStoreVisitDetail(int id) async {
    try {
      final data = await _storeVisitProvider.getStoreVisitDetail(id);
      if (data != null) {
        return StoreVisit.fromMap(data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<int?> delete(int id) => _storeVisitProvider.delete(id);

  Future<void> clear() => _storeVisitProvider.clear();

  Future close() => _storeVisitProvider.close();
}
