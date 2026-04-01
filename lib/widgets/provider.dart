import 'package:flutter/material.dart';

import '../src/delegate.dart';
import '../src/purchaser.dart';

typedef OnPurchaserCallback = Function(BuildContext context, bool status);

/// An [InheritedWidget] that owns the lifecycle of [InAppPurchaser].
///
/// Place this near the root of your widget tree. When [enabled] is `true`
/// (the default), [InAppPurchaser] is initialised on mount and disposed on
/// unmount.
class InAppPurchaseProvider extends InheritedWidget {
  InAppPurchaseProvider({
    super.key,
    bool enabled = true,
    bool initialCheck = false,
    Duration initialCheckDuration = const Duration(seconds: 5),
    bool logEnabled = true,
    OnPurchaserCallback? onStatus,
    required InAppPurchaseDelegate delegate,
    required Widget child,
  }) : super(
          child: _Support(
            enabled: enabled,
            initialCheck: initialCheck,
            initialCheckDuration: initialCheckDuration,
            logEnabled: logEnabled,
            onStatus: onStatus,
            delegate: delegate,
            child: child,
          ),
        );

  @override
  bool updateShouldNotify(covariant InAppPurchaseProvider oldWidget) => false;
}

class _Support extends StatefulWidget {
  final bool enabled;
  final bool initialCheck;
  final bool logEnabled;
  final Duration initialCheckDuration;
  final OnPurchaserCallback? onStatus;
  final InAppPurchaseDelegate delegate;
  final Widget child;

  const _Support({
    required this.enabled,
    required this.initialCheck,
    required this.initialCheckDuration,
    required this.logEnabled,
    required this.onStatus,
    required this.delegate,
    required this.child,
  });

  @override
  State<_Support> createState() => _SupportState();
}

class _SupportState extends State<_Support> {
  void _onPurchaserChanged() {
    final callback = widget.onStatus;
    if (callback == null) return;
    callback(context, InAppPurchaser.isPremiumWithoutAd);
  }

  Future<void> _init() async {
    await InAppPurchaser.init(
      delegate: widget.delegate,
      logEnabled: widget.logEnabled,
    );
    InAppPurchaser.i.addListener(_onPurchaserChanged);

    if (widget.initialCheck) {
      Future.delayed(widget.initialCheckDuration, () async {
        if (!mounted) return;
        await InAppPurchaser.restore(true);
        if (InAppPurchaser.isPremiumWithoutAd) {
          InAppPurchaser.iOrNull?.notify();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.enabled) _init();
  }

  @override
  void dispose() {
    if (widget.enabled) {
      InAppPurchaser.iOrNull?.removeListener(_onPurchaserChanged);
      InAppPurchaser.iOrNull?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
