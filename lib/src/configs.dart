import 'dart:ui';

abstract class InAppPurchaseConfigDelegate {
  String formatFeature(String feature) => feature;

  /// Convert USD amount to local currency with sign
  /// ```dart
  ///String formatPrice(Locale locale, String currencyCode, double price) {
  ///  final format = NumberFormat.simpleCurrency(
  ///    locale: locale.toString(),
  ///    name: currencyCode,
  ///  );
  ///  return format.format(price);
  ///}
  /// ```
  String? formatPrice(Locale locale, String currencyCode, double price);

  String formatZeros(String value) {
    return value.replaceAll(RegExp(r'([.]*0+)$'), '');
  }

  double prettyPrice(double value) {
    return (value.roundToDouble() + 0.99 - 1).abs();
  }

  String localize(Locale locale, String raw) => raw;
}
