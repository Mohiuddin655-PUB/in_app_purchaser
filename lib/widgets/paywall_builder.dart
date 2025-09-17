import 'package:flutter/material.dart';

import '../src/paywall.dart';
import '../src/purchaser.dart';

class InAppPurchasePaywallBuilder extends StatelessWidget {
  final InAppPurchasePaywall? initial;
  final String placement;
  final Widget Function(BuildContext context, InAppPurchasePaywall? paywall)
      builder;

  const InAppPurchasePaywallBuilder({
    super.key,
    this.initial,
    required this.builder,
    required this.placement,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: InAppPurchaser.i,
      builder: (context, child) {
        return builder(context, InAppPurchaser.paywall(placement) ?? initial?.copyWith());
      },
    );
  }
}
