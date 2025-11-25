import 'package:flutter/material.dart';

import '../src/purchase_result.dart';

abstract class InAppPurchaseConfigDelegate {
  bool get cachedStatus;

  bool get offlineStatus => cachedStatus;

  String formatFeature(String feature) => feature;

  String? formatPrice(Locale locale, String currencyCode, double price) => null;

  String formatZeros(String value) {
    return value.replaceAll(RegExp(r'([.]*0+)$'), '');
  }

  double prettyPrice(double value) {
    return (value.roundToDouble() + 0.99 - 1).abs();
  }

  String localize(Locale locale, String raw) => raw;

  T parse<T extends Object?>(Object? value, T defaultValue) {
    return value is T ? value : defaultValue;
  }

  void loggedIn() {}

  void loggedOut() {}

  void localeChanged(Locale locale) {}

  void openPaywall(
    BuildContext context,
    VoidCallback onPurchased,
  ) {
    throw UnimplementedError("openPaywall() not implemented yet!");
  }

  void paywallChanged(String id) {}

  void paywallLoaded(String id) {}

  void paywallsLoaded(List<String> ids) {}

  void purchased(InAppPurchaseResultSuccess result) {}

  void restored(InAppPurchaseProfile profile) {}

  void saveStoreStatus(bool status);

  void sdkLoaded(String id) {}

  void showAd(
    BuildContext context,
    VoidCallback onLoaded, {
    ValueChanged<bool>? onLoading,
    ValueChanged<String>? onError,
    bool lock = true,
    bool force = false,
    String? feature,
    int? index,
  }) {
    throw UnimplementedError("showAd() not implemented yet!");
  }

  void statusChanged(bool status) {}

  void themeChanged(bool dark) {}
}
