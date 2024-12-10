import 'package:flutter/material.dart';

import '../in_app_purchaser.dart';

class PurchaseProvider extends InheritedWidget {
  PurchaseProvider({
    super.key,
    bool initialCheck = false,
    Duration initialCheckDuration = const Duration(seconds: 5),
    bool logEnabled = true,
    OnPurchaserCallback? onStatus,
    required PurchaseDelegate delegate,
    required Widget child,
  }) : super(
          child: _Support(
            initialCheck: initialCheck,
            initialCheckDuration: initialCheckDuration,
            onStatus: onStatus,
            purchaser: Purchaser.init(
              delegate: delegate,
              logEnabled: logEnabled,
            ),
            child: child,
          ),
        );

  @override
  bool updateShouldNotify(covariant PurchaseProvider oldWidget) => false;
}

class _Support extends StatefulWidget {
  final bool initialCheck;
  final Duration initialCheckDuration;
  final OnPurchaserCallback? onStatus;
  final Purchaser purchaser;
  final Widget child;

  const _Support({
    required this.initialCheck,
    required this.initialCheckDuration,
    required this.onStatus,
    required this.child,
    required this.purchaser,
  });

  @override
  State<_Support> createState() => _SupportState();
}

class _SupportState extends State<_Support> {
  void _listener() {
    if (widget.onStatus == null) return;
    widget.onStatus!(context, Purchaser.i.isActive);
  }

  void _init() async {
    await widget.purchaser.configure();
    widget.purchaser.addListener(_listener);
    Future.delayed(widget.initialCheckDuration, () async {
      if (widget.initialCheck) {
        await widget.purchaser.restore(true);
        if (widget.purchaser.isActive) widget.purchaser.notify();
      }
    });
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    widget.purchaser.removeListener(_listener);
    widget.purchaser.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
