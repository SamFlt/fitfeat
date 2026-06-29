import 'package:fitfeat/data/exercise_repository.dart';
import 'package:fitfeat/model/exercise.dart';
import 'package:flutter/material.dart';
import 'package:fitfeat/screens/timer_screen.dart';

class ExerciseListScreen extends StatefulWidget {
  const ExerciseListScreen({super.key});
  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class ExerciseListItem extends StatelessWidget {

  final Exercise _exercise;
  const ExerciseListItem({required this._exercise, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(color: Theme.of(context).secondaryHeaderColor), child: Text(_exercise.name));
  }
}

class ExerciseList extends StatelessWidget {
  
  final List<Exercise> _exercises;

  const ExerciseList({super.key, required this._exercises});
  
  @override
  Widget build(BuildContext context) {
    return ListView(children: _exercises.map((exo) => ExerciseListItem(exercise: exo)).toList());
  }

}


class _ExerciseListScreenState extends State<ExerciseListScreen> {

  final ExerciseService _exerciseService;

  _ExerciseListScreenState(): _exerciseService = ExerciseService();

  VoidCallback toExerciseScreen(BuildContext context, Exercise ex) {
    return () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (ctx) => const TimerScreen(title: 'Timer')),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Exercises"),
      ),
      body: Center(
        child: ExerciseList(exercises: _exerciseService.getBasicExercises())
      ),
    );
  }
}
