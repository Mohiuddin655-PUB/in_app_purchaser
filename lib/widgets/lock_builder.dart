import 'package:flutter/material.dart';

import '../src/purchaser.dart';

class PaywallLockBuilder extends StatefulWidget {
  final int? index;
  final String? feature;
  final String? uid;
  final Widget Function(BuildContext context, bool lock) builder;

  const PaywallLockBuilder({
    super.key,
    this.index,
    this.feature,
    this.uid,
    required this.builder,
  });

  @override
  State<PaywallLockBuilder> createState() {
    return _PaywallLockBuilderState();
  }
}

class _PaywallLockBuilderState extends State<PaywallLockBuilder> {
  bool? lock;

  void _check([bool notify = true]) {
    bool x = lock ?? false;
    if (widget.feature == null || widget.feature!.isEmpty) {
      x = !InAppPurchaser.isPremiumUser(widget.uid);
    } else {
      x = InAppPurchaser.isPremiumFeature(
        widget.feature!,
        widget.index,
        widget.uid,
      );
    }
    lock = x;
    if (x == lock) return;
    if (notify) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _check(false);
    // WidgetsBinding.instance.addPostFrameCallback((_) => _check());
    InAppPurchaser.iOrNull?.addListener(_check);
  }

  @override
  void didUpdateWidget(covariant PaywallLockBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != oldWidget.index ||
        widget.feature != oldWidget.feature ||
        widget.uid != oldWidget.uid) {
      _check(false);
    }
  }

  @override
  void dispose() {
    InAppPurchaser.iOrNull?.removeListener(_check);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, lock ?? false);
}
