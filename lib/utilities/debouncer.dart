import 'dart:async';

class Debouncer {
  static Timer? _timer;

  static void run(Function action,
      {Duration delay = const Duration(seconds: 1, milliseconds: 500)}) {
    _timer?.cancel();
    _timer = Timer(delay, () => action());
  }
}
