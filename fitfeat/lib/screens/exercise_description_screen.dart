import 'package:fitfeat/model/exercise.dart';
import 'package:flutter/material.dart';

class ExerciseDescriptionScreen extends StatelessWidget {
  
  final Exercise _exercise;

  const ExerciseDescriptionScreen({super.key, required this._exercise});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Title(color: Theme.of(context).primaryColor, child: Text(_exercise.name))), body: Container());
  }

}