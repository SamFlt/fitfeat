import 'package:fitfeat/data/db_savable.dart';
import 'package:sqflite/sqflite.dart';

enum Skill {
  verticalPush,
  verticalPull,
  horizontalPull,
  horizontalPress,
  leg,
  core
}

enum ExerciseType {
  isometric,
  negative,
  reps
}

sealed class ExerciseInstanciation {
  final Exercise exercise;
  const ExerciseInstanciation({required this.exercise});
  int baseEstimatedDuration();
}

sealed class IsometricExercise extends ExerciseInstanciation {
  final int durationSeconds; 
  const IsometricExercise({required super.exercise, required this.durationSeconds});
  @override
  int baseEstimatedDuration() { return durationSeconds; }
}

sealed class RepBasedExercise extends ExerciseInstanciation {
  final int numReps;
  final int secondsPerRep;
  const RepBasedExercise({required super.exercise, required this.numReps, required this.secondsPerRep});
}



const exerciseColName = 'name';
const exerciseColDesc = 'description';

class Exercise {
  final String name;
  final List<Skill> skills;
  const Exercise({required this.name, required this.skills});
}


class ExerciseDB with DBRepresentable {
  @override
  Future<void> onCreate(Database db) {
    return db.execute(
      '''CREATE TABLE Exercise(id INTEGER PRIMARY KEY AUTOINCREMENT, $exerciseColName TEXT NOT NULL, $exerciseColDesc TEXT NOT NULL)'''
    );
  }
}


