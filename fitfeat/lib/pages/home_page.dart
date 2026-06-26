

import 'package:flutter/material.dart';
import 'package:fitfeat/pages/timer_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  

  VoidCallback toTimerPage(BuildContext context) {
    return () {
      Navigator.push(context, MaterialPageRoute(builder: (ctx) => const TimerPage(title: 'Timer')));
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
        child: Column(
          mainAxisAlignment: .center,
          children: [
            TextButton(onPressed: toTimerPage(context) , child: Text('Timer'))
          ],
        ),
      ),
    );
  }
}