import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

sealed class TimerState {
  const TimerState();
 }

class NotStarted extends TimerState { }

class Paused extends TimerState { 
  final TimerState previous;
  const Paused({required this.previous});
}

class PrimaryRunning extends TimerState {
  double remaining;
  PrimaryRunning({required this.remaining});
}

class SetupRunning extends TimerState {
  double remaining;
  SetupRunning({required this.remaining});
}

class OverdueRunning extends TimerState {
  double overdue;
  OverdueRunning({required this.overdue});
}


class TimerSettings {
  const TimerSettings({required this.durationSeconds, required this.setupDurationSeconds});
  final int durationSeconds;
  final int setupDurationSeconds;
}

class TimerLogic {
  
  TimerState _state = NotStarted();
  final TimerSettings settings;

  TimerLogic(this.settings);
  void onStart() {
    switch(_state) {
      case NotStarted():
        if(settings.setupDurationSeconds == 0) {
          _state = PrimaryRunning(remaining: settings.durationSeconds * 1000.0);
        } else {
          _state = SetupRunning(remaining: settings.setupDurationSeconds * 1000.0);
        }
        break;
      default:
        throw StateError("Tried to start a timer that is already running?");
    }
    
  }

  void onReset() {
    _state = NotStarted();
  }

  void onPause() {
    _state = Paused(previous: _state);
  }

  void onResume() {
    switch(_state)  {
      case Paused(previous: var previous):
        _state = previous;
        break;
      default:
        throw StateError("Should be in paused state when resuming");
    }
  }


  void tick(double elapsed) {
    switch(_state) {
      case PrimaryRunning(remaining: var remaining):
        double newRemaining = remaining - elapsed;
        if(newRemaining <= 0.0) {
          _state = OverdueRunning(overdue: -newRemaining);
        } else {
          _state = PrimaryRunning(remaining: newRemaining);
        }
        break;
      case OverdueRunning(overdue: var overdue):
        _state = OverdueRunning(overdue: overdue + elapsed);
        break;
      case SetupRunning(remaining: var remaining):
        double newRemaining = remaining - elapsed;
        if(newRemaining <= 0.0) {
          _state = PrimaryRunning(remaining: settings.durationSeconds * 1000 - elapsed);
        } else {
          _state = SetupRunning(remaining: newRemaining);
        }
      default:
      throw StateError("Cannot tick when not running");
    }
  }

  double progress(TimerState state) {
    switch(state) {

      case NotStarted():
        return 0.0;
      case Paused():
        return progress(state.previous);
      case PrimaryRunning(remaining: var remaining):
        return 1.0 - (remaining / (settings.durationSeconds * 1000.0));

      case SetupRunning(remaining: var remaining):
        return 1.0 - (remaining / (settings.setupDurationSeconds * 1000.0));
        
      case OverdueRunning(overdue: var overdue):
        return 1 + (overdue / (settings.durationSeconds * 1000.0));
    }
  }
}



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
      _progress = timerLogic.progress(timerLogic._state);
    });
    
  }

  void _onTimerStart() {
    if (_timer != null) {
      _timer!.cancel();
      _stopwatch.stop();
    }
    _progress = 0.0;
    _stopwatch.start();
    _timer = Timer.periodic(Duration(milliseconds: widget.timerResolutionMs), _onTimerTick);
    timerLogic.onStart();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        TimerProgressionWheelWidget(progress: _progress),
        IconButton.filled(
          onPressed: _onTimerStart,
          icon: Icon(
            Icons.play_arrow,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        Text(
          '$_progress',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}
