import 'package:flutter/material.dart';

import '../src/paywall.dart';
import '../src/purchaser.dart';

class PaywallBuilder extends StatelessWidget {
  final Paywall initial;
  final String? placement;
  final Widget Function(BuildContext context, Paywall paywall) builder;

  const PaywallBuilder({
    super.key,
    required this.initial,
    required this.builder,
    this.placement,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: InAppPurchaser.initialization,
      builder: (context, initialized, child) {
        if (!initialized) return builder(context, initial);
        return ListenableBuilder(
          listenable: InAppPurchaser.i,
          builder: (context, child) {
            return builder(
              context,
              InAppPurchaser.paywall(placement) ?? initial,
            );
          },
        );
      },
    );
  }
}
