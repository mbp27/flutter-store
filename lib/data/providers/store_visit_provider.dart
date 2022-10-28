import 'package:pitjarusstore/data/models/store_visit.dart';
import 'package:pitjarusstore/data/providers/db_provider.dart';

class StoreVisitProvider {
  final DBProvider _dbProvider = DBProvider();

  static const String tableStoreVisit = 'store_visit';
  static const String columnId = '_id';
  static const String columnStoreId = 'store_id';
  static const String columnType = 'type';
  static const String columnDate = 'date';
  static const String columnLatitude = 'latitude';
  static const String columnLongitude = 'longitude';

  static const String create = "CREATE TABLE IF NOT EXISTS $tableStoreVisit ("
      "$columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
      "$columnStoreId TEXT NOT NULL,"
      "$columnType TEXT NOT NULL,"
      "$columnDate INTEGER NOT NULL,"
      "$columnLatitude TEXT NOT NULL,"
      "$columnLongitude TEXT NOT NULL"
      ")";

  Future<List<Object?>> batchInsert(List<StoreVisit> storeVisits) async {
    try {
      final batch = (await _dbProvider.database).batch();
      await Future.forEach(
        storeVisits,
        (element) => batch.insert(tableStoreVisit, element.toMap()),
      );
      return batch.commit();
    } catch (e) {
      rethrow;
    }
  }

  Future<StoreVisit> insert(StoreVisit storeVisit) async {
    try {
      final id = await (await _dbProvider.database)
          .insert(tableStoreVisit, storeVisit.toMap());
      return storeVisit.copyWith(id: id);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getStoreVisits(
    String storeId, {
    int? limit,
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
  }) async {
    try {
      final wArgs = <Object?>[storeId];
      if (whereArgs != null) {
        wArgs.addAll(whereArgs);
      }
      return (await _dbProvider.database).query(
        tableStoreVisit,
        where: '$columnStoreId = ?${where != null ? ' AND $where' : ''}',
        whereArgs: wArgs.toList(),
        orderBy: orderBy ?? '$columnDate DESC',
        limit: limit,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getStoreVisitDetail(int id) async {
    try {
      final data = await (await _dbProvider.database).query(
        tableStoreVisit,
        where: '$columnId = ?',
        whereArgs: [id],
      );
      // final data = await (await _dbProvider.database).rawQuery('SELECT * FROM $tableStoreVisit JOIN ');
      if (data.isNotEmpty) {
        return data.first;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<int?> delete(int id) async {
    try {
      return await (await _dbProvider.database)
          .delete(tableStoreVisit, where: '$columnId = ?', whereArgs: [id]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clear() async {
    try {
      await (await _dbProvider.database)
          .execute("DELETE FROM $tableStoreVisit");
    } catch (e) {
      rethrow;
    }
  }

  Future close() async => (await _dbProvider.database).close();
}
