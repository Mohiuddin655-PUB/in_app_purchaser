import 'dart:ui';

import '../utils/localized_content.dart';
import '../utils/state.dart';
import '../utils/style.dart';
import '../utils/typedefs.dart';
import 'offering.dart';
import 'purchaser.dart';

class PaywallProduct {
  final bool selected;
  final InAppPurchaseProduct product;
  final double? price;
  final double? usdPrice;
  final int? unit;
  final Map? configs;

  // STRINGS
  final PaywallState<PaywallLocalizedContent<String?>?>? badgeTextState;
  final PaywallState<PaywallLocalizedContent<String?>?>? bottomTextState;
  final PaywallState<PaywallLocalizedContent<String?>?>? buttonTextState;
  final PaywallState<PaywallLocalizedContent<String?>?>? descriptionTextState;
  final PaywallState<PaywallLocalizedContent<String?>?>? leftBottomTextState;
  final PaywallState<PaywallLocalizedContent<String?>?>? leftMiddleTextState;
  final PaywallState<PaywallLocalizedContent<String?>?>? leftTopTextState;
  final PaywallState<PaywallLocalizedContent<String?>?>? rightBottomTextState;
  final PaywallState<PaywallLocalizedContent<String?>?>? rightMiddleTextState;
  final PaywallState<PaywallLocalizedContent<String?>?>? rightTopTextState;
  final PaywallState<PaywallLocalizedContent<String?>?>? titleTextState;

  // STYLES
  final PaywallStyle? badgeStyle;
  final PaywallStyle? bottomStyle;
  final PaywallStyle? buttonStyle;
  final PaywallStyle? descriptionStyle;
  final PaywallStyle? leftStyle;
  final PaywallStyle? leftBottomStyle;
  final PaywallStyle? leftMiddleStyle;
  final PaywallStyle? leftTopStyle;
  final PaywallStyle? rightStyle;
  final PaywallStyle? rightBottomStyle;
  final PaywallStyle? rightMiddleStyle;
  final PaywallStyle? rightTopStyle;
  final PaywallStyle? style;
  final PaywallStyle? titleStyle;

  const PaywallProduct({
    required this.product,
    this.selected = false,
    this.configs = const {},
    this.price,
    this.usdPrice,
    this.unit,
    // STRINGS
    this.badgeTextState,
    this.bottomTextState,
    this.buttonTextState,
    this.descriptionTextState,
    this.leftBottomTextState,
    this.leftMiddleTextState,
    this.leftTopTextState,
    this.rightBottomTextState,
    this.rightMiddleTextState,
    this.rightTopTextState,
    this.titleTextState,
    // STYLES
    this.badgeStyle,
    this.bottomStyle,
    this.buttonStyle,
    this.descriptionStyle,
    this.leftStyle,
    this.leftBottomStyle,
    this.leftMiddleStyle,
    this.leftTopStyle,
    this.rightStyle,
    this.rightBottomStyle,
    this.rightMiddleStyle,
    this.rightTopStyle,
    this.style,
    this.titleStyle,
  });

  // LOCALIZED STRINGS
  String? get badgeTextLocalized => badgeText?.value;

  String? get bottomTextLocalized => bottomText?.value;

  String? get buttonTextLocalized => buttonText?.value;

  String? get descriptionTextLocalized => descriptionText?.value;

  String? get leftBottomTextLocalized => leftBottomText?.value;

  String? get leftMiddleTextLocalized => leftMiddleText?.value;

  String? get leftTopTextLocalized => leftTopText?.value;

  String? get rightBottomTextLocalized => rightBottomText?.value;

  String? get rightMiddleTextLocalized => rightMiddleText?.value;

  String? get rightTopTextLocalized => rightTopText?.value;

  String? get titleTextLocalized => titleText?.value;

  // STRINGS
  PaywallLocalizedContent<String?>? get badgeText {
    return badgeTextState?.of(selected);
  }

  PaywallLocalizedContent<String?>? get bottomText {
    return bottomTextState?.of(selected);
  }

  PaywallLocalizedContent<String?>? get buttonText {
    return buttonTextState?.of(selected);
  }

