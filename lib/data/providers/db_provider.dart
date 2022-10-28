import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pitjarusstore/data/providers/store_provider.dart';
import 'package:pitjarusstore/data/providers/store_visit_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  // final StoreProvider _storeProvider = StoreProvider();
  // final StoreVisitProvider _storeVisitProvider = StoreVisitProvider();

  Completer<Database>? _initCompleter;
  Database? _database;

  Future<Database> get database async {
    Database? db = _database;
    Completer<Database>? initCompleter = _initCompleter;
    // if (db != null) return db;
    // db = await _open();
    // _database = db;
    // return db;
    if (db != null) return db;
    if (initCompleter != null) return await initCompleter.future;
    _initCompleter = Completer<Database>();
    db = await _open();
    _database = db;
    _initCompleter?.complete(db);
    return db;
  }

  Future<Database> _open() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = p.join(documentsDirectory.path, "PitjarusDB.db");
    return openDatabase(
      path,
      version: 1,
      onOpen: (db) async {
        await _onCreate(db);
      },
      onCreate: (db, version) async {
        await _onCreate(db);
      },
    );
  }

  Future<void> _onCreate(Database db) async {
    await db.execute(StoreProvider.create);
    await db.execute(StoreVisitProvider.create);
  }

  Future close() async => (await database).close();
}
