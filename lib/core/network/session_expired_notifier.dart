import 'dart:async';

/// Broadcasts session expiry so the UI can route to login without coupling
/// the network layer to Flutter widgets.
class SessionExpiredNotifier {
  final StreamController<void> _controller = StreamController<void>.broadcast();

  Stream<void> get stream => _controller.stream;

  void notify() {
    if (!_controller.isClosed) {
      _controller.add(null);
    }
  }

  void dispose() {
    _controller.close();
  }
}
