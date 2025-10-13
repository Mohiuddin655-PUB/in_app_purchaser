import 'package:flutter/material.dart';

import '../src/paywall.dart';
import '../src/purchaser.dart';

class PaywallBuilder extends StatefulWidget {
  final Paywall initial;
  final String? placement;
  final Widget Function(BuildContext context, Paywall paywall) builder;

  const PaywallBuilder({
    super.key,
    required this.initial,
    this.placement,
    required this.builder,
  });

  @override
  State<PaywallBuilder> createState() {
    return _PaywallBuilderState();
  }
}

class _PaywallBuilderState extends State<PaywallBuilder> {
  late Paywall paywall = widget.initial;

  void _check([bool notify = true]) {
    final x = InAppPurchaser.paywall(widget.placement);
    if (x == paywall) return;
    if (notify) setState(() => paywall = x ?? paywall);
  }

  @override
  void initState() {
    super.initState();
    InAppPurchaser.iOrNull?.addListener(_check);
  }

  @override
  void didUpdateWidget(covariant PaywallBuilder oldWidget) {
    if (widget.initial != oldWidget.initial ||
        widget.placement != oldWidget.placement) {
      paywall = widget.initial;
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
  Widget build(BuildContext context) => widget.builder(context, paywall);
}
