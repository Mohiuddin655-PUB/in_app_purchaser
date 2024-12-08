import 'package:flutter/material.dart';
import 'package:in_app_purchaser/in_app_purchaser.dart';
import 'package:in_app_purchaser_delegate/in_app_purchaser_delegate.dart';

typedef OnPurchaserCallback<T> = void Function(BuildContext context, T value);
typedef OnPurchaserBuilder<T> = Widget Function(
  BuildContext context,
  List<PurchasableProduct> data,
);

enum PurchaserProductType { initial, oto }

class PurchaseBuilder<T> extends StatelessWidget {
  final PurchaserProductType productType;
  final OnPurchaserCallback<PurchaseErrorType>? onError;
  final OnPurchaserCallback<bool>? onLoading;
  final OnPurchaserCallback<bool>? onChanged;
  final OnPurchaserBuilder<T> builder;

  const PurchaseBuilder({
    super.key,
    this.productType = PurchaserProductType.initial,
    this.onError,
    this.onLoading,
    this.onChanged,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    try {
      return _Child<T>(
        purchaser: context.findPurchaser<T>(),
        builder: builder,
      );
    } catch (_) {
      throw UnimplementedError(
        "You should apply like $PurchaseBuilder<$T>()",
      );
    }
  }
}

class _Child<T> extends StatefulWidget {
  final PurchaserProductType productType;
  final Purchaser<T> purchaser;
  final OnPurchaserCallback<PurchaseErrorType>? onError;
  final OnPurchaserCallback<bool>? onLoading;
  final OnPurchaserCallback<bool>? onChanged;
  final OnPurchaserBuilder<T> builder;

  const _Child({
    this.productType = PurchaserProductType.initial,
    required this.purchaser,
    this.onError,
    this.onLoading,
    this.onChanged,
    required this.builder,
  });

  @override
  State<_Child<T>> createState() => _ChildState<T>();
}

class _ChildState<T> extends State<_Child<T>> {
  List<PurchasableProduct<T>> products = [];

  void _listener() {
    final status = widget.purchaser.status;
    if (widget.onLoading != null) {
      widget.onLoading!(context, status.isLoading);
    }
    if (widget.onError != null && status.isFailed) {
      widget.onError!(context, status.errorType);
      return;
    }
    if (widget.onChanged != null) {
      widget.onChanged!(context, widget.purchaser.isActive);
    }
  }

  ValueNotifier<List<PurchasableProduct<T>>> get productsNotifier {
    return widget.productType == PurchaserProductType.initial
        ? widget.purchaser.products
        : widget.purchaser.otoProducts;
  }

  void _productListener() => setState(() => products = productsNotifier.value);

  void _addListeners() {
    productsNotifier.addListener(_productListener);
    widget.purchaser.addListener(_listener);
  }

  void _removeListeners() {
    productsNotifier.removeListener(_productListener);
    widget.purchaser.removeListener(_listener);
  }

  @override
  void initState() {
    _addListeners();
    super.initState();
  }

  @override
  void didUpdateWidget(_Child<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.purchaser != widget.purchaser) {
      _removeListeners();
      _addListeners();
    }
  }

  @override
  void dispose() {
    _removeListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, products);
}
