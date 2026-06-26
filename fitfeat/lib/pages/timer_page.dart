import 'package:flutter/material.dart';
import 'package:fitfeat/components/timer.dart';


class TimerPage extends StatefulWidget {
  const TimerPage({super.key, required this.title});

  final String title;

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  

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
