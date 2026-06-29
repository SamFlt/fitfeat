import 'package:fitfeat/model/exercise.dart';

class ExerciseService {

  const ExerciseService();

  List<Exercise> getBasicExercises() {
    return [
      Exercise(name: "Push up", skills: [.horizontalPress]),
      Exercise(name: "Pull up", skills: [.verticalPull])
    ];
  }

}