import 'package:flutter/material.dart';

import '../src/purchaser.dart';

class PurchaseProvider<T> extends InheritedWidget {
  final bool initialCheck;
  final Duration initialCheckDuration;
  final Purchaser<T> purchaser;

  PurchaseProvider({
    super.key,
    this.initialCheck = false,
    this.initialCheckDuration = const Duration(seconds: 5),
    required this.purchaser,
    required Widget child,
  }) : super(
          child: _Support<T>(
            purchaser: purchaser,
            initialCheck: initialCheck,
            child: child,
          ),
        );

  static PurchaseProvider<T> of<T>(BuildContext context) {
    final x = context.dependOnInheritedWidgetOfExactType<PurchaseProvider<T>>();
    if (x != null) {
      return x;
    } else {
      throw UnimplementedError(
        "You should call like $PurchaseProvider.of<$T>();",
      );
    }
  }

  static Purchaser<T> purchaserOf<T>(BuildContext context) {
    try {
      return of<T>(context).purchaser;
    } catch (_) {
      throw UnimplementedError(
        "You should call like $PurchaseProvider.purchaserOf<$T>();",
      );
    }
  }

  @override
  bool updateShouldNotify(covariant PurchaseProvider<T> oldWidget) {
    return purchaser != oldWidget.purchaser;
  }

  void notify(Purchaser value) => purchaser.notify();
}

class _Support<T> extends StatefulWidget {
  final bool initialCheck;
  final Duration initialCheckDuration;
  final Purchaser<T> purchaser;
  final Widget child;

  const _Support({
    this.initialCheck = false,
    this.initialCheckDuration = const Duration(seconds: 5),
    required this.child,
    required this.purchaser,
  });

  @override
  State<_Support<T>> createState() => _SupportState<T>();
}

class _SupportState<T> extends State<_Support<T>> {
  void _init() async {
    await widget.purchaser.init();
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
    widget.purchaser.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
