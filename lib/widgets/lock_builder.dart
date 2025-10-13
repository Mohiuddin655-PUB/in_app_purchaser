import 'package:flutter/material.dart';

import '../src/purchaser.dart';

class PaywallLockBuilder extends StatefulWidget {
  final bool initial;
  final int? index;
  final String feature;
  final String? uid;
  final Widget Function(BuildContext context, bool lock) builder;

  const PaywallLockBuilder({
    super.key,
    this.initial = false,
    this.index,
    required this.feature,
    this.uid,
    required this.builder,
  });

  @override
  State<PaywallLockBuilder> createState() {
    return _PaywallLockBuilderState();
  }
}

class _PaywallLockBuilderState extends State<PaywallLockBuilder> {
  late bool lock = widget.initial;

  void _check([bool notify = true]) {
    final x = InAppPurchaser.isPremiumFeature(
      widget.feature,
      widget.index,
      widget.uid,
    );
    if (x == lock) return;
    if (notify) setState(() => lock = x);
  }

  @override
  void initState() {
    super.initState();
    InAppPurchaser.iOrNull?.addListener(_check);
  }

  @override
  void didUpdateWidget(covariant PaywallLockBuilder oldWidget) {
    if (widget.initial != oldWidget.initial ||
        widget.index != oldWidget.index ||
        widget.feature != oldWidget.feature ||
        widget.uid != oldWidget.uid) {
      lock = widget.initial;
      _check(false);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    InAppPurchaser.iOrNull?.removeListener(_check);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, lock);
}
