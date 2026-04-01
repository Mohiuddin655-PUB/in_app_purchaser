import 'package:flutter/material.dart';

import '../src/purchaser.dart';

class PaywallLockBuilder extends StatefulWidget {
  final int? index;
  final String? feature;
  final String? uid;
  final bool? withAd;
  final Widget Function(BuildContext context, bool lock) builder;

  const PaywallLockBuilder({
    super.key,
    this.index,
    this.feature,
    this.uid,
    this.withAd,
    required this.builder,
  });

  @override
  State<PaywallLockBuilder> createState() {
    return _PaywallLockBuilderState();
  }
}

class _PaywallLockBuilderState extends State<PaywallLockBuilder> {
  late bool lock;

  void _check([bool notify = true]) {
    try {
      bool status;
      if (widget.feature == null || widget.feature!.isEmpty) {
        status = !InAppPurchaser.isPremiumUser(
          uid: widget.uid,
          withAd: widget.withAd,
        );
      } else {
        status = !InAppPurchaser.isPremiumFeature(
          widget.feature!,
          widget.index,
          widget.uid,
          widget.withAd,
        );
      }

      if (status == lock) return;
      lock = status;
      if (notify && mounted) setState(() {});
    } catch (e, stackTrace) {
      debugPrint(
          'PaywallLockBuilder: error checking lock status — $e\n$stackTrace');
      final fallback = true;
      if (fallback == lock) return;
      lock = fallback;
      if (notify && mounted) setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    lock = true;
    _check(false);
    InAppPurchaser.iOrNull?.addListener(_check);
  }

  @override
  void didUpdateWidget(covariant PaywallLockBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != oldWidget.index ||
        widget.feature != oldWidget.feature ||
        widget.uid != oldWidget.uid ||
        widget.withAd != oldWidget.withAd) {
      _check();
    }
  }

  @override
  void dispose() {
    InAppPurchaser.iOrNull?.removeListener(_check);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, lock);
}
