import 'package:flutter/material.dart';

import '../src/purchaser.dart';

class InAppPurchaseLockBuilder extends StatelessWidget {
  final int? index;
  final String feature;
  final Widget Function(BuildContext context, bool lock) builder;

  const InAppPurchaseLockBuilder({
    super.key,
    this.index,
    required this.feature,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: InAppPurchaser.i,
      builder: (context, child) {
        final lock = InAppPurchaser.isPremiumFeature(feature, index);
        return builder(context, lock);
      },
    );
  }
}
