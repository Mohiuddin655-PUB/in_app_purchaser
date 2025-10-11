import 'package:flutter/material.dart';
import 'package:in_app_purchaser/in_app_purchaser.dart';

import 'default.dart';

class PaywallPage extends StatefulWidget {
  final Object? args;
  final bool isBackMode;
  final VoidCallback? onSkipped;

  const PaywallPage({
    super.key,
    this.args,
    this.isBackMode = true,
    this.onSkipped,
  });

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  void _back() => Navigator.pop(context, true);

  Future<void> _showMessage(String msg) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _purchasingState() async {
    switch (InAppPurchaser.purchasingState.value) {
      case InAppPurchaseState.done:
        await _showMessage("Purchased");
        if (!mounted) return;
        _back();
        return;
      case InAppPurchaseState.cancel:
        await _showMessage("Canceled");
        return;
      case InAppPurchaseState.failed:
        await _showMessage("Failed!");
        return;
      default:
        return;
    }
  }

  void _restoringState() async {
    switch (InAppPurchaser.restoringState.value) {
      case InAppPurchaseState.exist:
        await _showMessage("Restored");
        if (!mounted) return;
        _back();
        return;
      case InAppPurchaseState.empty:
      case InAppPurchaseState.failed:
        await _showMessage("Not Found");
        return;
      default:
        return;
    }
  }

  @override
  void initState() {
    super.initState();
    InAppPurchaser.purchasingState.addListener(_purchasingState);
    InAppPurchaser.restoringState.addListener(_restoringState);
  }

  @override
  void dispose() {
    InAppPurchaser.purchasingState.removeListener(_purchasingState);
    InAppPurchaser.restoringState.removeListener(_restoringState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: InAppPurchaser.i,
      builder: (context, child) {
        return PaywallBuilder(
          initial: Paywall(),
          placement: "default",
          builder: (context, paywall) {
            final hasSkipPaywall = paywall.skipMode;
            return WillPopScope(
              onWillPop: !widget.isBackMode || !hasSkipPaywall
                  ? () async => false
                  : null,
              child: DefaultPaywall(
                onSkipped: hasSkipPaywall ? _back : null,
                paywall: paywall,
              ),
            );
          },
        );
      },
    );
  }
}
