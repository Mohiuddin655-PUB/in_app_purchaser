import 'dart:ui';

abstract class InAppPurchaseConfigDelegate {
  /// Convert USD amount to local currency with sign
  /// ```dart
  ///String convertPrice(Locale locale, String currencyCode, double price) {
  ///  final format = NumberFormat.simpleCurrency(
  ///    locale: locale.toString(),
  ///    name: currencyCode,
  ///  );
  ///  return format.format(price);
  ///}
  /// ```
  String? formatPrice(Locale locale, String currencyCode, double price);

  String? localize(Locale locale, String? key);
}
