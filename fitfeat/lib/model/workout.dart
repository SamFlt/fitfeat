import 'package:fitfeat/model/exercise.dart';
sealed class WorkoutStep {
  int duration();
  const WorkoutStep();
}

class Rest extends WorkoutStep {
  final int durationSeconds;
  const Rest({required this.durationSeconds});
  @override
  int duration() { return durationSeconds; }
}

class ExerciseStep extends WorkoutStep {
  final ExerciseInstanciation exerciseInstance;
  const ExerciseStep({required this.exerciseInstance});
  @override
  int duration() { return exerciseInstance.baseEstimatedDuration(); }
}

class CircuitStep extends WorkoutStep {
  final List<ExerciseStep> steps;
  final int restBetweenExercises;
  const CircuitStep({required this.steps, required this.restBetweenExercises});

  @override 
  int duration() {
    int exoLength = steps.fold(0, (time, exo) => (time + exo.duration()));
    int restTime = (steps.length - 1) * restBetweenExercises;
    return exoLength + restTime;
  }
}

class RepeatedStep extends WorkoutStep {
  final int repeats;
  final ExerciseStep step;

  const RepeatedStep({required this.step, required this.repeats});

  @override
  int duration() {
    return step.duration() * repeats;
  }
}

class Workout {
  final List<WorkoutStep> steps;

  const Workout({required this.steps});


}