  PaywallLocalizedContent<String?>? get descriptionText {
    return descriptionTextState?.of(selected);
  }

  PaywallLocalizedContent<String?>? get leftBottomText {
    return leftBottomTextState?.of(selected);
  }

  PaywallLocalizedContent<String?>? get leftMiddleText {
    return leftMiddleTextState?.of(selected);
  }

  PaywallLocalizedContent<String?>? get leftTopText {
    return leftTopTextState?.of(selected);
  }

  PaywallLocalizedContent<String?>? get rightBottomText {
    return rightBottomTextState?.of(selected);
  }

  PaywallLocalizedContent<String?>? get rightMiddleText {
    return rightMiddleTextState?.of(selected);
  }

  PaywallLocalizedContent<String?>? get rightTopText {
    return rightTopTextState?.of(selected);
  }

  PaywallLocalizedContent<String?>? get titleText {
    return titleTextState?.of(selected);
  }

  // STYLES
  PaywallStyle? get selectedTitleStyle {
    return titleStyle?.copyWith(selected: selected);
  }

  PaywallStyle? get selectedDescriptionStyle {
    return descriptionStyle?.copyWith(selected: selected);
  }

  PaywallStyle? get selectedStyle {
    return style?.copyWith(selected: selected);
  }

  PaywallStyle? get selectedBadgeStyle {
    return badgeStyle?.copyWith(selected: selected);
  }

  PaywallStyle? get selectedLeftStyle {
    return leftStyle?.copyWith(selected: selected);
  }

  PaywallStyle? get selectedLeftTopStyle {
    return leftTopStyle?.copyWith(selected: selected);
  }

  PaywallStyle? get selectedLeftMiddleStyle {
    return leftMiddleStyle?.copyWith(selected: selected);
  }

  PaywallStyle? get selectedLeftBottomStyle {
    return leftBottomStyle?.copyWith(selected: selected);
  }

  PaywallStyle? get selectedRightStyle {
    return rightStyle?.copyWith(selected: selected);
  }

  PaywallStyle? get selectedRightTopStyle {
    return rightTopStyle?.copyWith(selected: selected);
  }

  PaywallStyle? get selectedRightMiddleStyle {
    return rightMiddleStyle?.copyWith(selected: selected);
  }

  PaywallStyle? get selectedRightBottomStyle {
    return rightBottomStyle?.copyWith(selected: selected);
  }

  PaywallStyle? get selectedButtonStyle {
    return buttonStyle?.copyWith(selected: selected);
  }

  PaywallStyle? get selectedBottomStyle {
    return bottomStyle?.copyWith(selected: selected);
  }

  // DICTIONARY
  Map<String, dynamic> get dictionary {
    final map = <String, dynamic>{};

    void addDictionary(String key, Map? value) {
      if (value == null || value.isEmpty) return;
      map[key] = value;
    }

    void addObject(String key, Object? value) {
      if (value == null) return;
      map[key] = value;
    }

    addObject("price", price);
    addObject("usdPrice", usdPrice);
    addObject("unit", unit);

    // STRINGS
    addObject("badgeText", badgeTextState?.toJson((e) => e?.toJson((e) => e)));
    addObject("bottomText", bottomTextState?.toJson((e) {
      return e?.toJson((e) => e);
    }));
    addObject("buttonText", buttonTextState?.toJson((e) {
      return e?.toJson((e) => e);
    }));
    addObject("descriptionText", descriptionTextState?.toJson((e) {
      return e?.toJson((e) => e);
    }));
    addObject("leftBottomText", leftBottomTextState?.toJson((e) {
      return e?.toJson((e) => e);
    }));
    addObject("leftMiddleText", leftMiddleTextState?.toJson((e) {
      return e?.toJson((e) => e);
    }));
    addObject("leftTopText", leftTopTextState?.toJson((e) {
      return e?.toJson((e) => e);
    }));
    addObject("rightBottomText", rightBottomTextState?.toJson((e) {
      return e?.toJson((e) => e);
    }));
    addObject("rightMiddleText", rightMiddleTextState?.toJson((e) {
      return e?.toJson((e) => e);
    }));
    addObject("rightTopText", rightTopTextState?.toJson((e) {
      return e?.toJson((e) => e);
    }));
    addObject("titleText", titleTextState?.toJson((e) => e?.toJson((e) => e)));

    // STYLES
    addDictionary("badgeStyle", badgeStyle?.dictionary);
    addDictionary("bottomStyle", bottomStyle?.dictionary);
    addDictionary("buttonStyle", buttonStyle?.dictionary);
    addDictionary("descriptionStyle", descriptionStyle?.dictionary);
    addDictionary("leftStyle", leftStyle?.dictionary);
    addDictionary("leftBottomStyle", leftBottomStyle?.dictionary);
    addDictionary("leftMiddleStyle", leftMiddleStyle?.dictionary);
    addDictionary("leftTopStyle", leftTopStyle?.dictionary);
    addDictionary("rightStyle", rightStyle?.dictionary);
    addDictionary("rightBottomStyle", rightBottomStyle?.dictionary);
    addDictionary("rightMiddleStyle", rightMiddleStyle?.dictionary);
    addDictionary("rightTopStyle", rightTopStyle?.dictionary);
    addDictionary("style", style?.dictionary);
    addDictionary("titleStyle", titleStyle?.dictionary);
    return map;
  }

