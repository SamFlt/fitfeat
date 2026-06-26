import 'package:fitfeat/model/timer.dart';


class TimerLogic {
  
  TimerState _state = NotStarted();
  final TimerSettings _settings;

  TimerLogic(this._settings);

  TimerSettings get settings {
    return _settings;
  }

  TimerState get state {
    return _state;
  }

  void onStart() {
    switch(_state) {
      case NotStarted():
        if(_settings.setupDurationSeconds == 0) {
          _state = PrimaryRunning(remaining: _settings.durationSeconds * 1000.0);
        } else {
          _state = SetupRunning(remaining: _settings.setupDurationSeconds * 1000.0);
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
          _state = PrimaryRunning(remaining: _settings.durationSeconds * 1000 - elapsed);
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
        return 1.0 - (remaining / (_settings.durationSeconds * 1000.0));

      case SetupRunning(remaining: var remaining):
        return 1.0 - (remaining / (_settings.setupDurationSeconds * 1000.0));
        
      case OverdueRunning(overdue: var overdue):
        return 1 + (overdue / (_settings.durationSeconds * 1000.0));
    }
  }
}
