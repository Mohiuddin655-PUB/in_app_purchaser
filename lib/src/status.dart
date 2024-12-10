enum InAppPurchaseState {
  none,
  running,
  done,
  failed;

  bool get isRunning => this == running;

  bool get isDone => this == done;

  bool get isFailed => this == failed;
}