  factory PaywallProduct.fromConfigs({
    required InAppPurchaseProduct product,
    required Map configs,
    required bool dark,
  }) {
    final parser = InAppPurchaser.parseConfig;

    double? price = parser(configs['price'], null);
    double? usdPrice = parser(configs['usdPrice'], null);
    int? unit = parser(configs['unit'], null);

    PaywallLocalizedContent<String?>? stringify(
      PaywallLocalizedContent<String?>? value,
    ) {
      if (value == null || value.isEmpty) return value;
      return value.stringify(
        usdPrice: usdPrice,
        price: price,
        unit: unit ?? 1,
        discountPrice: product.price ?? 0.00,
        localizedPrice: product.priceString ?? 'USD 0.00',
        currencyCode: product.currencyCode ?? "USD",
      );
    }

    return PaywallProduct(
      selected: false,
      product: product,
      configs: configs,
      price: price,
      usdPrice: usdPrice,
      unit: unit,
      // STRINGS
      leftTopTextState: PaywallState.parse(
        configs['leftTopText'],
        PaywallLocalizedContent.parse,
        resolveWith: stringify,
      ),
      leftMiddleTextState: PaywallState.parse(
        configs['leftMiddleText'],
        PaywallLocalizedContent.parse,
        resolveWith: stringify,
      ),
      leftBottomTextState: PaywallState.parse(
        configs['leftBottomText'],
        PaywallLocalizedContent.parse,
        resolveWith: stringify,
      ),
      rightTopTextState: PaywallState.parse(
        configs['rightTopText'],
        PaywallLocalizedContent.parse,
        resolveWith: stringify,
      ),
      rightMiddleTextState: PaywallState.parse(
        configs['rightMiddleText'],
        PaywallLocalizedContent.parse,
        resolveWith: stringify,
      ),
      rightBottomTextState: PaywallState.parse(
        configs['rightBottomText'],
        PaywallLocalizedContent.parse,
        resolveWith: stringify,
      ),
      badgeTextState: PaywallState.parse(
        configs['badgeText'],
        PaywallLocalizedContent.parse,
        resolveWith: stringify,
      ),
      buttonTextState: PaywallState.parse(
        configs['buttonText'],
        PaywallLocalizedContent.parse,
        resolveWith: stringify,
      ),
      bottomTextState: PaywallState.parse(
        configs['bottomText'],
        PaywallLocalizedContent.parse,
        resolveWith: stringify,
      ),
      titleTextState: PaywallState.parse(
        configs['titleText'],
        PaywallLocalizedContent.parse,
        resolveWith: stringify,
      ),
      descriptionTextState: PaywallState.parse(
        configs['descriptionText'],
        PaywallLocalizedContent.parse,
        resolveWith: stringify,
      ),
      // STYLES
      badgeStyle: PaywallStyle.parse(configs["badgeStyle"], dark),
      bottomStyle: PaywallStyle.parse(configs["bottomStyle"], dark),
      buttonStyle: PaywallStyle.parse(configs["buttonStyle"], dark),
      descriptionStyle: PaywallStyle.parse(configs["descriptionStyle"], dark),
      leftStyle: PaywallStyle.parse(configs['leftStyle'], dark),
      leftBottomStyle: PaywallStyle.parse(configs["leftBottomStyle"], dark),
      leftMiddleStyle: PaywallStyle.parse(configs["leftMiddleStyle"], dark),
      leftTopStyle: PaywallStyle.parse(configs["leftTopStyle"], dark),
      rightStyle: PaywallStyle.parse(configs["rightStyle"], dark),
      rightBottomStyle: PaywallStyle.parse(configs["rightBottomStyle"], dark),
      rightMiddleStyle: PaywallStyle.parse(configs["rightMiddleStyle"], dark),
      rightTopStyle: PaywallStyle.parse(configs["rightTopStyle"], dark),
      style: PaywallStyle.parse(configs['style'], dark),
      titleStyle: PaywallStyle.parse(configs["titleStyle"], dark),
    );
  }

