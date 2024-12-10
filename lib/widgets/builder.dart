import 'package:flutter/material.dart';
import 'package:in_app_purchaser_delegate/in_app_purchaser_delegate.dart';

import '../src/purchaser.dart';
import '../src/status.dart';

typedef OnPurchaserCallback<T> = void Function(BuildContext context, T value);
typedef OnPurchaserBuilder = Widget Function(
  BuildContext context,
  PurchasingData data,
);

enum PurchaserProductType { initial, oto }

class PurchasingData {
  final InAppPurchaseState state;
  final List<InAppPackage> packages;

  const PurchasingData._(this.state, this.packages);
}

class PurchaseBuilder extends StatefulWidget {
  final PurchaserProductType productType;
  final OnPurchaserCallback<InAppPurchaseState>? onInit;
  final OnPurchaserCallback<InAppPurchaseState>? onAdjustSdk;
  final OnPurchaserCallback<InAppPurchaseState>? onFacebookSdk;
  final OnPurchaserCallback<InAppPurchaseState>? onIdentify;
  final OnPurchaserCallback<InAppPurchaseState>? onLogShow;
  final OnPurchaserCallback<InAppPurchaseState>? onUpload;
  final OnPurchaserCallback<InAppPurchaseState>? onPurchasing;
  final OnPurchaserCallback<InAppPurchaseState>? onRestoring;
  final OnPurchaserCallback<bool>? onFetching;
  final OnPurchaserBuilder builder;

  const PurchaseBuilder({
    super.key,
    this.productType = PurchaserProductType.initial,
    this.onInit,
    this.onAdjustSdk,
    this.onFacebookSdk,
    this.onIdentify,
    this.onLogShow,
    this.onUpload,
    this.onPurchasing,
    this.onRestoring,
    this.onFetching,
    required this.builder,
  });

  @override
  State<PurchaseBuilder> createState() => _PurchaseBuilderState();
}

class _PurchaseBuilderState extends State<PurchaseBuilder> {
  List<InAppPackage> get packages =>
      widget.productType == PurchaserProductType.initial
          ? Purchaser.i.products
          : Purchaser.i.otoProducts;

  InAppPurchaseState get state =>
      widget.productType == PurchaserProductType.initial
          ? Purchaser.i.offeringState.value
          : Purchaser.i.otoOfferingState.value;

  ValueNotifier<InAppPurchaseState> get _notifier =>
      widget.productType == PurchaserProductType.initial
          ? Purchaser.i.offeringState
          : Purchaser.i.otoOfferingState;

  void _notify() => setState(() {});

  void _attach(
    OnPurchaserCallback<InAppPurchaseState>? callback,
    ValueNotifier<InAppPurchaseState> notifier,
  ) {
    if (callback == null) return;
    notifier.addListener(() => callback(context, notifier.value));
  }

  void _detach(
    OnPurchaserCallback<InAppPurchaseState>? callback,
    ValueNotifier<InAppPurchaseState> notifier,
  ) {
    if (callback == null) return;
    notifier.removeListener(() => callback(context, notifier.value));
  }

  void _reset(
    OnPurchaserCallback<InAppPurchaseState>? callback,
    ValueNotifier<InAppPurchaseState> notifier,
  ) {
    if (callback == null) {
      _detach(callback, notifier);
    } else {
      _detach(callback, notifier);
      _attach(callback, notifier);
    }
  }

  void _addListeners() {
    _notifier.addListener(_notify);
    _attach(widget.onInit, Purchaser.i.initState);
    _attach(widget.onAdjustSdk, Purchaser.i.adjustSdkState);
    _attach(widget.onFacebookSdk, Purchaser.i.facebookSdkState);
    _attach(widget.onIdentify, Purchaser.i.identifyState);
    _attach(widget.onLogShow, Purchaser.i.logShowState);
    _attach(widget.onUpload, Purchaser.i.uploadState);
    _attach(widget.onPurchasing, Purchaser.i.purchasingState);
    _attach(widget.onRestoring, Purchaser.i.restoringState);
  }

  void _removeListeners() {
    _notifier.removeListener(_notify);
    _detach(widget.onInit, Purchaser.i.initState);
    _detach(widget.onAdjustSdk, Purchaser.i.adjustSdkState);
    _detach(widget.onFacebookSdk, Purchaser.i.facebookSdkState);
    _detach(widget.onIdentify, Purchaser.i.identifyState);
    _detach(widget.onLogShow, Purchaser.i.logShowState);
    _detach(widget.onUpload, Purchaser.i.uploadState);
    _detach(widget.onPurchasing, Purchaser.i.purchasingState);
    _detach(widget.onRestoring, Purchaser.i.restoringState);
  }

  @override
  void initState() {
    _addListeners();
    super.initState();
  }

  @override
  void didUpdateWidget(PurchaseBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productType != widget.productType) {
      if (widget.productType == PurchaserProductType.initial) {
        Purchaser.i.offeringState.removeListener(_notify);
        Purchaser.i.offeringState.addListener(_notify);
      } else {
        Purchaser.i.otoOfferingState.removeListener(_notify);
        Purchaser.i.otoOfferingState.addListener(_notify);
      }
    }
    if (oldWidget.onInit != widget.onInit) {
      _reset(widget.onInit, Purchaser.i.initState);
    }
    if (oldWidget.onAdjustSdk != widget.onAdjustSdk) {
      _reset(widget.onAdjustSdk, Purchaser.i.adjustSdkState);
    }
    if (oldWidget.onFacebookSdk != widget.onFacebookSdk) {
      _reset(widget.onFacebookSdk, Purchaser.i.facebookSdkState);
    }
    if (oldWidget.onIdentify != widget.onIdentify) {
      _reset(widget.onIdentify, Purchaser.i.identifyState);
    }
    if (oldWidget.onLogShow != widget.onLogShow) {
      _reset(widget.onLogShow, Purchaser.i.logShowState);
    }
    if (oldWidget.onUpload != widget.onUpload) {
      _reset(widget.onUpload, Purchaser.i.uploadState);
    }
    if (oldWidget.onPurchasing != widget.onPurchasing) {
      _reset(widget.onPurchasing, Purchaser.i.purchasingState);
    }
    if (oldWidget.onRestoring != widget.onRestoring) {
      _reset(widget.onRestoring, Purchaser.i.restoringState);
    }
  }

  @override
  void dispose() {
    _removeListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      PurchasingData._(state, packages),
    );
  }
}
