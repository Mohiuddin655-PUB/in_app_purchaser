import 'package:flutter/material.dart';

import 'offering.dart';
import 'purchaser.dart';

class InAppPurchasePaywallConfigFormatters {
  const InAppPurchasePaywallConfigFormatters._();

  static const currencySign = "{CURRENCY_SIGN}";
  static const currencyName = "{CURRENCY_NAME}";
  static const discountPrice = "{DISCOUNT_PRICE}";
  static const price = "{PRICE}";
  static const formatedPrice = "{FORMATED_PRICE}";
  static const period = "{PERIOD}";
  static const unit = "{UNIT}";
}

class InAppPurchasePaywallStyle {
  final Alignment? alignment;
  final Color? color;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final double? size;
  final Border? border;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final EdgeInsets? position;

  const InAppPurchasePaywallStyle({
    this.alignment,
    this.color,
    this.backgroundColor,
    this.width,
    this.height,
    this.size,
    this.border,
    this.borderRadius,
    this.margin,
    this.padding,
    this.position,
  });

  static Alignment? _alignment(Object? source) {
    if (source is! Map || source.isEmpty) return null;
    return Alignment(_double(source['x']) ?? 0, _double(source['y']) ?? 0);
  }

  static double? _double(Object? source) {
    return source is num ? source.toDouble() : null;
  }

  static Color? _color(Object? source) {
    if (source is! String || source.isEmpty) return null;
    final value = int.tryParse(source);
    if (value == null || value < 0) return null;
    return Color(value);
  }

  static BorderSide _borderSide(Object? source) {
    if (source is! Map || source.isEmpty) return BorderSide.none;
    final color = _color(source['color']);
    final width = source['width'];
    if (color == null) return BorderSide.none;
    return BorderSide(color: color, width: width is num ? width.toDouble() : 0);
  }

  static Border? _border(Object? source) {
    if (source is! Map || source.isEmpty) return null;
    return Border(
      top: _borderSide(source["top"]),
      bottom: _borderSide(source["bottom"]),
      left: _borderSide(source["left"]),
      right: _borderSide(source["right"]),
    );
  }

  static BorderRadius? _borderRadius(Object? source) {
    if (source is! Map || source.isEmpty) return null;
    final bottomLeft = source['bottomLeft'];
    final bottomRight = source['bottomRight'];
    final topLeft = source['topLeft'];
    final topRight = source['topRight'];
    return BorderRadius.only(
      bottomLeft: Radius.circular(
        bottomLeft is num ? bottomLeft.toDouble() : 0,
      ),
      bottomRight: Radius.circular(
        bottomRight is num ? bottomRight.toDouble() : 0,
      ),
      topLeft: Radius.circular(topLeft is num ? topLeft.toDouble() : 0),
      topRight: Radius.circular(topRight is num ? topRight.toDouble() : 0),
    );
  }

  static EdgeInsets? _edgeInsets(Object? source) {
    if (source is! Map || source.isEmpty) return null;
    return EdgeInsets.only(
      left: _double(source['left']) ?? 0,
      right: _double(source['right']) ?? 0,
      top: _double(source['top']) ?? 0,
      bottom: _double(source['bottom']) ?? 0,
    );
  }

  factory InAppPurchasePaywallStyle.parse(Object? source) {
    if (source is! Map) return InAppPurchasePaywallStyle();
    return InAppPurchasePaywallStyle(
      alignment: _alignment(source['alignment']),
      color: _color(source['color']),
      backgroundColor: _color(source['backgroundColor']),
      width: _double(source['width']),
      height: _double(source['height']),
      size: _double(source['size']),
      border: _border(source['border']),
      borderRadius: _borderRadius(source['borderRadius']),
      margin: _edgeInsets(source['margin']),
      padding: _edgeInsets(source['padding']),
      position: _edgeInsets(source['position']),
    );
  }
}

class InAppPurchasePaywallProduct {
  final InAppPurchaseProduct product;
  final double? _price;
  final String? _period;
  final int? _unit;

  final String? _titleText;
  final InAppPurchasePaywallStyle? titleStyle;
  final String? _descriptionText;
  final InAppPurchasePaywallStyle? descriptionStyle;

  final String? _leftTopText;
  final InAppPurchasePaywallStyle? leftTopStyle;
  final String? _leftBottomText;
  final InAppPurchasePaywallStyle? leftBottomStyle;
  final String? _rightTopText;
  final InAppPurchasePaywallStyle? rightTopStyle;
  final String? _rightBottomText;
  final InAppPurchasePaywallStyle? rightBottomStyle;
  final String? _badgeText;
  final InAppPurchasePaywallStyle? badgeStyle;
  final String? _buttonText;
  final InAppPurchasePaywallStyle? buttonStyle;
  final String? _bottomText;
  final InAppPurchasePaywallStyle? bottomStyle;

