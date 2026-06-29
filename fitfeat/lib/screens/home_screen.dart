import 'package:fitfeat/screens/exercise_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitfeat/screens/timer_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  VoidCallback toTimerScreen(BuildContext context) {
    return () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (ctx) => const TimerScreen(title: 'Timer')),
      );
    };
  }

  VoidCallback toExerciseLibraryScreen(BuildContext context) {
    return () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (ctx) => const ExerciseListScreen()),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Flex(
          direction: .vertical,
          children: [
              Row(
                mainAxisAlignment: .center,
                mainAxisSize: .max,
                children: [
                  FilledButton(
                    onPressed: toTimerScreen(context),
                    child: Text('Timer'),
                  ),
                  FilledButton(
                    onPressed: toExerciseLibraryScreen(context),
                    child: Text('Library'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
