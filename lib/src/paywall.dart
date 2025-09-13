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

class InAppPurchasePaywallState<T> {
  final T primary;
  final T? _secondary;

  T get secondary => _secondary ?? primary;

  T of(bool isSecondary) => isSecondary ? secondary : primary;

  const InAppPurchasePaywallState({
    required this.primary,
    T? secondary,
  }) : _secondary = secondary;

  const InAppPurchasePaywallState.all(T value) : this(primary: value);

  factory InAppPurchasePaywallState.parse(
    Object? source,
    T Function(Object? source) callback,
  ) {
    if (source is! Map || !source.keys.contains("primary")) {
      return InAppPurchasePaywallState.all(callback(source));
    }
    return InAppPurchasePaywallState(
      primary: callback('primary'),
      secondary: callback('secondary'),
    );
  }

  InAppPurchasePaywallState<T> resolveWith(T Function(T value) callback) {
    return InAppPurchasePaywallState(
      primary: callback(primary),
      secondary: callback(secondary),
    );
  }
}

class InAppPurchasePaywallStylePosition {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double? width;
  final double? height;

  const InAppPurchasePaywallStylePosition({
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.width,
    this.height,
  });
}

class InAppPurchasePaywallStyle {
  final InAppPurchasePaywallState<Alignment?> alignment;
  final InAppPurchasePaywallState<double?> duration;
  final InAppPurchasePaywallState<Color?> color;
  final InAppPurchasePaywallState<Color?> backgroundColor;
  final InAppPurchasePaywallState<double?> width;
  final InAppPurchasePaywallState<double?> height;
  final InAppPurchasePaywallState<double?> blur;
  final InAppPurchasePaywallState<Border?> border;
  final InAppPurchasePaywallState<BorderRadius?> borderRadius;
  final InAppPurchasePaywallState<List<BoxShadow>?> boxShadow;
  final InAppPurchasePaywallState<EdgeInsets?> margin;
  final InAppPurchasePaywallState<int?> maxLines;
  final InAppPurchasePaywallState<EdgeInsets?> padding;
  final InAppPurchasePaywallState<InAppPurchasePaywallStylePosition?> position;
  final InAppPurchasePaywallState<LinearGradient?> gradient;
  final InAppPurchasePaywallState<double?> size;
  final InAppPurchasePaywallState<TextAlign?> textAlign;
  final InAppPurchasePaywallState<TextStyle?> textStyle;