  String? get titleText {
    if (_titleText == null) return null;
    return _titleText;
  }

  String? get descriptionText {
    if (_descriptionText == null) return null;
    return _descriptionText;
  }

  String? get leftTopText {
    if (_leftTopText == null) return null;
    return _leftTopText;
  }

  String? get leftBottomText {
    if (_leftBottomText == null) return null;
    return stringify(_leftBottomText);
  }

  String? get rightTopText {
    if (_rightTopText == null) return null;
    return stringify(_rightTopText);
  }

  String? get rightBottomText {
    if (_rightBottomText == null) return null;
    return stringify(_rightBottomText);
  }

  String? get badgeText {
    if (_badgeText == null) return null;
    return _badgeText;
  }

  String? get buttonText {
    if (_buttonText == null) return null;
    return stringify(_buttonText);
  }

  String? get bottomText {
    if (_bottomText == null) return null;
    return stringify(_bottomText);
  }

  String stringify(String? value) {
    if (value == null || value.isEmpty) return '';
    final period = _period ?? 'mo';
    final unit = _unit ?? 1;
    final currencySign = product.currencySign ?? "\$";
    final currencyName = product.currency ?? "USD";
    final discountPrice = product.price ?? 0;
    final price = _price ?? discountPrice;
    final formatedPrice = discountPrice / unit;
    return value
        .replaceAll(
          InAppPurchasePaywallConfigFormatters.currencySign,
          currencySign,
        )
        .replaceAll(
          InAppPurchasePaywallConfigFormatters.currencyName,
          currencyName,
        )
        .replaceAll(
          InAppPurchasePaywallConfigFormatters.discountPrice,
          discountPrice.toStringAsFixed(2),
        )
        .replaceAll(
          InAppPurchasePaywallConfigFormatters.formatedPrice,
          formatedPrice.toStringAsFixed(2),
        )
        .replaceAll(InAppPurchasePaywallConfigFormatters.period, period)
        .replaceAll(InAppPurchasePaywallConfigFormatters.unit, unit.toString())
        .replaceAll(
          InAppPurchasePaywallConfigFormatters.price,
          price.toStringAsFixed(2),
        );
  }

  const InAppPurchasePaywallProduct({
    required this.product,
    double? price,
    int? unit,
    String? period,
    String? titleText,
    String? descriptionText,
    String? leftTopText,
    String? leftBottomText,
    String? rightTopText,
    String? rightBottomText,
    String? badgeText,
    String? buttonText,
    String? bottomText,
    this.leftTopStyle,
    this.leftBottomStyle,
    this.rightTopStyle,
    this.rightBottomStyle,
    this.badgeStyle,
    this.buttonStyle,
    this.bottomStyle,
    this.titleStyle,
    this.descriptionStyle,
  })  : _price = price,
        _period = period,
        _unit = unit,
        _titleText = titleText,
        _descriptionText = descriptionText,
        _leftTopText = leftTopText,
        _leftBottomText = leftBottomText,
        _rightTopText = rightTopText,
        _rightBottomText = rightBottomText,
        _badgeText = badgeText,
        _buttonText = buttonText,
        _bottomText = bottomText;

