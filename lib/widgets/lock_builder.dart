import 'package:flutter/material.dart';

import '../src/purchaser.dart';

class PaywallLockBuilder extends StatefulWidget {
  final int? index;
  final String feature;
  final String? uid;
  final Widget Function(BuildContext context, bool lock) builder;

  const PaywallLockBuilder({
    super.key,
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
  bool lock = true;

  void _listen() {
    final x = InAppPurchaser.isPremiumFeature(
      widget.feature,
      widget.index,
      widget.uid,
    );
    if (x == lock) return;
    setState(() => lock = x);
  }

  @override
  void initState() {
    super.initState();
    InAppPurchaser.initialization.addListener(() {
      if (InAppPurchaser.initialized) {
        InAppPurchaser.i.addListener(_listen);
      }
    });
  }

  @override
  void dispose() {
    if (InAppPurchaser.initialized) {
      InAppPurchaser.i.removeListener(_listen);
    }
    InAppPurchaser.initialization.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, lock);
}