  const InAppPurchasePaywallStyle({
    this.alignment = const InAppPurchasePaywallState.all(null),
    this.duration = const InAppPurchasePaywallState.all(null),
    this.color = const InAppPurchasePaywallState.all(null),
    this.backgroundColor = const InAppPurchasePaywallState.all(null),
    this.blur = const InAppPurchasePaywallState.all(null),
    this.width = const InAppPurchasePaywallState.all(null),
    this.height = const InAppPurchasePaywallState.all(null),
    this.size = const InAppPurchasePaywallState.all(null),
    this.border = const InAppPurchasePaywallState.all(null),
    this.borderRadius = const InAppPurchasePaywallState.all(null),
    this.boxShadow = const InAppPurchasePaywallState.all(null),
    this.margin = const InAppPurchasePaywallState.all(null),
    this.maxLines = const InAppPurchasePaywallState.all(null),
    this.padding = const InAppPurchasePaywallState.all(null),
    this.position = const InAppPurchasePaywallState.all(null),
    this.gradient = const InAppPurchasePaywallState.all(null),
    this.textAlign = const InAppPurchasePaywallState.all(null),
    this.textStyle = const InAppPurchasePaywallState.all(null),
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

  static Color? _color(Object? source, bool dark) {
    if (source is Map && source.isNotEmpty) {
      return InAppPurchasePaywallState(
        primary: _color(source['light'], dark),
        secondary: _color(source['dark'], dark),
      ).of(dark);
    }
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

  static Shadow? _shadow(Object? source, bool dark) {
    if (source is! Map || source.isEmpty) return null;
    return Shadow(
      color: _color(source['color'], dark) ?? Colors.transparent,
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

  static TextStyle? _textStyle(Object? source, bool dark) {
    if (source is! Map || source.isEmpty) return null;
    final shadows = source["shadows"];
    return TextStyle(
      color: _color(source['color'], dark),
      fontSize: _double(source['fontSize']),
      fontWeight: _fontWeight(source['fontWeight']),
      fontStyle: _fontStyle(source['fontStyle']),
      fontFamily: _string(source['fontFamily']),
      letterSpacing: _double(source['letterSpacing']),
      wordSpacing: _double(source['wordSpacing']),
      height: _double(source['height']),
      shadows: shadows is List
          ? shadows.map((e) => _shadow(e, dark)).whereType<Shadow>().toList()
          : null,
      decoration: _textDecoration(source['decoration']),
      decorationColor: _color(source['decorationColor'], dark),
      decorationStyle: _decorationStyle(source['decorationStyle']),
      decorationThickness: _double(source['decorationThickness']),
      overflow: _textOverflow(source['overflow']),
    );
  }

  static BoxShadow? _boxShadow(Object? source, bool dark) {
    if (source is! Map || source.isEmpty) return null;
    final shadow = _shadow(source, dark);
    if (shadow == null) return null;
    return BoxShadow(
      color: shadow.color,
      offset: shadow.offset,
      blurRadius: shadow.blurRadius,
      spreadRadius: _double(source['spreadRadius']) ?? 0,
      blurStyle: _blurStyle(source['blurStyle']) ?? BlurStyle.normal,
    );
  }

  static List<T>? _list<T>(
      Object? source, T? Function(Object? value) callback) {
    if (source is! List || source.isEmpty) return null;
    return source.map(callback).whereType<T>().toList();
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

  static LinearGradient? _gradient(Object? source, bool dark) {
    if (source is! Map || source.isEmpty) return null;
    final colors = source['colors'];
    final stops = source['stops'];
    final tileMode = source['tileMode'];
    return LinearGradient(
      begin: _alignment(source['begin']) ?? Alignment.centerLeft,
      end: _alignment(source['end']) ?? Alignment.centerRight,
      colors: colors is List
          ? colors.map((e) => _color(e, dark)).whereType<Color>().toList()
          : [],
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

  static BorderSide _borderSide(Object? source, bool dark) {
    if (source is! Map || source.isEmpty) return BorderSide.none;
    final color = _color(source['color'], dark);
    final width = source['width'];
    if (color == null) return BorderSide.none;
    return BorderSide(color: color, width: width is num ? width.toDouble() : 0);
  }

  static Border? _border(Object? source, bool dark) {
    if (source is! Map || source.isEmpty) return null;
    return Border(
      top: _borderSide(source["top"], dark),
      bottom: _borderSide(source["bottom"], dark),
      left: _borderSide(source["left"], dark),
      right: _borderSide(source["right"], dark),
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

  static InAppPurchasePaywallStylePosition? _position(Object? source) {
    if (source is! Map || source.isEmpty) return null;
    return InAppPurchasePaywallStylePosition(
      left: _double(source['left']),
      right: _double(source['right']),
      top: _double(source['top']),
      bottom: _double(source['bottom']),
      width: _double(source['width']),
      height: _double(source['height']),
    );
  }

  factory InAppPurchasePaywallStyle.parse(Object? source, bool dark) {
    if (source is! Map) return InAppPurchasePaywallStyle();
    return InAppPurchasePaywallStyle(
      alignment: InAppPurchasePaywallState.parse(
        source['alignment'],
        _alignment,
      ),
      color: InAppPurchasePaywallState.parse(
        source['color'],
        (value) => _color(value, dark),
      ),
      backgroundColor: InAppPurchasePaywallState.parse(
        source['backgroundColor'],
        (value) => _color(value, dark),
      ),
      blur: InAppPurchasePaywallState.parse(
        source['blur'],
        _double,
      ),
      width: InAppPurchasePaywallState.parse(
        source['width'],
        _double,
      ),
      height: InAppPurchasePaywallState.parse(
        source['height'],
        _double,
      ),
      size: InAppPurchasePaywallState.parse(
        source['size'],
        _double,
      ),
      border: InAppPurchasePaywallState.parse(
        source['border'],
        (value) => _border(value, dark),
      ),
      borderRadius: InAppPurchasePaywallState.parse(
        source['borderRadius'],
        _borderRadius,
      ),
      boxShadow: InAppPurchasePaywallState.parse(source['boxShadow'], (v) {
        return _list(v, (e) => _boxShadow(e, dark));
      }),
      margin: InAppPurchasePaywallState.parse(
        source['margin'],
        _edgeInsets,
      ),
      maxLines: InAppPurchasePaywallState.parse(
        source['maxLines'],
        _int,
      ),
      padding: InAppPurchasePaywallState.parse(
        source['padding'],
        _edgeInsets,
      ),
      position: InAppPurchasePaywallState.parse(
        source['position'],
        _position,
      ),
      gradient: InAppPurchasePaywallState.parse(
        source['gradient'],
        (value) => _gradient(value, dark),
      ),
      textAlign: InAppPurchasePaywallState.parse(
        source['textAlign'],
        _textAlign,
      ),
      textStyle: InAppPurchasePaywallState.parse(
        source['textStyle'],
        (value) => _textStyle(value, dark),
      ),
    );
  }
}

class InAppPurchasePaywallProduct {
  final bool selected;
  final InAppPurchaseProduct product;
  final InAppPurchasePaywallState<double?>? _price;
  final InAppPurchasePaywallState<String?>? _period;
  final InAppPurchasePaywallState<int?>? _unit;

  final InAppPurchasePaywallState<String?>? _titleText;
  final InAppPurchasePaywallStyle titleStyle;
  final InAppPurchasePaywallState<String?>? _descriptionText;
  final InAppPurchasePaywallStyle descriptionStyle;

  final InAppPurchasePaywallState<String?>? _leftTopText;
  final InAppPurchasePaywallStyle leftTopStyle;
  final InAppPurchasePaywallState<String?>? _leftMiddleText;
  final InAppPurchasePaywallStyle leftMiddleStyle;
  final InAppPurchasePaywallState<String?>? _leftBottomText;
  final InAppPurchasePaywallStyle leftBottomStyle;
  final InAppPurchasePaywallState<String?>? _rightTopText;
  final InAppPurchasePaywallStyle rightTopStyle;
  final InAppPurchasePaywallState<String?>? _rightMiddleText;
  final InAppPurchasePaywallStyle rightMiddleStyle;
  final InAppPurchasePaywallState<String?>? _rightBottomText;
  final InAppPurchasePaywallStyle rightBottomStyle;
  final InAppPurchasePaywallState<String?>? _badgeText;
  final InAppPurchasePaywallStyle badgeStyle;
  final InAppPurchasePaywallState<String?>? _buttonText;
  final InAppPurchasePaywallStyle buttonStyle;
  final InAppPurchasePaywallState<String?>? _bottomText;
  final InAppPurchasePaywallStyle bottomStyle;

  double? get price => priceState.of(selected);

  double? get priceOriginal => product.price;

  String? get currency => product.currency;

  String? get currencySign => product.currencySign;

  InAppPurchasePaywallState<double?> get priceState {
    return _price ?? InAppPurchasePaywallState.all(null);
  }

  String? get period => periodState.of(selected);

  InAppPurchasePaywallState<String?> get periodState {
    return _period ?? InAppPurchasePaywallState.all(null);
  }

  int? get unit => unitState.of(selected);

  InAppPurchasePaywallState<int?> get unitState {
    return _unit ?? InAppPurchasePaywallState.all(null);
  }

  String? get titleText => titleTextState.of(selected);

  InAppPurchasePaywallState<String?> get titleTextState {
    return _titleText?.resolveWith(stringify) ??
        InAppPurchasePaywallState.all(null);
  }

  String? get descriptionText => descriptionTextState.of(selected);

  InAppPurchasePaywallState<String?> get descriptionTextState {
    return _descriptionText?.resolveWith(stringify) ??
        InAppPurchasePaywallState.all(null);
  }

  String? get leftTopText => leftTopTextState.of(selected);

  InAppPurchasePaywallState<String?> get leftTopTextState {
    return _leftTopText?.resolveWith(stringify) ??
        InAppPurchasePaywallState.all(null);
  }

  String? get leftMiddleText => leftMiddleTextState.of(selected);

  InAppPurchasePaywallState<String?> get leftMiddleTextState {
    return _leftMiddleText?.resolveWith(stringify) ??
        InAppPurchasePaywallState.all(null);
  }

  String? get leftBottomText => leftBottomTextState.of(selected);

  InAppPurchasePaywallState<String?> get leftBottomTextState {
    return _leftBottomText?.resolveWith(stringify) ??
        InAppPurchasePaywallState.all(null);
  }

  String? get rightTopText => rightTopTextState.of(selected);

  InAppPurchasePaywallState<String?> get rightTopTextState {
    return _rightTopText?.resolveWith(stringify) ??
        InAppPurchasePaywallState.all(null);
  }

  String? get rightMiddleText => rightMiddleTextState.of(selected);

  InAppPurchasePaywallState<String?> get rightMiddleTextState {
    return _rightMiddleText?.resolveWith(stringify) ??
        InAppPurchasePaywallState.all(null);
  }

  String? get rightBottomText => rightBottomTextState.of(selected);

  InAppPurchasePaywallState<String?> get rightBottomTextState {
    return _rightBottomText?.resolveWith(stringify) ??
        InAppPurchasePaywallState.all(null);
  }

  String? get badgeText => badgeTextState.of(selected);

  InAppPurchasePaywallState<String?> get badgeTextState {
    return _badgeText ?? InAppPurchasePaywallState.all(null);
  }

  String? get buttonText => badgeTextState.of(selected);

  InAppPurchasePaywallState<String?> get buttonTextState {
    return _buttonText?.resolveWith(stringify) ??
        InAppPurchasePaywallState.all(null);
  }

  String? get bottomText => bottomTextState.of(selected);

  InAppPurchasePaywallState<String?> get bottomTextState {
    return _bottomText?.resolveWith(stringify) ??
        InAppPurchasePaywallState.all(null);
  }

  String stringify(String? value) {
    if (value == null || value.isEmpty) return '';
    final period = this.period ?? 'mo';
    final unit = this.unit ?? 1;
    final currency = this.currency ?? "USD";
    final currencySign = this.currencySign ?? "\$";
    final discountPrice = priceOriginal ?? 0;
    final price = this.price ?? discountPrice;
    final formatedPrice = discountPrice / unit;
    return value
        .replaceAll(
          InAppPurchasePaywallConfigFormatters.currencySign,
          currencySign,
        )
        .replaceAll(
          InAppPurchasePaywallConfigFormatters.currencyName,
          currency,
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
    this.selected = false,
    InAppPurchasePaywallState<double?>? price,
    InAppPurchasePaywallState<int?>? unit,
    InAppPurchasePaywallState<String?>? period,
    InAppPurchasePaywallState<String?>? titleText,
    InAppPurchasePaywallState<String?>? descriptionText,
    InAppPurchasePaywallState<String?>? leftTopText,
    InAppPurchasePaywallState<String?>? leftMiddleText,
    InAppPurchasePaywallState<String?>? leftBottomText,
    InAppPurchasePaywallState<String?>? rightTopText,
    InAppPurchasePaywallState<String?>? rightMiddleText,
    InAppPurchasePaywallState<String?>? rightBottomText,
    InAppPurchasePaywallState<String?>? badgeText,
    InAppPurchasePaywallState<String?>? buttonText,
    InAppPurchasePaywallState<String?>? bottomText,
    this.leftTopStyle = const InAppPurchasePaywallStyle(),
    this.leftMiddleStyle = const InAppPurchasePaywallStyle(),
    this.leftBottomStyle = const InAppPurchasePaywallStyle(),
    this.rightTopStyle = const InAppPurchasePaywallStyle(),
    this.rightMiddleStyle = const InAppPurchasePaywallStyle(),
    this.rightBottomStyle = const InAppPurchasePaywallStyle(),
    this.badgeStyle = const InAppPurchasePaywallStyle(),
    this.buttonStyle = const InAppPurchasePaywallStyle(),
    this.bottomStyle = const InAppPurchasePaywallStyle(),
    this.titleStyle = const InAppPurchasePaywallStyle(),
    this.descriptionStyle = const InAppPurchasePaywallStyle(),
  })  : _price = price,
        _period = period,
        _unit = unit,
        _titleText = titleText,
        _descriptionText = descriptionText,
        _leftTopText = leftTopText,
        _leftMiddleText = leftMiddleText,
        _leftBottomText = leftBottomText,
        _rightTopText = rightTopText,
        _rightMiddleText = rightMiddleText,
        _rightBottomText = rightBottomText,
        _badgeText = badgeText,
        _buttonText = buttonText,
        _bottomText = bottomText;

  factory InAppPurchasePaywallProduct.fromConfigs({
    required InAppPurchaseProduct product,
    required Map configs,
    required int index,
    required bool dark,
  }) {
    final parser = InAppPurchaser.parseConfig;
    return InAppPurchasePaywallProduct(
      product: product,
      selected: parser(configs['selected'], false),
      period: InAppPurchasePaywallState.parse(
        configs['periods'],
        (v) => parser(v, <String>[]).elementAtOrNull(index),
      ),
      price: InAppPurchasePaywallState.parse(
        configs['prices'],
        (v) => parser(v, <double>[]).elementAtOrNull(index),
      ),
      unit: InAppPurchasePaywallState.parse(
        configs['units'],
        (v) => parser(v, <int>[]).elementAtOrNull(index),
      ),
      leftTopText: InAppPurchasePaywallState.parse(
        configs['leftTopTexts'],
        (v) => parser(v, <String>[]).elementAtOrNull(index),
      ),
      leftTopStyle: InAppPurchasePaywallStyle.parse(
        configs["leftTopStyle"],
        dark,
      ),
      leftBottomText: InAppPurchasePaywallState.parse(
        configs['leftBottomTexts'],
        (v) => parser(v, <String>[]).elementAtOrNull(index),
      ),
      leftBottomStyle: InAppPurchasePaywallStyle.parse(
        configs["leftBottomStyle"],
        dark,
      ),
      rightTopText: InAppPurchasePaywallState.parse(
        configs['rightTopTexts'],
        (v) => parser(v, <String>[]).elementAtOrNull(index),
      ),
      rightTopStyle: InAppPurchasePaywallStyle.parse(
        configs["rightTopStyle"],
        dark,
      ),
      rightBottomText: InAppPurchasePaywallState.parse(
        configs['rightBottomTexts'],
        (v) => parser(v, <String>[]).elementAtOrNull(index),
      ),
      rightBottomStyle: InAppPurchasePaywallStyle.parse(
        configs["rightBottomStyle"],
        dark,
      ),
      badgeText: InAppPurchasePaywallState.parse(
        configs['badgeTexts'],
        (v) => parser(v, <String>[]).elementAtOrNull(index),
      ),
      badgeStyle: InAppPurchasePaywallStyle.parse(
        configs["badgeStyle"],
        dark,
      ),
      buttonText: InAppPurchasePaywallState.parse(
        configs['buttonTexts'],
        (v) => parser(v, <String>[]).elementAtOrNull(index),
      ),
      buttonStyle: InAppPurchasePaywallStyle.parse(
        configs["buttonStyle"],
        dark,
      ),
      bottomText: InAppPurchasePaywallState.parse(
        configs['bottomTexts'],
        (v) => parser(v, <String>[]).elementAtOrNull(index),
      ),
      bottomStyle: InAppPurchasePaywallStyle.parse(
        configs["bottomStyle"],
        dark,
      ),
      titleText: InAppPurchasePaywallState.parse(
        configs['titleTexts'],
        (v) => parser(v, <String>[]).elementAtOrNull(index),
      ),
      titleStyle: InAppPurchasePaywallStyle.parse(
        configs["titleStyle"],
        dark,
      ),
      descriptionText: InAppPurchasePaywallState.parse(
        configs['descriptionTexts'],
        (v) => parser(v, <String>[]).elementAtOrNull(index),
      ),
      descriptionStyle: InAppPurchasePaywallStyle.parse(
        configs["descriptionStyle"],
        dark,
      ),
    );
  }

  InAppPurchasePaywallProduct select(bool selected) {
    return InAppPurchasePaywallProduct(
      selected: selected,
      product: product,
      badgeStyle: badgeStyle,
      badgeText: _badgeText,
      bottomStyle: bottomStyle,
      bottomText: _bottomText,
      buttonStyle: buttonStyle,
      buttonText: _buttonText,
      descriptionStyle: descriptionStyle,
      descriptionText: _descriptionText,
      leftBottomStyle: leftBottomStyle,
      leftBottomText: _leftBottomText,
      leftMiddleStyle: leftMiddleStyle,
      leftMiddleText: _leftMiddleText,
      leftTopStyle: leftTopStyle,
      leftTopText: _leftTopText,
      period: _period,
      price: _price,
      rightBottomStyle: rightBottomStyle,
      rightBottomText: _rightBottomText,
      rightMiddleStyle: rightMiddleStyle,
      rightMiddleText: _rightMiddleText,
      rightTopStyle: rightTopStyle,
      rightTopText: _rightTopText,
      titleStyle: titleStyle,
      titleText: _titleText,
      unit: _unit,
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
  final InAppPurchasePaywallStyle heroImageStyle;
  final String? image;
  final InAppPurchasePaywallStyle imageStyle;
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

  factory InAppPurchasePaywall.fromOffering(
    InAppPurchaseOffering offering,
    bool dark,
  ) {
    final parser = InAppPurchaser.parseConfig;
    final configs = offering.configs;
    final paywall = configs["paywall"];
    final product = configs["product"];

    final hasSkip = parser(paywall["skippable"], false);
    final designType = parser(paywall["designType"], "v1");
    final heroImage = parser<String?>(paywall["heroImage"], null);
    final image = parser<String?>(paywall["image"], null);
    final headerText = parser<String?>(paywall["headerText"], null);
    final bodyText = parser<String?>(paywall["bodyText"], null);
    final titleText = parser<String?>(paywall["titleText"], null);
    final description = parser<String?>(paywall["descriptionText"], null);
    final features = parser(paywall["features"], []);

    final products = List.generate(offering.products.length, (index) {
      return InAppPurchasePaywallProduct.fromConfigs(
        product: offering.products[index],
        configs: product is Map ? product : {},
        index: index,
        dark: dark,
      );
    });

    return InAppPurchasePaywall(
      id: offering.id,
      products: products,
      designType: designType,
      skipMode: hasSkip,
      heroImage: heroImage,
      heroImageStyle: InAppPurchasePaywallStyle.parse(
        paywall["heroImageStyle"],
        dark,
      ),
      image: image,
      imageStyle: InAppPurchasePaywallStyle.parse(
        paywall["imageStyle"],
        dark,
      ),
      headerText: headerText,
      headerStyle: InAppPurchasePaywallStyle.parse(
        paywall["headerStyle"],
        dark,
      ),
      bodyText: bodyText,
      bodyStyle: InAppPurchasePaywallStyle.parse(
        paywall["bodyStyle"],
        dark,
      ),
      titleText: titleText,
      titleStyle: InAppPurchasePaywallStyle.parse(
        paywall["titleStyle"],
        dark,
      ),
      description: description,
      descriptionStyle: InAppPurchasePaywallStyle.parse(
        paywall["descriptionStyle"],
        dark,
      ),
      features: features,
      featureStyle: InAppPurchasePaywallStyle.parse(
        paywall["featureStyle"],
        dark,
      ),
    );
  }
}
