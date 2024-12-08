import 'package:flutter/material.dart';
import 'package:in_app_purchaser/in_app_purchaser.dart';

class PurchaseProvider extends InheritedWidget {
  final bool initialCheck;
  final Duration initialCheckDuration;

  PurchaseProvider({
    super.key,
    this.initialCheck = false,
    this.initialCheckDuration = const Duration(seconds: 5),
    required PurchaseDelegate delegate,
    required Widget child,
  }) : super(
          child: _Support(
            initialCheck: initialCheck,
            initialCheckDuration: initialCheckDuration,
            purchaser: Purchaser.init(delegate),
            child: child,
          ),
        );

  @override
  bool updateShouldNotify(covariant PurchaseProvider oldWidget) => false;
}

class _Support extends StatefulWidget {
  final bool initialCheck;
  final Duration initialCheckDuration;
  final Purchaser purchaser;
  final Widget child;

  const _Support({
    this.initialCheck = false,
    this.initialCheckDuration = const Duration(seconds: 5),
    required this.child,
    required this.purchaser,
  });

  @override
  State<_Support> createState() => _SupportState();
}

class _SupportState extends State<_Support> {
  void _init() async {
    await widget.purchaser.configure();
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
