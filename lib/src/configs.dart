import 'package:flutter/material.dart';

import '../src/purchase_result.dart';

abstract class InAppPurchaseConfigDelegate {
  /// Whether a previously persisted (cached) premium status is active.
  bool get cachedStatus;

  /// Premium status to report when there is no network connection.
  ///
  /// Defaults to [cachedStatus].
  bool get offlineStatus => cachedStatus;

  /// Formats a feature identifier before it is stored or looked up.
  ///
  /// Override to apply consistent normalisation (e.g. lower-casing).
  String formatFeature(String feature) => feature;

  /// Returns a formatted price string for [price] in [currencyCode], or
  /// `null` to let the library use its built-in formatting.
  String? formatPrice(Locale locale, String currencyCode, double price) => null;

  /// Strips trailing zeros (and optionally the decimal separator) from a
  /// formatted price string.
  ///
  /// Example: `"9.00"` → `"9"`, `"9.90"` → `"9.9"`.
  String formatZeros(String value) {
    return value.replaceAll(RegExp(r'([.]*0+)$'), '');
  }

  /// Rounds [value] to the nearest "99-cent" psychological price point.
  ///
  /// Example: `10.0` → `9.99`.
  double prettyPrice(double value) {
    return (value.roundToDouble() + 0.99 - 1).abs();
  }

  /// Localizes [raw] for the given [locale].
  ///
  /// Return [raw] unchanged if no translation is needed.
  String localize(Locale locale, String raw) => raw;

  /// Safely casts [value] to [T], returning [defaultValue] on failure.
  T parse<T extends Object?>(Object? value, T defaultValue) {
    return value is T ? value : defaultValue;
  }

  /// Called after a successful login.
  void loggedIn() {}

  /// Called after a successful logout.
  void loggedOut() {}

  /// Called whenever the active locale changes.
  void localeChanged(Locale locale) {}

  /// Opens the paywall screen. [onPurchased] must be called when the user
  /// completes a purchase so that the calling code can proceed.
  ///
  /// Throws [UnimplementedError] by default — override to provide a UI.
  void openPaywall(
    BuildContext context,
    VoidCallback onPurchased,
  ) {
    throw UnimplementedError('openPaywall() not implemented yet!');
  }

  /// Called when the active paywall placement identifier changes.
  void paywallChanged(String id) {}

  /// Called when a single paywall has finished loading.
  void paywallLoaded(String id) {}

  /// Called when all paywalls have finished loading.
  void paywallsLoaded(List<String> ids) {}

  /// Called after a successful purchase.
  void purchased(InAppPurchaseResultSuccess result) {}

  /// Called after a successful restore.
  void restored(InAppPurchaseProfile profile) {}

  /// Persists the latest premium [status] to local storage so that it can be
  /// surfaced via [cachedStatus] / [offlineStatus] on next launch.
  void saveStoreStatus(bool status);

  /// Called after a third-party attribution SDK (e.g. Adjust, Facebook) has
  /// been initialised. [id] identifies which SDK was loaded.
  void sdkLoaded(String id) {}

  /// Shows an interstitial or rewarded ad. [onLoaded] is called when the user
  /// has finished watching / dismissing the ad.
  ///
  /// Throws [UnimplementedError] by default — override to provide ad logic.
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
    throw UnimplementedError('showAd() not implemented yet!');
  }

  /// Called when the premium status changes.
  void statusChanged(bool status) {}

  /// Called when the app theme changes.
  void themeChanged(bool dark) {}
}
