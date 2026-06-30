import 'package:fitfeat/data/exercise_service.dart';
import 'package:fitfeat/model/exercise.dart';
import 'package:fitfeat/screens/exercise_description_screen.dart';
import 'package:flutter/material.dart';


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
    return Material(child: ListTile(title: Text(_exercise.name), onTap: () => {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (ctx) => ExerciseDescriptionScreen(exercise: _exercise))
      ),
    }));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Exercises"),
      ),
      body: Center(
        child: ExerciseList(exercises: _exerciseService.getAllExercises())
      ),
    );
  }
}