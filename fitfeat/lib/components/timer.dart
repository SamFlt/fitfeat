import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:fitfeat/logic/timer.dart';

import 'package:fitfeat/model/timer.dart';




class TimerProgressionWheelWidget extends StatelessWidget {
  final double diameter;
  final double progress;
  late final TimerProgressionPainter painter;
  TimerProgressionWheelWidget({
    super.key,
    this.diameter = 200,
    this.progress = 1.0,
  }) {
    painter = TimerProgressionPainter();
  }

  @override
  Widget build(BuildContext context) {
    var size = Size(diameter, diameter);
    painter.progress = progress;
    return CustomPaint(painter: painter, size: size);
  }
}

// This is the Painter class
class TimerProgressionPainter extends CustomPainter {
  double progress = 0.0;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      0.0,
      math.pi * 2 * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  final TimerSettings timerSettings = const TimerSettings(durationSeconds: 60, setupDurationSeconds: 10);
  final int timerResolutionMs = 100;
  @override
  State<TimerWidget> createState() => _TimerState();
}


class _TimerState extends State<TimerWidget> {
  Timer? _timer;
  final Stopwatch _stopwatch = Stopwatch();  
  double _progress = 0.0;

  late TimerLogic timerLogic;

  @override
  void initState() {
    super.initState();
    timerLogic = TimerLogic(widget.timerSettings);
  }

  void _onTimerTick(Timer t) {
    setState(() {
      double timeElapsedSinceLastTick = _stopwatch.elapsedMilliseconds.toDouble();
      timerLogic.tick(timeElapsedSinceLastTick);
      _stopwatch..reset()..start();
      _progress = timerLogic.progress(timerLogic.state);
    });
  }

  void _onTimerStart() {
    setState(() {
      if (_timer != null) {
        _timer!.cancel();
        _stopwatch.stop();
      }
      _progress = 0.0;
      _stopwatch.start();
      _timer = Timer.periodic(Duration(milliseconds: widget.timerResolutionMs), _onTimerTick);
      timerLogic.onStart();
    });
  }

  void _onTimerResume() {
    setState(() {
      if (_timer != null) {
        _timer!.cancel();
        _stopwatch.stop();
      }
      _stopwatch.start();
      _timer = Timer.periodic(Duration(milliseconds: widget.timerResolutionMs), _onTimerTick);
      timerLogic.onResume();
    });
  }

  void _onTimerPause() {
    setState(() {

      if (_timer != null) {
        _timer!.cancel();
        _stopwatch.stop();
      }
      timerLogic.onPause();
    });
  }
  
  void _onTimerReset() {
    setState(() {
      if (_timer != null) {
        _timer!.cancel();
        _stopwatch.stop();
      }
      _progress = 0.0;
      timerLogic.onReset();
    });
  }
  

  

  Widget buildControls(BuildContext context) 
  {
    switch(timerLogic.state) {
      
      case NotStarted():
        return FilledButton(onPressed: _onTimerStart, child: Icon(Icons.play_arrow));
      case Paused():
          return Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            FilledButton(onPressed: _onTimerResume, child: Icon(Icons.play_arrow)),
            FilledButton(onPressed: _onTimerReset, child: Icon(Icons.stop)),
          ]));

      case PrimaryRunning():
        return Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          FilledButton(onPressed: _onTimerPause, child: Icon(Icons.pause)),
          FilledButton(onPressed: _onTimerReset, child: Icon(Icons.stop)),
        ]));
      case SetupRunning():
        return FilledButton(onPressed: _onTimerReset, child: Icon(Icons.stop));
      case OverdueRunning():
        return FilledButton(onPressed: _onTimerReset, child: Icon(Icons.stop));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        TimerProgressionWheelWidget(progress: _progress),
        buildControls(context),
        Text(
          '$_progress',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}
