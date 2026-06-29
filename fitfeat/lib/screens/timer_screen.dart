import 'package:flutter/material.dart';
import 'package:fitfeat/components/timer.dart';


class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key, required this.title});

  final String title;

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            TimerWidget()
          ],
        ),
      ),
    );
  }
}
