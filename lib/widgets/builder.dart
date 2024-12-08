import 'package:flutter/material.dart';
import 'package:in_app_purchaser/in_app_purchaser.dart';

typedef OnPurchaserCallback<T> = void Function(BuildContext context, T value);
typedef OnPurchaserBuilder = Widget Function(
  BuildContext context,
  List<PurchasableProduct> data,
);

enum PurchaserProductType { initial, oto }

class PurchaseBuilder extends StatefulWidget {
  final PurchaserProductType productType;
  final OnPurchaserCallback<PurchaseErrorType>? onError;
  final OnPurchaserCallback<bool>? onLoading;
  final OnPurchaserCallback<bool>? onChanged;
  final OnPurchaserBuilder builder;

  const PurchaseBuilder({
    super.key,
    this.productType = PurchaserProductType.initial,
    this.onError,
    this.onLoading,
    this.onChanged,
    required this.builder,
  });

  @override
  State<PurchaseBuilder> createState() => _PurchaseBuilderState();
}

class _PurchaseBuilderState extends State<PurchaseBuilder> {
  void _listener() {
    final status = Purchaser.i.status;
    if (widget.onLoading != null) {
      widget.onLoading!(context, status.isLoading);
    }
    if (widget.onError != null && status.isFailed) {
      widget.onError!(context, status.errorType);
      return;
    }
    if (widget.onChanged != null) {
      widget.onChanged!(context, Purchaser.i.isActive);
    }
  }

  List<PurchasableProduct> get products {
    return widget.productType == PurchaserProductType.initial
        ? Purchaser.i.products
        : Purchaser.i.otoProducts;
  }

  @override
  void initState() {
    Purchaser.i.addListener(_listener);
    super.initState();
  }

  @override
  void didUpdateWidget(PurchaseBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productType != widget.productType) {
      Purchaser.i.removeListener(_listener);
      Purchaser.i.addListener(_listener);
    }
  }

  @override
  void dispose() {
    Purchaser.i.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, products);
}