  PaywallProduct copyWith({
    bool? selected,
    InAppPurchaseProduct? product,
    Map? configs,
    double? price,
    double? usdPrice,
    int? unit,
    // STRINGS
    PaywallState<PaywallLocalizedContent<String?>?>? badgeTextState,
    PaywallState<PaywallLocalizedContent<String?>?>? bottomTextState,
    PaywallState<PaywallLocalizedContent<String?>?>? buttonTextState,
    PaywallState<PaywallLocalizedContent<String?>?>? descriptionTextState,
    PaywallState<PaywallLocalizedContent<String?>?>? leftBottomTextState,
    PaywallState<PaywallLocalizedContent<String?>?>? leftMiddleTextState,
    PaywallState<PaywallLocalizedContent<String?>?>? leftTopTextState,
    PaywallState<PaywallLocalizedContent<String?>?>? rightBottomTextState,
    PaywallState<PaywallLocalizedContent<String?>?>? rightMiddleTextState,
    PaywallState<PaywallLocalizedContent<String?>?>? rightTopTextState,
    PaywallState<PaywallLocalizedContent<String?>?>? titleTextState,
    // STYLES
    PaywallStyle? badgeStyle,
    PaywallStyle? bottomStyle,
    PaywallStyle? buttonStyle,
    PaywallStyle? descriptionStyle,
    PaywallStyle? leftStyle,
    PaywallStyle? leftBottomStyle,
    PaywallStyle? leftMiddleStyle,
    PaywallStyle? leftTopStyle,
    PaywallStyle? rightStyle,
    PaywallStyle? rightBottomStyle,
    PaywallStyle? rightMiddleStyle,
    PaywallStyle? rightTopStyle,
    PaywallStyle? style,
    PaywallStyle? titleStyle,
  }) {
    return PaywallProduct(
      selected: selected ?? this.selected,
      product: product ?? this.product,
      configs: configs ?? this.configs,
      price: price ?? this.price,
      usdPrice: usdPrice ?? this.usdPrice,
      unit: unit ?? this.unit,
      // STRINGS
      badgeTextState: badgeTextState ?? this.badgeTextState,
      bottomTextState: bottomTextState ?? this.bottomTextState,
      buttonTextState: buttonTextState ?? this.buttonTextState,
      descriptionTextState: descriptionTextState ?? this.descriptionTextState,
      leftBottomTextState: leftBottomTextState ?? this.leftBottomTextState,
      leftMiddleTextState: leftMiddleTextState ?? this.leftMiddleTextState,
      leftTopTextState: leftTopTextState ?? this.leftTopTextState,
      rightBottomTextState: rightBottomTextState ?? this.rightBottomTextState,
      rightMiddleTextState: rightMiddleTextState ?? this.rightMiddleTextState,
      rightTopTextState: rightTopTextState ?? this.rightTopTextState,
      titleTextState: titleTextState ?? this.titleTextState,
      // STYLES
      badgeStyle: badgeStyle ?? this.badgeStyle,
      bottomStyle: bottomStyle ?? this.bottomStyle,
      buttonStyle: buttonStyle ?? this.buttonStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      leftStyle: leftStyle ?? this.leftStyle,
      leftBottomStyle: leftBottomStyle ?? this.leftBottomStyle,
      leftMiddleStyle: leftMiddleStyle ?? this.leftMiddleStyle,
      leftTopStyle: leftTopStyle ?? this.leftTopStyle,
      rightStyle: rightStyle ?? this.rightStyle,
      rightBottomStyle: rightBottomStyle ?? this.rightBottomStyle,
      rightMiddleStyle: rightMiddleStyle ?? this.rightMiddleStyle,
      rightTopStyle: rightTopStyle ?? this.rightTopStyle,
      style: style ?? this.style,
      titleStyle: titleStyle ?? this.titleStyle,
    );
  }

