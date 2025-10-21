import 'dart:ui';

import '../src/purchase_result.dart';

abstract class InAppPurchaseConfigDelegate {
  bool get cachedStatus => false;

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

  void paywallChanged(String id) {}

  void paywallLoaded(String id) {}

  void paywallsLoaded(List<String> ids) {}

  void sdkLoaded(String id) {}

  void statusChanged(bool status) {}

  void themeChanged(bool dark) {}

  void purchased(InAppPurchaseResultSuccess result) {}

  void restored(InAppPurchaseProfile profile) {}
}
