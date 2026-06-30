import 'dart:core';

import 'package:sqflite/sqflite.dart';

mixin DBRepresentable {

  static List<DBRepresentable> baseRepresentables = [];


  static void registerRepository(DBRepresentable representable) {
    baseRepresentables.add(representable);
  }

  Future<void> onCreate(Database db);
}