  PaywallProduct localized(Locale locale, {bool? stringify}) {
    PaywallLocalizedContent<String?>? resolver(
      PaywallLocalizedContent<String?>? value,
    ) {
      if (value == null || value.isEmpty) return value;
      value = value.localized(locale);
      if (!(stringify ?? true)) return value;
      return value.stringify(
        usdPrice: usdPrice,
        price: price,
        unit: unit ?? 1,
        discountPrice: product.price ?? 0.00,
        localizedPrice: product.priceString ?? 'USD 0.00',
        currencyCode: product.currencyCode ?? "USD",
      );
    }

    return copyWith(
      badgeTextState: badgeTextState?.resolveWith(resolver),
      bottomTextState: bottomTextState?.resolveWith(resolver),
      buttonTextState: buttonTextState?.resolveWith(resolver),
      descriptionTextState: descriptionTextState?.resolveWith(resolver),
      leftBottomTextState: leftBottomTextState?.resolveWith(resolver),
      leftMiddleTextState: leftMiddleTextState?.resolveWith(resolver),
      leftTopTextState: leftTopTextState?.resolveWith(resolver),
      rightBottomTextState: rightBottomTextState?.resolveWith(resolver),
      rightMiddleTextState: rightMiddleTextState?.resolveWith(resolver),
      rightTopTextState: rightTopTextState?.resolveWith(resolver),
      titleTextState: titleTextState?.resolveWith(resolver),
    );
  }

  PaywallProduct stringify() {
    PaywallLocalizedContent<String?>? resolver(
      PaywallLocalizedContent<String?>? value,
    ) {
      if (value == null || value.isEmpty) return value;
      return value.stringify(
        usdPrice: usdPrice,
        price: price,
        unit: unit ?? 1,
        discountPrice: product.price ?? 0.00,
        localizedPrice: product.priceString ?? 'USD 0.00',
        currencyCode: product.currencyCode ?? "USD",
      );
    }

    return copyWith(
      badgeTextState: badgeTextState?.resolveWith(resolver),
      bottomTextState: bottomTextState?.resolveWith(resolver),
      buttonTextState: buttonTextState?.resolveWith(resolver),
      descriptionTextState: descriptionTextState?.resolveWith(resolver),
      leftBottomTextState: leftBottomTextState?.resolveWith(resolver),
      leftMiddleTextState: leftMiddleTextState?.resolveWith(resolver),
      leftTopTextState: leftTopTextState?.resolveWith(resolver),
      rightBottomTextState: rightBottomTextState?.resolveWith(resolver),
      rightMiddleTextState: rightMiddleTextState?.resolveWith(resolver),
      rightTopTextState: rightTopTextState?.resolveWith(resolver),
      titleTextState: titleTextState?.resolveWith(resolver),
    );
  }

