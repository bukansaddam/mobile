/// Pure-Dart cancellation token for AI chat requests so the domain layer stays
/// decoupled from HTTP client packages such as Dio.
class AiChatCancellationToken {
  bool _isCancelled = false;
  String? _reason;
  final List<void Function(String? reason)> _listeners = [];

  bool get isCancelled => _isCancelled;
  String? get reason => _reason;

  void cancel([String? reason]) {
    if (_isCancelled) return;
    _isCancelled = true;
    _reason = reason;
    for (final listener in List<void Function(String?)>.from(_listeners)) {
      listener(reason);
    }
    _listeners.clear();
  }

  void onCancel(void Function(String? reason) listener) {
    if (_isCancelled) {
      listener(_reason);
      return;
    }
    _listeners.add(listener);
  }
}

/// Exception thrown when an in-flight AI chat request is cancelled intentionally.
class AiChatCancelledException implements Exception {
  const AiChatCancelledException([this.reason]);

  final String? reason;

  @override
  String toString() => 'AiChatCancelledException(${reason ?? 'cancelled'})';
}
