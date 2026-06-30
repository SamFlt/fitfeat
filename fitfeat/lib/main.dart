import 'package:fitfeat/core/db_helper.dart';
import 'package:fitfeat/data/db_savable.dart';
import 'package:fitfeat/model/exercise.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'screens/home_screen.dart';


Future<void> initDb() async {
  var db = await DBHelper().db();
  var v = await db.query("Exercise");
}

Future<void> deleteAndCloseDB() async {
  var db = await DBHelper().db();
  await deleteDatabase(db.path);
}

void main() async {

  ExerciseDB baseExoDb = ExerciseDB();
  DBRepresentable.registerRepository(baseExoDb);

  await initDb();
  runApp(const FitApp());
  await deleteAndCloseDB();
}

class FitApp extends StatelessWidget {
  const FitApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepOrange, brightness: .dark)
      ),
      home: const HomePage(title: 'Fit Feat'),
    );
  }
}