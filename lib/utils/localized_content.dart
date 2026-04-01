import 'dart:ui';

import 'package:collection/collection.dart';

import '../src/purchaser.dart';

const kDiscountPrice = '{DISCOUNT_PRICE}';
const kPrice = '{PRICE}';
const kFormatedPrice = '{FORMATED_PRICE}';
const kLocalizedPrice = '{LOCALIZED_PRICE}';

const _equality = DeepCollectionEquality();

typedef PaywallLocalizeCallback = String Function(Locale locale, String value);

class PaywallLocalizedContent<T> {
  final T? value;
  final Map<String, T> values;

  /// Optional global string localizer applied when a per-language value is not
  /// found in [values].
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
    T? resolved = values[locale.languageCode];
    if (resolved == null && InAppPurchaser.iOrNull?.configDelegate != null) {
      final delegate = InAppPurchaser.i.configDelegate!;
      Object? translate(Object? e) {
        if (e is String) return delegate.localize(locale, e);
        if (e is Map) return e.map((k, v) => MapEntry(k, translate(v)));
        if (e is List) return e.map(translate).toList();
        return e;
      }

      final translated = translate(value ?? values['en']);
      if (translated is T) resolved = translated;
    }
    return copyWith(value: resolved);
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
    final rootValue = callback(value);
    final entries = values.entries.map((e) {
      final mapped = callback(e.value);
      if (mapped == null) return null;
      return MapEntry(e.key, mapped);
    }).whereType<MapEntry<String, Object>>();
    final map = Map.fromEntries(entries);
    if (rootValue != null) map['en'] = rootValue;
    if (map.length <= 1) return rootValue;
    return map;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is PaywallLocalizedContent<T> &&
        _equality.equals(value, other.value) &&
        _equality.equals(values, other.values);
  }

  @override
  int get hashCode {
    return Object.hash(_equality.hash(value), _equality.hash(values));
  }

  @override
  String toString() => '$PaywallLocalizedContent#$hashCode($value, $values)';
}

extension PaywallLocalizedStringExtension on PaywallLocalizedContent<String?> {
  PaywallLocalizedContent<String?> replaceAll(
    Pattern from,
    String replace, {
    bool? all,
  }) {
    if (all ?? false) {
      return resolveWith((value) => value?.replaceAll(from, replace));
    }
    return copyWith(value: value?.replaceAll(from, replace));
  }

  PaywallLocalizedContent<String?> stringify({
    bool? all,
    required double? usdPrice,
    required double? price,
    required int unit,
    required double discountPrice,
    required String localizedPrice,
    required String currencyCode,
  }) {
    if (isEmpty) return this;
    final delegate = InAppPurchaser.iOrNull?.configDelegate;

    String formatPrice(double value, String code) {
      if (delegate != null) {
        final formatted = delegate.formatPrice(
          InAppPurchaser.i.locale,
          code,
          value,
        );
        if (formatted != null) return delegate.formatZeros(formatted);
      }
      final str = value.toStringAsFixed(2).replaceAll(RegExp(r'([.]*0+)$'), '');
      return '$code $str';
    }

    double prettyPrice(double x) {
      if (delegate != null) return delegate.prettyPrice(x);
      return (x.roundToDouble() + 0.99 - 1).abs();
    }

    double? computePrice(double? base, double? ratio, double? target) {
      if (base == null || ratio == null || target == null) return null;
      return prettyPrice((ratio / base) * target);
    }

    return replaceAll(kDiscountPrice, formatPrice(discountPrice, currencyCode),
            all: all)
        .replaceAll(
          kFormatedPrice,
          formatPrice(discountPrice / unit, currencyCode),
          all: all,
        )
        .replaceAll(
          kPrice,
          formatPrice(
            computePrice(usdPrice, discountPrice, price) ?? discountPrice,
            currencyCode,
          ),
          all: all,
        )
        .replaceAll(kLocalizedPrice, localizedPrice, all: all);
  }
}
