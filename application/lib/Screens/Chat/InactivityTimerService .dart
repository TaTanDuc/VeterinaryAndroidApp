import 'dart:async';

class InactivityTimerService {
  static final InactivityTimerService _instance =
      InactivityTimerService._internal();
  factory InactivityTimerService() => _instance;
  InactivityTimerService._internal();

  Timer? _timer;
  final Duration inactivityDuration = Duration(minutes: 5);
  Function? onInactivityTimeout;

  void startTimer() {
    _cancelTimer();

    _timer = Timer(inactivityDuration, _onInactivityTimeout);
  }

  void resetTimer() {
    startTimer();
  }

  void _onInactivityTimeout() {
    if (onInactivityTimeout != null) {
      onInactivityTimeout!();
    }
  }

  void _cancelTimer() {
    _timer?.cancel();
  }

  void stopTimer() {
    _cancelTimer();
  }
}