  PaywallProduct themed(bool dark) {
    final configs = this.configs ?? {};
    if (configs.isEmpty) return this;
    return copyWith(
      badgeStyle: PaywallStyle.parse(configs["badgeStyle"], dark),
      bottomStyle: PaywallStyle.parse(configs["bottomStyle"], dark),
      buttonStyle: PaywallStyle.parse(configs["buttonStyle"], dark),
      descriptionStyle: PaywallStyle.parse(configs["descriptionStyle"], dark),
      leftStyle: PaywallStyle.parse(configs['leftStyle'], dark),
      leftBottomStyle: PaywallStyle.parse(configs["leftBottomStyle"], dark),
      leftMiddleStyle: PaywallStyle.parse(configs["leftMiddleStyle"], dark),
      leftTopStyle: PaywallStyle.parse(configs["leftTopStyle"], dark),
      rightStyle: PaywallStyle.parse(configs["rightStyle"], dark),
      rightBottomStyle: PaywallStyle.parse(configs["rightBottomStyle"], dark),
      rightMiddleStyle: PaywallStyle.parse(configs["rightMiddleStyle"], dark),
      rightTopStyle: PaywallStyle.parse(configs["rightTopStyle"], dark),
      style: PaywallStyle.parse(configs['style'], dark),
      titleStyle: PaywallStyle.parse(configs["titleStyle"], dark),
    );
  }

  PaywallProduct resolveWith({
    bool? selected,
    PaywallScaler? scaler,
    TextDirection? textDirection,
  }) {
    return copyWith(
      badgeStyle: badgeStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      bottomStyle: bottomStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      buttonStyle: buttonStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      descriptionStyle: descriptionStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      leftStyle: leftStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      leftBottomStyle: leftBottomStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      leftMiddleStyle: leftMiddleStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      leftTopStyle: leftTopStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      rightStyle: rightStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      rightBottomStyle: rightBottomStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      rightMiddleStyle: rightMiddleStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      rightTopStyle: rightTopStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      style: style?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      titleStyle: titleStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
    );
  }

  @override
  int get hashCode {
    return Object.hashAll([
      product,
      price,
      usdPrice,
      unit,
      // STRINGS
      badgeTextState,
      bottomTextState,
      buttonTextState,
      descriptionTextState,
      leftBottomTextState,
      leftMiddleTextState,
      leftTopTextState,
      rightBottomTextState,
      rightMiddleTextState,
      rightTopTextState,
      titleTextState,
      // STYLES
      badgeStyle,
      bottomStyle,
      buttonStyle,
      descriptionStyle,
      leftStyle,
      leftBottomStyle,
      leftMiddleStyle,
      leftTopStyle,
      rightStyle,
      rightBottomStyle,
      rightMiddleStyle,
      rightTopStyle,
      style,
      titleStyle,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PaywallProduct &&
        product == other.product &&
        price == other.price &&
        usdPrice == other.usdPrice &&
        unit == other.unit &&
        // STRINGS
        badgeTextState == other.badgeTextState &&
        bottomTextState == other.bottomTextState &&
        buttonTextState == other.buttonTextState &&
        descriptionTextState == other.descriptionTextState &&
        leftBottomTextState == other.leftBottomTextState &&
        leftMiddleTextState == other.leftMiddleTextState &&
        leftTopTextState == other.leftTopTextState &&
        rightBottomTextState == other.rightBottomTextState &&
        rightMiddleTextState == other.rightMiddleTextState &&
        rightTopTextState == other.rightTopTextState &&
        titleTextState == other.titleTextState &&
        // STYLES
        badgeStyle == other.badgeStyle &&
        bottomStyle == other.bottomStyle &&
        buttonStyle == other.buttonStyle &&
        descriptionStyle == other.descriptionStyle &&
        leftStyle == other.leftStyle &&
        leftBottomStyle == other.leftBottomStyle &&
        leftMiddleStyle == other.leftMiddleStyle &&
        leftTopStyle == other.leftTopStyle &&
        rightStyle == other.rightStyle &&
        rightBottomStyle == other.rightBottomStyle &&
        rightMiddleStyle == other.rightMiddleStyle &&
        rightTopStyle == other.rightTopStyle &&
        style == other.style &&
        titleStyle == other.titleStyle;
  }

  @override
  String toString() => "$PaywallProduct#$hashCode(${product.id})";
}
