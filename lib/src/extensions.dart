import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/provider.dart';
import 'purchaser.dart';

extension PurchaserHelper on BuildContext {
  Purchaser<T> _i<T>(String name) {
    try {
      return findPurchaser<T>();
    } catch (_) {
      throw UnimplementedError(
        "You should call like $name<$T>()",
      );
    }
  }

  Purchaser<T> findPurchaser<T>() {
    try {
      return PurchaseProvider.purchaserOf<T>(this);
    } catch (_) {
      throw UnimplementedError(
        "You should call like findPurchaser<$T>()",
      );
    }
  }

  Future<Object?> purchase<T>(T product) {
    return _i<T>("purchase").purchase(product);
  }

  Future<Object?> purchaseAt<T>(int index) {
    return _i<T>("purchaseAt").purchaseAt(index);
  }

  Future<Object?> restore<T>([bool silent = false]) {
    return _i<T>("restore").restore(silent);
  }
}
