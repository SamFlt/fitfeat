import 'dart:io';

import 'package:fitfeat/data/db_savable.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const dbFileName = 'fitfeat.db';
const dbVersion = 1;


class DBHelper {
  Future<Database>? _db;

  DBHelper();


  Future<void> createDB(Database db, int version) async {
      for (var dbObject in DBRepresentable.baseRepresentables) {
        await dbObject.onCreate(db);
      }
  }

  Future<Database> db() async {
    if (_db == null) {
      if (Platform.isWindows || Platform.isLinux) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }
      String databasesPath = await getDatabasesPath();
      String pathdb = path.join(databasesPath, dbFileName);
      _db = openDatabase(pathdb, version: dbVersion,
        onCreate: createDB
      );
    }

    return _db!;
  }



}