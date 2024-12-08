enum PurchaseStatus {
  none,
  purchasing,
  purchased,
  purchasingFailed,
  restoring,
  restored,
  restoringFailed;

  bool get isCompleted {
    return this == purchased || this == restored;
  }

  bool get isLoading {
    return this == purchasing || this == restoring;
  }

  bool get isFailed {
    return this == purchasingFailed || this == restoringFailed;
  }

  PurchaseErrorType get errorType {
    return this == purchasingFailed
        ? PurchaseErrorType.purchasing
        : PurchaseErrorType.restoring;
  }
}

enum PurchaseErrorType { purchasing, restoring }
