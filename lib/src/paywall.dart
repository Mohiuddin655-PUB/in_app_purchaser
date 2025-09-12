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
  final double? blur;
  final Border? border;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final EdgeInsets? margin;
  final int? maxLines;
  final EdgeInsets? padding;
  final EdgeInsets? position;
  final LinearGradient? gradient;
  final double? size;
  final TextAlign? textAlign;
  final TextStyle? textStyle;

  const InAppPurchasePaywallStyle({
    this.alignment,
    this.color,
    this.backgroundColor,
    this.blur,
    this.width,
    this.height,
    this.size,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.margin,
    this.maxLines,
    this.padding,
    this.position,
    this.gradient,
    this.textAlign,
    this.textStyle,
  });

  static T? _enums<T extends Enum>(Object? source, Iterable<T> enums) {
    try {
      return enums.firstWhere((e) {
        if (e.index == source) return true;
        if (e.name == source) return true;
        if (e.toString() == source) return true;
        return false;
      });
    } catch (_) {
      return null;
    }
  }

  static FontWeight? _fontWeight(Object? source) {
    try {
      return FontWeight.values.firstWhere((e) {
        if (e.index == source) return true;
        if (e.value == source) return true;
        if (e.toString() == source) return true;
        return false;
      });
    } catch (_) {
      return null;
    }
  }

  static Alignment? _alignment(Object? source) {
    if (source is! Map || source.isEmpty) return null;
    return Alignment(_double(source['x']) ?? 0, _double(source['y']) ?? 0);
  }

  static double? _double(Object? source) {
    return source is num ? source.toDouble() : null;
  }

  static int? _int(Object? source) {
    return source is num ? source.toInt() : null;
  }

  static String? _string(Object? source) {
    return source is String && source.isNotEmpty ? source : null;
  }

  static Color? _color(Object? source) {
    if (source is! String || source.isEmpty) return null;
    final value = int.tryParse(source);
    if (value == null || value < 0) return null;
    return Color(value);
  }

  static FontStyle? _fontStyle(Object? source) {
    return _enums(source, FontStyle.values);
  }

  static Offset? _offset(Object? source) {
    if (source is! Map || source.isEmpty) return null;
    return Offset(
      _double(source['dx']) ?? 0,
      _double(source['dy']) ?? 0,
    );
  }

  static Shadow? _shadow(Object? source) {
    if (source is! Map || source.isEmpty) return null;
    return Shadow(
      color: _color(source['color']) ?? Colors.transparent,
      offset: _offset(source['offset']) ?? Offset.zero,
      blurRadius: _double(source['blurRadius']) ?? 0,
    );
  }

  static BlurStyle? _blurStyle(Object? source) {
    return _enums(source, BlurStyle.values);
  }

  static TextDecoration? _textDecoration(Object? source) {
    if (source is! String || source.isEmpty) return null;
    switch (source.trim().toString()) {
      case "lineThrough":
        return TextDecoration.lineThrough;
      case "overline":
        return TextDecoration.overline;
      case "underline":
        return TextDecoration.underline;
      default:
        return null;
    }
  }

  static TextDecorationStyle? _decorationStyle(Object? source) {
    return _enums(source, TextDecorationStyle.values);
  }

  static TextAlign? _textAlign(Object? source) {
    return _enums(source, TextAlign.values);
  }

  static TextOverflow? _textOverflow(Object? source) {
    return _enums(source, TextOverflow.values);
  }

  static TextStyle? _textStyle(Object? source) {
    if (source is! Map || source.isEmpty) return null;
    final shadows = source["shadows"];
    return TextStyle(
      color: _color(source['color']),
      fontSize: _double(source['fontSize']),
      fontWeight: _fontWeight(source['fontWeight']),
      fontStyle: _fontStyle(source['fontStyle']),
      fontFamily: _string(source['fontFamily']),
      letterSpacing: _double(source['letterSpacing']),
      wordSpacing: _double(source['wordSpacing']),
      height: _double(source['height']),
      shadows: shadows is List
          ? shadows.map(_shadow).whereType<Shadow>().toList()
          : null,
      decoration: _textDecoration(source['decoration']),
      decorationColor: _color(source['decorationColor']),
      decorationStyle: _decorationStyle(source['decorationStyle']),
      decorationThickness: _double(source['decorationThickness']),
      overflow: _textOverflow(source['overflow']),
    );
  }

  static BoxShadow? _boxShadow(Object? source) {
    if (source is! Map || source.isEmpty) return null;
    final shadow = _shadow(source);
    if (shadow == null) return null;
    return BoxShadow(
      color: shadow.color,
      offset: shadow.offset,
      blurRadius: shadow.blurRadius,
      spreadRadius: _double(source['spreadRadius']) ?? 0,
      blurStyle: _blurStyle(source['blurStyle']) ?? BlurStyle.normal,
    );
  }

  static GradientTransform? _gradientTransform(Object? source) {
    if (source is! Map || source.isEmpty) return null;
    final type = source["type"];
    switch (type) {
      case "rotation":
        return GradientRotation(_double(source["radians"]) ?? 0);
      default:
        return null;
    }
  }

  static LinearGradient? _gradient(Object? source) {
    if (source is! Map || source.isEmpty) return null;
    final colors = source['colors'];
    final stops = source['stops'];
    final tileMode = source['tileMode'];
    return LinearGradient(
      begin: _alignment(source['begin']) ?? Alignment.centerLeft,
      end: _alignment(source['end']) ?? Alignment.centerRight,
      colors:
          colors is List ? colors.map(_color).whereType<Color>().toList() : [],
      stops:
          stops is List ? stops.map(_double).whereType<double>().toList() : [],
      tileMode: TileMode.values.where((e) {
            if (e.toString() == tileMode.toString()) return true;
            if (e.name == tileMode.toString()) return true;
            return false;
          }).firstOrNull ??
          TileMode.clamp,
      transform: _gradientTransform(source["transform"]),
    );
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
    final boxShadow = source['boxShadow'];
    return InAppPurchasePaywallStyle(
      alignment: _alignment(source['alignment']),
      color: _color(source['color']),
      backgroundColor: _color(source['backgroundColor']),
      blur: _double(source['blur']),
      width: _double(source['width']),
      height: _double(source['height']),
      size: _double(source['size']),
      border: _border(source['border']),
      borderRadius: _borderRadius(source['borderRadius']),
      boxShadow: boxShadow is List
          ? boxShadow.map(_boxShadow).whereType<BoxShadow>().toList()
          : null,
      margin: _edgeInsets(source['margin']),
      maxLines: _int(source['maxLines']),
      padding: _edgeInsets(source['padding']),
      position: _edgeInsets(source['position']),
      gradient: _gradient(source['gradient']),
      textAlign: _textAlign(source['textAlign']),
      textStyle: _textStyle(source['textStyle']),
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

  final String? heroImage;
  final InAppPurchasePaywallStyle? heroImageStyle;
  final String? image;
  final InAppPurchasePaywallStyle? imageStyle;
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
    this.heroImage,
    this.heroImageStyle = const InAppPurchasePaywallStyle(),
    this.image,
    this.imageStyle = const InAppPurchasePaywallStyle(),
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
    final heroImage = parser<String?>(paywall, "heroImage", null);
    final image = parser<String?>(paywall, "image", null);
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
      heroImage: heroImage,
      heroImageStyle:
          InAppPurchasePaywallStyle.parse(paywall["heroImageStyle"]),
      image: image,
      imageStyle: InAppPurchasePaywallStyle.parse(paywall["imageStyle"]),
      headerText: headerText,
      headerStyle: InAppPurchasePaywallStyle.parse(paywall["headerStyle"]),
      bodyText: bodyText,
      bodyStyle: InAppPurchasePaywallStyle.parse(paywall["bodyStyle"]),
      titleText: titleText,
      titleStyle: InAppPurchasePaywallStyle.parse(paywall["titleStyle"]),
      description: description,
      descriptionStyle:
          InAppPurchasePaywallStyle.parse(paywall["descriptionStyle"]),
      features: features,
      featureStyle: InAppPurchasePaywallStyle.parse(paywall["featureStyle"]),
    );
  }
}
