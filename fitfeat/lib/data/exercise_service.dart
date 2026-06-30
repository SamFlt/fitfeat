import 'package:fitfeat/model/exercise.dart';

class ExerciseService {

  const ExerciseService();

  List<Exercise> getAllExercises() {
    return ExerciseDB().getDefaultExercises();
  }

  

}