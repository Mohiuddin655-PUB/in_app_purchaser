import 'dart:ui';

import 'package:collection/collection.dart';

import '../src/purchaser.dart';

const kDiscountPrice = "{DISCOUNT_PRICE}";
const kPrice = "{PRICE}";
const kFormatedPrice = "{FORMATED_PRICE}";
const kLocalizedPrice = "{LOCALIZED_PRICE}";

const _equality = DeepCollectionEquality();

typedef PaywallLocalizeCallback = String Function(Locale locale, String value);

class PaywallLocalizedContent<T> {
  final T? value;
  final Map<String, T> values;

  static PaywallLocalizeCallback? localizer;

  bool get isEmpty => value == null && values.isEmpty;

  bool get isNotEmpty => !isEmpty;

  const PaywallLocalizedContent._(
    this.value, [
    this.values = const {},
  ]);

  const PaywallLocalizedContent(T value) : this._(value);

  PaywallLocalizedContent.localized(Map<String, T> value)
      : this._(value['en'], value);

  const PaywallLocalizedContent.none() : this._(null);

  static PaywallLocalizedContent<T>? parse<T>(Object? source) {
    if (source is T) {
      return PaywallLocalizedContent(source);
    }
    if (source is! Map || source.isEmpty) {
      return PaywallLocalizedContent.none();
    }
    final en = source['en'];
    final entries = source.entries.map((e) {
      final key = e.key;
      if (key is! String || key.isEmpty) return null;
      final value = e.value;
      if (value is! T) return null;
      return MapEntry(key, value);
    }).whereType<MapEntry<String, T>>();
    if (en is! T && entries.isEmpty) return null;
    return PaywallLocalizedContent._(
      en is T ? en : null,
      Map.fromEntries(entries),
    );
  }

  PaywallLocalizedContent<T> localized(Locale locale) {
    T? x = values[locale.languageCode];
    if (x == null && InAppPurchaser.i.configDelegate != null) {
      final l = locale;
      final d = InAppPurchaser.i.configDelegate!;
      Object? lt(Object? e) {
        if (e is String) return d.localize(l, e);
        if (e is Map) return e.map((k, v) => MapEntry(k, lt(v)));
        if (e is List) return e.map(lt).toList();
        return e;
      }

      final y = lt(value);
      if (y is T) x = y;
    }
    return copyWith(value: x);
  }

  PaywallLocalizedContent<T> resolveWith(T Function(T value) callback) {
    return PaywallLocalizedContent._(
      value == null ? null : callback(value as T),
      values.isEmpty ? values : values.map((k, v) => MapEntry(k, callback(v))),
    );
  }

  PaywallLocalizedContent<T> copyWith({
    T? value,
    Map<String, T>? values,
  }) {
    return PaywallLocalizedContent._(
      value ?? this.value,
      values ?? this.values,
    );
  }

  Object? toJson(Object? Function(T? value) callback) {
    final value = callback(this.value);
    final entries = values.entries.map((e) {
      final value = callback(e.value);
      if (value == null) return null;
      return MapEntry(e.key, value);
    }).whereType<MapEntry<String, Object>>();
    final x = Map.fromEntries(entries);
    if (value != null) x['en'] = value;
    if (x.length <= 1) return value;
    return x;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is PaywallLocalizedContent<T> &&
        _equality.equals(value, other.value) &&
        _equality.equals(values, other.values);
  }

  @override
  int get hashCode {
    return Object.hash(_equality.hash(value), _equality.hash(values));
  }

  @override
  String toString() => "$PaywallLocalizedContent#$hashCode($value, $values)";
}

extension PaywallLocalizedStringExtension on PaywallLocalizedContent<String?> {
  PaywallLocalizedContent<String?> replaceAll(Pattern from, String replace) {
    return resolveWith((value) => value?.replaceAll(from, replace));
  }

  PaywallLocalizedContent<String?> stringify({
    required double? usdPrice,
    required double? price,
    required int unit,
    required double discountPrice,
    required String localizedPrice,
    required String currencyCode,
  }) {
    if (isEmpty) return this;
    final delegate = InAppPurchaser.i.configDelegate;
    String formatPrice(double value, String currencyCode) {
      if (delegate != null) {
        final formatted = delegate.formatPrice(
          InAppPurchaser.i.locale,
          currencyCode,
          value,
        );
        if (formatted != null) {
          return delegate.formatZeros(formatted);
        }
      }
      String str = value.toStringAsFixed(2);
      str = str.replaceAll(RegExp(r'([.]*0+)$'), '');
      return "$currencyCode $str";
    }

    double? formatNumber(double? b, double? r, double? c) {
      if (b == null || r == null || c == null) return null;
      final x = (r / b) * c;
      if (delegate != null) return delegate.prettyPrice(x);
      return (x.roundToDouble() + 0.99 - 1).abs();
    }

    final mPrice =
        formatNumber(usdPrice, discountPrice, price) ?? discountPrice;
    final mFormatedPrice = discountPrice / unit;
    return replaceAll(kDiscountPrice, formatPrice(discountPrice, currencyCode))
        .replaceAll(kFormatedPrice, formatPrice(mFormatedPrice, currencyCode))
        .replaceAll(kPrice, formatPrice(mPrice, currencyCode))
        .replaceAll(kLocalizedPrice, localizedPrice);
  }
}
