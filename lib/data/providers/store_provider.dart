import 'package:pitjarusstore/data/models/store.dart';
import 'package:pitjarusstore/data/providers/db_provider.dart';

class StoreProvider {
  final DBProvider _dbProvider = DBProvider();

  static const String tableStore = 'store';
  static const String columnId = '_id';
  static const String columnStoreId = 'store_id';
  static const String columnStoreCode = 'store_code';
  static const String columnStoreName = 'store_name';
  static const String columnAddress = 'address';
  static const String columnDcId = 'dc_id';
  static const String columnDcName = 'dc_name';
  static const String columnAccountId = 'account_id';
  static const String columnAccountName = 'account_name';
  static const String columnSubchannelId = 'subchannel_id';
  static const String columnSubchannelName = 'subchannel_name';
  static const String columnChannelId = 'channel_id';
  static const String columnChannelName = 'channel_name';
  static const String columnAreaId = 'area_id';
  static const String columnAreaName = 'area_name';
  static const String columnRegionId = 'region_id';
  static const String columnRegionName = 'region_name';
  static const String columnLatitude = 'latitude';
  static const String columnLongitude = 'longitude';

  static const String create = "CREATE TABLE IF NOT EXISTS $tableStore ("
      "$columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
      "$columnStoreId TEXT NOT NULL,"
      "$columnStoreCode TEXT NOT NULL,"
      "$columnStoreName TEXT NOT NULL,"
      "$columnAddress TEXT NOT NULL,"
      "$columnDcId TEXT NOT NULL,"
      "$columnDcName TEXT NOT NULL,"
      "$columnAccountId TEXT NOT NULL,"
      "$columnAccountName TEXT NOT NULL,"
      "$columnSubchannelId TEXT NOT NULL,"
      "$columnSubchannelName TEXT NOT NULL,"
      "$columnChannelId TEXT NOT NULL,"
      "$columnChannelName TEXT NOT NULL,"
      "$columnAreaId TEXT NOT NULL,"
      "$columnAreaName TEXT NOT NULL,"
      "$columnRegionId TEXT NOT NULL,"
      "$columnRegionName TEXT NOT NULL,"
      "$columnLatitude TEXT NOT NULL,"
      "$columnLongitude TEXT NOT NULL"
      ")";

  Future<List<Object?>> batchInsert(List<Store> stores) async {
    try {
      final batch = (await _dbProvider.database).batch();
      await Future.forEach(
        stores,
        (element) => batch.insert(tableStore, element.toMap()),
      );
      return batch.commit();
    } catch (e) {
      rethrow;
    }
  }

  Future<Store> insert(Store store) async {
    try {
      final id =
          await (await _dbProvider.database).insert(tableStore, store.toMap());
      return store.copyWith(id: id);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getStores() async {
    try {
      return (await _dbProvider.database).query(tableStore);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getStoreDetail(int id) async {
    try {
      final data = await (await _dbProvider.database).query(
        tableStore,
        where: '$columnId = ?',
        whereArgs: [id],
      );
      // final data = await (await _dbProvider.database).rawQuery(
      //   "SELECT $tableStore.*, json_group_object("
      //   "'store_visit',"
      //   "json_object('${StoreVisitProvider.columnDate}', ${StoreVisitProvider.columnDate})"
      //   ") AS json_result FROM $tableStore LEFT JOIN ${StoreVisitProvider.tableStoreVisit} "
      //   "ON ${StoreVisitProvider.tableStoreVisit}.${StoreVisitProvider.columnStoreId} "
      //   "= $tableStore.$columnStoreId WHERE $tableStore.$columnId = $id",
      // );
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
          .delete(tableStore, where: '$columnId = ?', whereArgs: [id]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clear() async {
    try {
      await (await _dbProvider.database).execute("DELETE FROM $tableStore");
    } catch (e) {
      rethrow;
    }
  }

  Future close() async => (await _dbProvider.database).close();
}
