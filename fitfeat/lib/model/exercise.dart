import 'package:fitfeat/data/db_savable.dart';
import 'package:sqflite/sqflite.dart';

enum Skill {
  verticalPush,
  verticalPull,
  horizontalPull,
  horizontalPress,
  leg,
  core,
}

enum ExerciseType { isometric, negative, reps }

sealed class ExerciseInstanciation {
  final Exercise exercise;
  const ExerciseInstanciation({required this.exercise});
  int baseEstimatedDuration();
}

sealed class IsometricExercise extends ExerciseInstanciation {
  final int durationSeconds;
  const IsometricExercise({
    required super.exercise,
    required this.durationSeconds,
  });
  @override
  int baseEstimatedDuration() {
    return durationSeconds;
  }
}

sealed class RepBasedExercise extends ExerciseInstanciation {
  final int numReps;
  final int secondsPerRep;
  const RepBasedExercise({
    required super.exercise,
    required this.numReps,
    required this.secondsPerRep,
  });
}

const exerciseColName = 'name';
const exerciseColDesc = 'description';
const exerciseColSkills = 'skills';

class Exercise {
  int? id;
  String name;
  String description;
  List<Skill> skills;
  Exercise({
    required this.name,
    required this.description,
    required this.skills,
  }) : id = null;

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      exerciseColName: name,
      exerciseColDesc: description,
      exerciseColSkills: skills,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  Exercise.fromMap(Map<String, Object?> map)
    : id = map['id'] as int,
      name = map[exerciseColName] as String,
      description = map[exerciseColDesc] as String,
      skills = map[exerciseColSkills] as List<Skill>;
}

class ExerciseDB with DBRepresentable {


  List<Exercise> getDefaultExercises() {
    return [
      Exercise(name: "Push up", description: "Like a pushup yeee", skills: [.horizontalPress]),
      Exercise(name: "Pull up", description: "Like a pullup yee", skills: [.verticalPull])
    ];
  }

  @override
  Future<void> onCreate(Database db) async {
    await db.transaction( (trx) async {
      await trx.execute('''CREATE TABLE Exercise(id INTEGER PRIMARY KEY AUTOINCREMENT, $exerciseColName TEXT NOT NULL, $exerciseColDesc TEXT NOT NULL)''');
      for(var exo in getDefaultExercises()) {
        var exoMap = exo.toMap();
        exoMap.remove(exerciseColSkills);
        trx.insert("Exercise", exoMap);
      }
    }
    );  
  }
}