  factory InAppPurchasePaywallProduct.fromConfigs({
    required InAppPurchaseProduct product,
    required Map configs,
    required int index,
  }) {
    final parser = InAppPurchaser.parseConfig;

    final prices = parser(configs, "prices", <double>[]);
    final periods = parser(configs, "periods", <String>[]);
    final units = parser(configs, "units", <int>[]);

    final leftTopTexts = parser(configs, "leftTopTexts", <String>[]);
    final leftBottomTexts = parser(configs, "leftBottomTexts", <String>[]);
    final rightTopTexts = parser(configs, "rightTopTexts", <String>[]);
    final rightBottomTexts = parser(configs, "rightBottomTexts", <String>[]);
    final badgeTexts = parser(configs, "badgeTexts", <String>[]);
    final buttonTexts = parser(configs, "buttonTexts", <String>[]);
    final bottomTexts = parser(configs, "bottomTexts", <String>[]);
    final titleTexts = parser(configs, "titleTexts", <String>[]);
    final descriptionTexts = parser(configs, "descriptionTexts", <String>[]);

    return InAppPurchasePaywallProduct(
      product: product,
      period: periods.elementAtOrNull(index),
      price: prices.elementAtOrNull(index),
      unit: units.elementAtOrNull(index),
      leftTopText: leftTopTexts.elementAtOrNull(index),
      leftTopStyle: InAppPurchasePaywallStyle.parse(configs["leftTopStyle"]),
      leftBottomText: leftBottomTexts.elementAtOrNull(index),
      leftBottomStyle: InAppPurchasePaywallStyle.parse(
        configs["leftBottomStyle"],
      ),
      rightTopText: rightTopTexts.elementAtOrNull(index),
      rightTopStyle: InAppPurchasePaywallStyle.parse(configs["rightTopStyle"]),
      rightBottomText: rightBottomTexts.elementAtOrNull(index),
      rightBottomStyle: InAppPurchasePaywallStyle.parse(
        configs["rightBottomStyle"],
      ),
      badgeText: badgeTexts.elementAtOrNull(index),
      badgeStyle: InAppPurchasePaywallStyle.parse(configs["badgeStyle"]),
      buttonText: buttonTexts.elementAtOrNull(index),
      buttonStyle: InAppPurchasePaywallStyle.parse(configs["buttonStyle"]),
      bottomText: bottomTexts.elementAtOrNull(index),
      bottomStyle: InAppPurchasePaywallStyle.parse(configs["bottomStyle"]),
      titleText: titleTexts.elementAtOrNull(index),
      titleStyle: InAppPurchasePaywallStyle.parse(configs["titleStyle"]),
      descriptionText: descriptionTexts.elementAtOrNull(index),
      descriptionStyle: InAppPurchasePaywallStyle.parse(
        configs["descriptionStyle"],
      ),
    );
  }
}

class InAppPurchasePaywall {
  final String id;
  final List<InAppPurchasePaywallProduct> products;

  final int initialIndex;
  final String designType;
  final bool skipMode;

  final String? headerText;
  final InAppPurchasePaywallStyle headerStyle;
  final String? bodyText;
  final InAppPurchasePaywallStyle bodyStyle;
  final String? titleText;
  final InAppPurchasePaywallStyle titleStyle;
  final String? description;
  final InAppPurchasePaywallStyle descriptionStyle;
  final List features;
  final InAppPurchasePaywallStyle featureStyle;

  const InAppPurchasePaywall({
    required this.id,
    required this.products,
    this.initialIndex = 0,
    this.designType = "v1",
    this.skipMode = false,
    this.headerText,
    this.headerStyle = const InAppPurchasePaywallStyle(),
    this.bodyText,
    this.bodyStyle = const InAppPurchasePaywallStyle(),
    this.titleText,
    this.titleStyle = const InAppPurchasePaywallStyle(),
    this.description,
    this.descriptionStyle = const InAppPurchasePaywallStyle(),
    this.features = const [],
    this.featureStyle = const InAppPurchasePaywallStyle(),
  });

  factory InAppPurchasePaywall.fromOffering(InAppPurchaseOffering offering) {
    final parser = InAppPurchaser.parseConfig;
    final configs = offering.configs;
    final paywall = configs["paywall"];
    final product = configs["product"];

    final hasSkip = parser(paywall, "skippable", false);
    final designType = parser(paywall, "designType", "v1");
    final headerText = parser<String?>(paywall, "headerText", null);
    final bodyText = parser<String?>(paywall, "bodyText", null);
    final titleText = parser<String?>(paywall, "titleText", null);
    final description = parser<String?>(paywall, "descriptionText", null);
    final features = parser(paywall, "features", []);

    final products = List.generate(offering.products.length, (index) {
      return InAppPurchasePaywallProduct.fromConfigs(
        product: offering.products[index],
        configs: product is Map ? product : {},
        index: index,
      );
    });

    return InAppPurchasePaywall(
      id: offering.id,
      products: products,
      designType: designType,
      skipMode: hasSkip,
      headerText: headerText,
      headerStyle: InAppPurchasePaywallStyle.parse(paywall["headerStyle"]),
      bodyText: bodyText,
      bodyStyle: InAppPurchasePaywallStyle.parse(paywall["bodyStyle"]),
      titleText: titleText,
      titleStyle: InAppPurchasePaywallStyle.parse(paywall["bodyStyle"]),
      description: description,
      descriptionStyle: InAppPurchasePaywallStyle.parse(paywall["bodyStyle"]),
      features: features,
      featureStyle: InAppPurchasePaywallStyle.parse(paywall["featureStyle"]),
    );
  }
}
