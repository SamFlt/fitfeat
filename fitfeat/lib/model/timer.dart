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
