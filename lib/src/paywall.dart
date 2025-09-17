import 'package:flutter/material.dart';

import 'offering.dart';
import 'purchaser.dart';

typedef InAppPurchasePaywallScaler = double Function(double value);

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
    if (source is! Map ||
        !source.keys.contains("primary") ||
        !source.keys.contains("secondary")) {
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

  Object? toDictionary(Object? Function(T? value) callback,
      [bool filter = true]) {
    if (_secondary == null) return callback(primary);
    final entries = {
      "primary": callback(primary),
      "secondary": callback(_secondary),
    }.entries.where((e) => e.value != null);
    if (entries.isEmpty) return null;
    return Map.fromEntries(entries);
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

  InAppPurchasePaywallStylePosition copyWith({
    double? width,
    double? height,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return InAppPurchasePaywallStylePosition(
      width: width ?? this.width,
      height: height ?? this.height,
      left: left ?? this.left,
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
    );
  }

  InAppPurchasePaywallStylePosition resolveWith({
    InAppPurchasePaywallScaler? scaler,
    TextDirection? textDirection,
  }) {
    double? dp(double? value) {
      if (value == null) return null;
      if (scaler == null) return value;
      return scaler(value);
    }

    double? td(double? a, double? b) {
      if (textDirection == null) return a;
      return textDirection == TextDirection.rtl ? b : a;
    }

    return copyWith(
      top: dp(top),
      bottom: dp(bottom),
      left: dp(td(left, right)),
      right: dp(td(right, left)),
      width: dp(width),
      height: dp(height),
    );
  }

  Map<String, double>? get dictionary {
    final map = {
      if (width != null) "width": width!,
      if (height != null) "height": height!,
      if (top != null) "top": top!,
      if (bottom != null) "bottom": bottom!,
      if (left != null) "left": left!,
      if (right != null) "right": right!,
    };
    return map.isEmpty ? null : map;
  }
}

class InAppPurchasePaywallStyle {
  final bool selected;
  final InAppPurchasePaywallState<Alignment?> alignmentState;
  final InAppPurchasePaywallState<Color?> backgroundColorState;
  final InAppPurchasePaywallState<BlendMode?> blendModeState;
  final InAppPurchasePaywallState<double?> blurState;
  final InAppPurchasePaywallState<Border?> borderState;
  final InAppPurchasePaywallState<BorderRadius?> borderRadiusState;
  final InAppPurchasePaywallState<List<BoxShadow>?> boxShadowState;
  final InAppPurchasePaywallState<Color?> colorState;
  final InAppPurchasePaywallState<Alignment?> contentAlignmentState;
  final InAppPurchasePaywallState<int?> durationState;
  final InAppPurchasePaywallState<int?> flexState;
  final InAppPurchasePaywallState<LinearGradient?> gradientState;
  final InAppPurchasePaywallState<double?> heightState;
  final InAppPurchasePaywallState<String?> imageState;
  final InAppPurchasePaywallState<double?> imageOpacityState;
  final InAppPurchasePaywallState<double?> imageScaleState;
  final InAppPurchasePaywallState<EdgeInsets?> marginState;
  final InAppPurchasePaywallState<int?> maxLinesState;
  final InAppPurchasePaywallState<double?> opacityState;
  final InAppPurchasePaywallState<EdgeInsets?> paddingState;
  final InAppPurchasePaywallState<InAppPurchasePaywallStylePosition?>
      positionState;
  final InAppPurchasePaywallState<double?> scaleState;
  final InAppPurchasePaywallState<double?> sizeState;
  final InAppPurchasePaywallState<TextAlign?> textAlignState;
  final InAppPurchasePaywallState<TextStyle?> textStyleState;
  final InAppPurchasePaywallState<double?> widthState;

  Alignment? get alignment => alignmentState.of(selected);

  Color? get backgroundColor => backgroundColorState.of(selected);

  BlendMode? get blendMode => blendModeState.of(selected);

  double? get blur => blurState.of(selected);

  Border? get border => borderState.of(selected);

  BorderRadius? get borderRadius => borderRadiusState.of(selected);

  List<BoxShadow>? get boxShadow => boxShadowState.of(selected);

  Color? get color => colorState.of(selected);

  Alignment? get contentAlignment => contentAlignmentState.of(selected);

  int? get duration => durationState.of(selected);

  int? get flex => flexState.of(selected);

  LinearGradient? get gradient => gradientState.of(selected);

  double? get height => heightState.of(selected);

  String? get image => imageState.of(selected);

  double? get imageOpacity => imageOpacityState.of(selected);

  double? get imageScale => imageScaleState.of(selected);

  EdgeInsets? get margin => marginState.of(selected);

  int? get maxLines => maxLinesState.of(selected);

  double? get opacity => opacityState.of(selected);

  EdgeInsets? get padding => paddingState.of(selected);

  InAppPurchasePaywallStylePosition? get position => positionState.of(selected);

  double? get scale => scaleState.of(selected);

  double? get size => sizeState.of(selected);

  TextAlign? get textAlign => textAlignState.of(selected);

  TextStyle? get textStyle => textStyleState.of(selected);

  double? get width => widthState.of(selected);

  const InAppPurchasePaywallStyle({
    this.selected = false,
    this.alignmentState = const InAppPurchasePaywallState.all(null),
    this.backgroundColorState = const InAppPurchasePaywallState.all(null),
    this.blendModeState = const InAppPurchasePaywallState.all(null),
    this.blurState = const InAppPurchasePaywallState.all(null),
    this.borderState = const InAppPurchasePaywallState.all(null),
    this.borderRadiusState = const InAppPurchasePaywallState.all(null),
    this.boxShadowState = const InAppPurchasePaywallState.all(null),
    this.colorState = const InAppPurchasePaywallState.all(null),
    this.contentAlignmentState = const InAppPurchasePaywallState.all(null),
    this.durationState = const InAppPurchasePaywallState.all(null),
    this.flexState = const InAppPurchasePaywallState.all(null),
    this.gradientState = const InAppPurchasePaywallState.all(null),
    this.heightState = const InAppPurchasePaywallState.all(null),
    this.imageState = const InAppPurchasePaywallState.all(null),
    this.imageOpacityState = const InAppPurchasePaywallState.all(null),
    this.imageScaleState = const InAppPurchasePaywallState.all(null),
    this.marginState = const InAppPurchasePaywallState.all(null),
    this.maxLinesState = const InAppPurchasePaywallState.all(null),
    this.opacityState = const InAppPurchasePaywallState.all(null),
    this.paddingState = const InAppPurchasePaywallState.all(null),
    this.positionState = const InAppPurchasePaywallState.all(null),
    this.scaleState = const InAppPurchasePaywallState.all(null),
    this.sizeState = const InAppPurchasePaywallState.all(null),
    this.textAlignState = const InAppPurchasePaywallState.all(null),
    this.textStyleState = const InAppPurchasePaywallState.all(null),
    this.widthState = const InAppPurchasePaywallState.all(null),
  });

  static T? parseEnum<T extends Enum>(Object? source, Iterable<T> enums) {
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

  static FontWeight? parserFontWeight(Object? source) {
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

  static Alignment? parseAlignment(Object? source) {
    if (source is! Map || source.isEmpty) return null;
    return Alignment(
      parseDouble(source['x']) ?? 0,
      parseDouble(source['y']) ?? 0,
    );
  }

  static Object? _safeEncodableDouble(double? value) {
    if (value == null) return null;
    return value.isInfinite
        ? 'infinity'
        : value.isNaN
            ? 'nan'
            : value;
  }

  static double? parseDouble(Object? source) {
    if (source is num) return source.toDouble();
    if (source is! String) return null;
    if (source.contains('infinity')) return double.infinity;
    if (source.contains('nan')) return double.nan;
    return null;
  }

  static int? parseInt(Object? source) {
    return source is num ? source.toInt() : null;
  }

  static bool? parseBool(Object? source) {
    return source is bool ? source : null;
  }

  static String? parseString(Object? source) {
    return source is String && source.isNotEmpty ? source : null;
  }

  static String? colorToHex(Color? color, {bool withHash = true}) {
    if (color == null) return null;
    final hex = color.toARGB32().toRadixString(16).padLeft(8, '0');
    return withHash ? '#$hex' : '0x$hex';
  }

  static Color? parseColor(String source) {
    source = source.toLowerCase();
    if (source.startsWith('#') || source.startsWith("0x")) {
      source = source.replaceAll('#', '').replaceAll('0x', '');
      if (source.length == 6) source = "ff$source";
      if (source.length != 8) return null;
      final code = int.tryParse('0x$source');
      if (code == null) return null;
      return Color(code);
    }
    return {
      "amber": Colors.amber,
      "black": Colors.black,
      "blue": Colors.blue,
      "brown": Colors.brown,
      "cyan": Colors.cyan,
      "grey": Colors.grey,
      "green": Colors.green,
      "indigo": Colors.indigo,
      "lime": Colors.lime,
      "orange": Colors.orange,
      "pink": Colors.pink,
      "purple": Colors.purple,
      "red": Colors.red,
      "teal": Colors.teal,
      "transparent": Colors.transparent,
      "none": Colors.transparent,
      "white": Colors.white,
      "yellow": Colors.yellow,
    }[source];
  }

  static Color? _parseColor(Object? source, bool dark) {
    if (source is Map && source.isNotEmpty) {
      return InAppPurchasePaywallState(
        primary: parseColor(source['primary']),
        secondary: parseColor(source['secondary']),
      ).of(dark);
    }
    if (source is! String || source.isEmpty) return null;
    return parseColor(source);
  }

  static BlendMode? parseBlendMode(Object? source) {
    return parseEnum(source, BlendMode.values);
  }

  static FontStyle? parseFontStyle(Object? source) {
    return parseEnum(source, FontStyle.values);
  }

  static Offset? parseOffset(Object? source) {
    if (source is! Map || source.isEmpty) return null;
    return Offset(
      parseDouble(source['dx']) ?? 0,
      parseDouble(source['dy']) ?? 0,
    );
  }

  static Shadow? parseShadow(Object? source, bool dark) {
    if (source is! Map || source.isEmpty) return null;
    return Shadow(
      color: _parseColor(source['color'], dark) ?? Colors.transparent,
      offset: parseOffset(source['offset']) ?? Offset.zero,
      blurRadius: parseDouble(source['blurRadius']) ?? 0,
    );
  }

  static BlurStyle? parseBlurStyle(Object? source) {
    return parseEnum(source, BlurStyle.values);
  }

  static TextDecoration? parseTextDecoration(Object? source) {
    if (source is! String || source.isEmpty) return null;
    final key = source.toString();
    if (key.startsWith("TextDecoration.lineThrough") || key == "lineThrough") {
      return TextDecoration.lineThrough;
    }
    if (key.startsWith("TextDecoration.overline") || key == "overline") {
      return TextDecoration.overline;
    }
    if (key.startsWith("TextDecoration.underline") || key == "underline") {
      return TextDecoration.underline;
    }
    if (key.startsWith("TextDecoration.combine")) {
      try {
        final start = key.indexOf('[');
        final end = key.lastIndexOf(']');
        final parts = key
            .substring(start, end + 1)
            .split(", ")
            .where((e) => e.isNotEmpty);
        return TextDecoration.combine(
          parts.map(parseTextDecoration).whereType<TextDecoration>().toList(),
        );
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static TextDecorationStyle? parseDecorationStyle(Object? source) {
    return parseEnum(source, TextDecorationStyle.values);
  }

  static TextAlign? parseTextAlign(Object? source) {
    return parseEnum(source, TextAlign.values);
  }

  static Locale? parseLocale(Object? source) {
    if (source is! String) return null;
    final parts = source.replaceAll("-", "_").split("_");
    return parts.length == 1
        ? Locale(parts.first)
        : parts.length == 2
            ? Locale(parts.first, parts.last)
            : null;
  }

  static TextStyle? parseTextStyle(Object? source, bool dark) {
    if (source is! Map || source.isEmpty) return null;
    final shadows = source["shadows"];
    final fontFamilyFallback = source["fontFamilyFallback"];
    return TextStyle(
      backgroundColor: _parseColor(source['backgroundColor'], dark),
      debugLabel: parseString(source['debugLabel']),
      fontFamilyFallback: fontFamilyFallback is List
          ? fontFamilyFallback.map(parseString).whereType<String>().toList()
          : null,
      inherit: parseBool(source['inherit']) ?? true,
      leadingDistribution: parseEnum(
        source['leadingDistribution'],
        TextLeadingDistribution.values,
      ),
      locale: parseLocale(source['locale']),
      package: parseString(source['package']),
      textBaseline: parseEnum(source['textBaseline'], TextBaseline.values),
      color: _parseColor(source['color'], dark),
      fontSize: parseDouble(source['fontSize']),
      fontWeight: parserFontWeight(source['fontWeight']),
      fontStyle: parseFontStyle(source['fontStyle']),
      fontFamily: parseString(source['fontFamily']),
      letterSpacing: parseDouble(source['letterSpacing']),
      wordSpacing: parseDouble(source['wordSpacing']),
      height: parseDouble(source['height']),
      shadows: shadows is List
          ? shadows
              .map((e) => parseShadow(e, dark))
              .whereType<Shadow>()
              .toList()
          : null,
      decoration: parseTextDecoration(source['decoration']),
      decorationColor: _parseColor(source['decorationColor'], dark),
      decorationStyle: parseDecorationStyle(source['decorationStyle']),
      decorationThickness: parseDouble(source['decorationThickness']),
      overflow: parseEnum(source['overflow'], TextOverflow.values),
    );
  }

  static BoxShadow? parseBoxShadow(Object? source, bool dark) {
    if (source is! Map || source.isEmpty) return null;
    final shadow = parseShadow(source, dark);
    if (shadow == null) return null;
    return BoxShadow(
      color: shadow.color,
      offset: shadow.offset,
      blurRadius: shadow.blurRadius,
      spreadRadius: parseDouble(source['spreadRadius']) ?? 0,
      blurStyle: parseBlurStyle(source['blurStyle']) ?? BlurStyle.normal,
    );
  }

  static List<T>? parseList<T>(
    Object? source,
    T? Function(Object? value) callback,
  ) {
    if (source is! List || source.isEmpty) return null;
    return source.map(callback).whereType<T>().toList();
  }

  static GradientTransform? parseGradientTransform(Object? source) {
    if (source is! Map || source.isEmpty) return null;
    final type = source["type"];
    switch (type) {
      case "rotation":
        return GradientRotation(parseDouble(source["radians"]) ?? 0);
      default:
        return null;
    }
  }

  static LinearGradient? parseGradient(Object? source, bool dark) {
    if (source is! Map || source.isEmpty) return null;
    final colors = source['colors'];
    final mColors = colors is List
        ? colors.map((e) => _parseColor(e, dark)).whereType<Color>().toList()
        : <Color>[];
    if (mColors.length < 2) return null;
    final stops = source['stops'];
    final tileMode = source['tileMode'];
    return LinearGradient(
      begin: parseAlignment(source['begin']) ?? Alignment.centerLeft,
      end: parseAlignment(source['end']) ?? Alignment.centerRight,
      colors: mColors,
      stops: stops is List
          ? stops.map(parseDouble).whereType<double>().toList()
          : [],
      tileMode: TileMode.values.where((e) {
            if (e.toString() == tileMode.toString()) return true;
            if (e.name == tileMode.toString()) return true;
            return false;
          }).firstOrNull ??
          TileMode.clamp,
      transform: parseGradientTransform(source["transform"]),
    );
  }

  static BorderSide parseBorderSide(Object? source, bool dark) {
    if (source is! Map || source.isEmpty) return BorderSide.none;
    final color = _parseColor(source['color'], dark);
    final width = parseDouble(source['width']) ?? 0;
    if (color == null || width <= 0) return BorderSide.none;
    return BorderSide(color: color, width: width);
  }

  static Border? parseBorder(Object? source, bool dark) {
    if (source is! Map || source.isEmpty) return null;
    return Border(
      top: parseBorderSide(source["top"], dark),
      bottom: parseBorderSide(source["bottom"], dark),
      left: parseBorderSide(source["left"], dark),
      right: parseBorderSide(source["right"], dark),
    );
  }

  static BorderRadius? parseBorderRadius(Object? source) {
    if (source is! Map || source.isEmpty) return null;
    return BorderRadius.only(
      bottomLeft: Radius.circular(parseDouble(source['bottomLeft']) ?? 0),
      bottomRight: Radius.circular(parseDouble(source['bottomRight']) ?? 0),
      topLeft: Radius.circular(parseDouble(source['topLeft']) ?? 0),
      topRight: Radius.circular(parseDouble(source['topRight']) ?? 0),
    );
  }

  static EdgeInsets? parseEdgeInsets(Object? source) {
    if (source is! Map || source.isEmpty) return null;
    return EdgeInsets.only(
      left: parseDouble(source['left']) ?? 0,
      right: parseDouble(source['right']) ?? 0,
      top: parseDouble(source['top']) ?? 0,
      bottom: parseDouble(source['bottom']) ?? 0,
    );
  }

  static InAppPurchasePaywallStylePosition? parsePosition(Object? source) {
    if (source is! Map || source.isEmpty) return null;
    return InAppPurchasePaywallStylePosition(
      left: parseDouble(source['left']),
      right: parseDouble(source['right']),
      top: parseDouble(source['top']),
      bottom: parseDouble(source['bottom']),
      width: parseDouble(source['width']),
      height: parseDouble(source['height']),
    );
  }

  Map<String, dynamic> get dictionary {
    final entries = {
      "alignment": alignmentState.toDictionary((e) {
        if (e == null) return null;
        return {"x": e.x, "y": e.y};
      }),
      "backgroundColor": backgroundColorState.toDictionary(colorToHex),
      "blendMode": blendModeState.toDictionary((e) => e?.name),
      "blur": blurState.toDictionary((e) => e),
      "border": borderState.toDictionary((e) {
        if (e == null) return null;
        Object? convert(BorderSide value) {
          final b = value;
          if (b == BorderSide.none) return null;
          return {
            "color": colorToHex(b.color),
            "width": b.width,
            "style": b.style.name,
            "strokeAlign": b.strokeAlign,
          };
        }

        final x = {
          "left": e.left,
          "right": e.right,
          "top": e.top,
          "bottom": e.bottom
        }.map((key, value) {
          return MapEntry(key, convert(value));
        })
          ..removeWhere((k, value) {
            return value == null;
          });
        if (x.isEmpty) return null;
        return x;
      }),
      "borderRadius": borderRadiusState.toDictionary((e) {
        if (e == null) return null;
        double? convert(Radius e) {
          if (e == Radius.zero) return null;
          return (e.x + e.y) / 2;
        }

        final x = {
          "topLeft": convert(e.topLeft),
          "topRight": convert(e.topRight),
          "bottomLeft": convert(e.bottomLeft),
          "bottomRight": convert(e.bottomRight)
        }..removeWhere((k, value) {
            return value == null;
          });
        if (x.isEmpty) return null;
        return x;
      }),
      "boxShadow": boxShadowState.toDictionary((e) {
        if (e == null || e.isEmpty) return null;
        return e.map((bs) {
          {
            return {
              "color": colorToHex(bs.color),
              "offset": {"dx": bs.offset.dx, "dy": bs.offset.dy},
              "blurRadius": bs.blurRadius,
              "blurStyle": bs.blurStyle.name,
              "spreadRadius": bs.spreadRadius,
            };
          }
        }).toList();
      }),
      "color": colorState.toDictionary(colorToHex),
      "contentAlignment": contentAlignmentState.toDictionary((e) {
        if (e == null) return null;
        return {"x": e.x, "y": e.y};
      }),
      "duration": durationState.toDictionary((e) => e),
      "flex": flexState.toDictionary((e) => e),
      "gradient": gradientState.toDictionary((e) {
        if (e == null) return null;
        final begin = e.begin;
        final end = e.end;
        final transform = e.transform;
        return {
          if (begin is Alignment) "begin": {"x": begin.x, "y": begin.y},
          if (end is Alignment) "end": {"x": end.x, "y": end.y},
          "tileMode": e.tileMode.name,
          "colors": e.colors.map(colorToHex).toList(),
          "stops": e.stops,
          if (transform is GradientRotation)
            "transform": {"radians": transform.radians, "type": "rotation"},
        };
      }),
      "height": heightState.toDictionary(_safeEncodableDouble),
      "image": imageState.toDictionary((e) => e),
      "imageOpacity": imageOpacityState.toDictionary((e) => e),
      "imageScale": imageScaleState.toDictionary((e) => e),
      "margin": marginState.toDictionary((e) {
        if (e == null) return null;
        return {
          "left": e.left,
          "right": e.right,
          "top": e.top,
          "bottom": e.bottom,
        };
      }),
      "maxLines": maxLinesState.toDictionary((e) => e),
      "opacity": opacityState.toDictionary((e) => e),
      "padding": paddingState.toDictionary((e) {
        if (e == null) return null;
        return {
          "left": e.left,
          "right": e.right,
          "top": e.top,
          "bottom": e.bottom,
        };
      }),
      "position": positionState.toDictionary((e) => e?.dictionary),
      "scale": scaleState.toDictionary((e) => e),
      "size": sizeState.toDictionary((e) => e),
      "textAlign": textAlignState.toDictionary((e) => e?.name),
      "textStyle": textStyleState.toDictionary((e) {
        if (e == null) return null;
        TextDecoration.underline.toString();
        final entries = {
          "backgroundColor": colorToHex(e.backgroundColor),
          "color": colorToHex(e.color),
          "decorationThickness": e.decorationThickness,
          "decorationStyle": e.decorationStyle?.name,
          "decorationColor": colorToHex(e.decorationColor),
          "decoration": e.decoration?.toString(),
          "debugLabel": e.debugLabel,
          "fontSize": e.fontSize,
          "fontWeight": e.fontWeight?.value,
          "fontFamily": e.fontFamily,
          "fontStyle": e.fontStyle?.name,
          "fontFamilyFallback": e.fontFamilyFallback,
          "fontFeatures": e.fontFeatures?.map((e) => e.value).toList(),
          "fontVariations": e.fontVariations
              ?.map((e) => {"value": e.value, "axis": e.axis})
              .toList(),
          "height": e.height,
          "inherit": e.inherit,
          "letterSpacing": e.letterSpacing,
          "leadingDistribution": e.leadingDistribution?.name,
          "locale": e.locale?.toString(),
          "overflow": e.overflow?.name,
          "shadows": e.shadows
              ?.map((e) => {
                    "color": colorToHex(e.color),
                    "offset": {"dx": e.offset.dx, "dy": e.offset.dy},
                    "blurRadius": e.blurRadius,
                  })
              .toList(),
          "textBaseline": e.textBaseline?.name,
          "wordSpacing": e.wordSpacing,
        }.entries.where((e) => e.value != null);
        return Map.fromEntries(entries);
      }),
      "width": widthState.toDictionary(_safeEncodableDouble),
    }.entries.where((e) => e.value != null);
    return Map.fromEntries(entries);
  }

  factory InAppPurchasePaywallStyle.parse(Object? source, bool dark) {
    if (source is! Map) return InAppPurchasePaywallStyle();
    return InAppPurchasePaywallStyle(
      alignmentState: InAppPurchasePaywallState.parse(
        source['alignment'],
        parseAlignment,
      ),
      backgroundColorState: InAppPurchasePaywallState.parse(
        source['backgroundColor'],
        (value) => _parseColor(value, dark),
      ),
      blendModeState: InAppPurchasePaywallState.parse(
        source['blendMode'],
        parseBlendMode,
      ),
      blurState: InAppPurchasePaywallState.parse(
        source['blur'],
        parseDouble,
      ),
      borderState: InAppPurchasePaywallState.parse(
        source['border'],
        (value) => parseBorder(value, dark),
      ),
      borderRadiusState: InAppPurchasePaywallState.parse(
        source['borderRadius'],
        parseBorderRadius,
      ),
      boxShadowState: InAppPurchasePaywallState.parse(source['boxShadow'], (v) {
        return parseList(v, (e) => parseBoxShadow(e, dark));
      }),
      colorState: InAppPurchasePaywallState.parse(
        source['color'],
        (value) => _parseColor(value, dark),
      ),
      contentAlignmentState: InAppPurchasePaywallState.parse(
        source['contentAlignment'],
        parseAlignment,
      ),
      durationState: InAppPurchasePaywallState.parse(
        source['duration'],
        parseInt,
      ),
      flexState: InAppPurchasePaywallState.parse(
        source['flex'],
        parseInt,
      ),
      gradientState: InAppPurchasePaywallState.parse(
        source['gradient'],
        (value) => parseGradient(value, dark),
      ),
      heightState: InAppPurchasePaywallState.parse(
        source['height'],
        parseDouble,
      ),
      imageState: InAppPurchasePaywallState.parse(
        source['image'],
        parseString,
      ),
      imageOpacityState: InAppPurchasePaywallState.parse(
        source['imageOpacity'],
        parseDouble,
      ),
      imageScaleState: InAppPurchasePaywallState.parse(
        source['imageScale'],
        parseDouble,
      ),
      marginState: InAppPurchasePaywallState.parse(
        source['margin'],
        parseEdgeInsets,
      ),
      maxLinesState: InAppPurchasePaywallState.parse(
        source['maxLines'],
        parseInt,
      ),
      opacityState: InAppPurchasePaywallState.parse(
        source['opacity'],
        parseDouble,
      ),
      paddingState: InAppPurchasePaywallState.parse(
        source['padding'],
        parseEdgeInsets,
      ),
      positionState: InAppPurchasePaywallState.parse(
        source['position'],
        parsePosition,
      ),
      scaleState: InAppPurchasePaywallState.parse(
        source['scale'],
        parseDouble,
      ),
      sizeState: InAppPurchasePaywallState.parse(
        source['size'],
        parseDouble,
      ),
      textAlignState: InAppPurchasePaywallState.parse(
        source['textAlign'],
        parseTextAlign,
      ),
      textStyleState: InAppPurchasePaywallState.parse(
        source['textStyle'],
        (value) => parseTextStyle(value, dark),
      ),
      widthState: InAppPurchasePaywallState.parse(
        source['width'],
        parseDouble,
      ),
    );
  }

  InAppPurchasePaywallStyle copyWith({
    bool? selected,
    InAppPurchasePaywallState<Alignment?>? alignmentState,
    InAppPurchasePaywallState<Color?>? backgroundColorState,
    InAppPurchasePaywallState<BlendMode?>? blendModeState,
    InAppPurchasePaywallState<double?>? blurState,
    InAppPurchasePaywallState<Border?>? borderState,
    InAppPurchasePaywallState<BorderRadius?>? borderRadiusState,
    InAppPurchasePaywallState<List<BoxShadow>?>? boxShadowState,
    InAppPurchasePaywallState<Color?>? colorState,
    InAppPurchasePaywallState<Alignment?>? contentAlignmentState,
    InAppPurchasePaywallState<int?>? durationState,
    InAppPurchasePaywallState<int?>? flexState,
    InAppPurchasePaywallState<LinearGradient?>? gradientState,
    InAppPurchasePaywallState<double?>? heightState,
    InAppPurchasePaywallState<String?>? imageState,
    InAppPurchasePaywallState<double?>? imageOpacityState,
    InAppPurchasePaywallState<double?>? imageScaleState,
    InAppPurchasePaywallState<EdgeInsets?>? marginState,
    InAppPurchasePaywallState<int?>? maxLinesState,
    InAppPurchasePaywallState<double?>? opacityState,
    InAppPurchasePaywallState<EdgeInsets?>? paddingState,
    InAppPurchasePaywallState<InAppPurchasePaywallStylePosition?>?
        positionState,
    InAppPurchasePaywallState<double?>? scaleState,
    InAppPurchasePaywallState<double?>? sizeState,
    InAppPurchasePaywallState<TextAlign?>? textAlignState,
    InAppPurchasePaywallState<TextStyle?>? textStyleState,
    InAppPurchasePaywallState<double?>? widthState,
  }) {
    return InAppPurchasePaywallStyle(
      alignmentState: alignmentState ?? this.alignmentState,
      backgroundColorState: backgroundColorState ?? this.backgroundColorState,
      blendModeState: blendModeState ?? this.blendModeState,
      blurState: blurState ?? this.blurState,
      borderState: borderState ?? this.borderState,
      borderRadiusState: borderRadiusState ?? this.borderRadiusState,
      boxShadowState: boxShadowState ?? this.boxShadowState,
      colorState: colorState ?? this.colorState,
      contentAlignmentState:
          contentAlignmentState ?? this.contentAlignmentState,
      durationState: durationState ?? this.durationState,
      flexState: flexState ?? this.flexState,
      gradientState: gradientState ?? this.gradientState,
      heightState: heightState ?? this.heightState,
      imageState: imageState ?? this.imageState,
      imageOpacityState: imageOpacityState ?? this.imageOpacityState,
      imageScaleState: imageScaleState ?? this.imageScaleState,
      marginState: marginState ?? this.marginState,
      maxLinesState: maxLinesState ?? this.maxLinesState,
      opacityState: opacityState ?? this.opacityState,
      paddingState: paddingState ?? this.paddingState,
      positionState: positionState ?? this.positionState,
      selected: selected ?? this.selected,
      scaleState: scaleState ?? this.scaleState,
      sizeState: sizeState ?? this.sizeState,
      textAlignState: textAlignState ?? this.textAlignState,
      textStyleState: textStyleState ?? this.textStyleState,
      widthState: widthState ?? this.widthState,
    );
  }

  InAppPurchasePaywallStyle resolveWith({
    bool? selected,
    InAppPurchasePaywallScaler? scaler,
    TextDirection? textDirection,
  }) {
    double? dp(double? value) {
      if (value == null) return null;
      if (scaler == null) return value;
      return scaler(value);
    }

    T td<T>(T a, T b) {
      if (textDirection == null) return a;
      return textDirection == TextDirection.rtl ? b : a;
    }

    Offset? resolveOffset(Offset? e) {
      if (e == null) return null;
      return Offset(dp(e.dx) ?? 0, dp(e.dy) ?? 0);
    }

    Alignment? resolveAlignment(Alignment? e) {
      if (e == null || textDirection == null) return e;
      if (textDirection == TextDirection.ltr) return e;
      return Alignment(-e.x, e.y);
    }

    EdgeInsets? resolveEdge(EdgeInsets? e) {
      if (e == null) return null;
      return e.copyWith(
        left: dp(td(e.left, e.right)),
        right: dp(td(e.right, e.left)),
        top: dp(e.top),
        bottom: dp(e.bottom),
      );
    }

    return copyWith(
      selected: selected,
      alignmentState: alignmentState.resolveWith(resolveAlignment),
      widthState: widthState.resolveWith(dp),
      heightState: heightState.resolveWith(dp),
      blurState: blurState.resolveWith(dp),
      borderState: borderState.resolveWith((e) {
        if (e == null) return null;
        BorderSide resolve(BorderSide s) => s.copyWith(width: dp(s.width));
        return Border(
          top: resolve(e.top),
          bottom: resolve(e.bottom),
          left: resolve(td(e.left, e.right)),
          right: resolve(td(e.right, e.left)),
        );
      }),
      borderRadiusState: borderRadiusState.resolveWith((value) {
        if (value == null) return null;
        Radius resolve(Radius e) {
          return Radius.elliptical(dp(e.x) ?? 0, dp(e.y) ?? 0);
        }

        return value.copyWith(
          topLeft: resolve(td(value.topLeft, value.topRight)),
          topRight: resolve(td(value.topRight, value.topLeft)),
          bottomRight: resolve(td(value.bottomRight, value.bottomLeft)),
          bottomLeft: resolve(td(value.bottomLeft, value.bottomRight)),
        );
      }),
      boxShadowState: boxShadowState.resolveWith((values) {
        return values?.map((value) {
          return value.copyWith(
            offset: resolveOffset(value.offset),
            blurRadius: dp(value.blurRadius),
            spreadRadius: dp(value.spreadRadius),
          );
        }).toList();
      }),
      contentAlignmentState:
          contentAlignmentState.resolveWith(resolveAlignment),
      marginState: marginState.resolveWith(resolveEdge),
      paddingState: paddingState.resolveWith(resolveEdge),
      positionState: positionState.resolveWith((value) {
        return value?.resolveWith(
          scaler: scaler,
          textDirection: textDirection,
        );
      }),
      gradientState: gradientState.resolveWith((e) {
        if (e == null || e.colors.length < 2) return null;
        final begin = e.begin;
        final end = e.end;
        return LinearGradient(
          begin: begin is Alignment ? resolveAlignment(begin) ?? begin : begin,
          end: end is Alignment ? resolveAlignment(end) ?? end : end,
          colors: e.colors,
          stops: e.stops,
          tileMode: e.tileMode,
          transform: e.transform,
        );
      }),
      sizeState: sizeState.resolveWith(dp),
      textStyleState: textStyleState.resolveWith((value) {
        return value?.copyWith(
          fontSize: dp(value.fontSize),
          decorationThickness: dp(value.decorationThickness),
        );
      }),
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

  final InAppPurchasePaywallStyle style;

  final InAppPurchasePaywallState<String?>? _badgeText;
  final InAppPurchasePaywallStyle badgeStyle;

  final InAppPurchasePaywallStyle leftStyle;
  final InAppPurchasePaywallState<String?>? _leftTopText;
  final InAppPurchasePaywallStyle leftTopStyle;
  final InAppPurchasePaywallState<String?>? _leftMiddleText;
  final InAppPurchasePaywallStyle leftMiddleStyle;
  final InAppPurchasePaywallState<String?>? _leftBottomText;
  final InAppPurchasePaywallStyle leftBottomStyle;

  final InAppPurchasePaywallStyle rightStyle;
  final InAppPurchasePaywallState<String?>? _rightTopText;
  final InAppPurchasePaywallStyle rightTopStyle;
  final InAppPurchasePaywallState<String?>? _rightMiddleText;
  final InAppPurchasePaywallStyle rightMiddleStyle;
  final InAppPurchasePaywallState<String?>? _rightBottomText;
  final InAppPurchasePaywallStyle rightBottomStyle;

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

  String? get buttonText => buttonTextState.of(selected);

  InAppPurchasePaywallState<String?> get buttonTextState {
    return _buttonText?.resolveWith(stringify) ??
        InAppPurchasePaywallState.all(null);
  }

  String? get bottomText => bottomTextState.of(selected);

  InAppPurchasePaywallState<String?> get bottomTextState {
    return _bottomText?.resolveWith(stringify) ??
        InAppPurchasePaywallState.all(null);
  }

  InAppPurchasePaywallStyle get selectedTitleStyle {
    return titleStyle.copyWith(selected: selected);
  }

  InAppPurchasePaywallStyle get selectedDescriptionStyle {
    return descriptionStyle.copyWith(selected: selected);
  }

  InAppPurchasePaywallStyle get selectedStyle {
    return style.copyWith(selected: selected);
  }

  InAppPurchasePaywallStyle get selectedBadgeStyle {
    return badgeStyle.copyWith(selected: selected);
  }

  InAppPurchasePaywallStyle get selectedLeftStyle {
    return leftStyle.copyWith(selected: selected);
  }

  InAppPurchasePaywallStyle get selectedLeftTopStyle {
    return leftTopStyle.copyWith(selected: selected);
  }

  InAppPurchasePaywallStyle get selectedLeftMiddleStyle {
    return leftMiddleStyle.copyWith(selected: selected);
  }

  InAppPurchasePaywallStyle get selectedLeftBottomStyle {
    return leftBottomStyle.copyWith(selected: selected);
  }

  InAppPurchasePaywallStyle get selectedRightStyle {
    return rightStyle.copyWith(selected: selected);
  }

  InAppPurchasePaywallStyle get selectedRightTopStyle {
    return rightTopStyle.copyWith(selected: selected);
  }

  InAppPurchasePaywallStyle get selectedRightMiddleStyle {
    return rightMiddleStyle.copyWith(selected: selected);
  }

  InAppPurchasePaywallStyle get selectedRightBottomStyle {
    return rightBottomStyle.copyWith(selected: selected);
  }

  InAppPurchasePaywallStyle get selectedButtonStyle {
    return buttonStyle.copyWith(selected: selected);
  }

  InAppPurchasePaywallStyle get selectedBottomStyle {
    return bottomStyle.copyWith(selected: selected);
  }

  String? stringify(String? value) {
    if (value == null) return null;
    if (value.isEmpty) return '';
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
    this.titleStyle = const InAppPurchasePaywallStyle(),
    this.descriptionStyle = const InAppPurchasePaywallStyle(),
    this.style = const InAppPurchasePaywallStyle(),
    this.badgeStyle = const InAppPurchasePaywallStyle(),
    this.leftStyle = const InAppPurchasePaywallStyle(),
    this.leftTopStyle = const InAppPurchasePaywallStyle(),
    this.leftMiddleStyle = const InAppPurchasePaywallStyle(),
    this.leftBottomStyle = const InAppPurchasePaywallStyle(),
    this.rightStyle = const InAppPurchasePaywallStyle(),
    this.rightTopStyle = const InAppPurchasePaywallStyle(),
    this.rightMiddleStyle = const InAppPurchasePaywallStyle(),
    this.rightBottomStyle = const InAppPurchasePaywallStyle(),
    this.buttonStyle = const InAppPurchasePaywallStyle(),
    this.bottomStyle = const InAppPurchasePaywallStyle(),
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

    addObject("period", _period?.toDictionary((e) => e));
    addObject("price", _price?.toDictionary((e) => e));
    addObject("unit", _unit?.toDictionary((e) => e));
    addObject("badgeText", _badgeText?.toDictionary((e) => e));
    addObject("bottomText", _bottomText?.toDictionary((e) => e));
    addObject("buttonText", _buttonText?.toDictionary((e) => e));
    addObject("descriptionText", _descriptionText?.toDictionary((e) => e));
    addObject("leftBottomText", _leftBottomText?.toDictionary((e) => e));
    addObject("leftMiddleText", _leftMiddleText?.toDictionary((e) => e));
    addObject("leftTopText", _leftTopText?.toDictionary((e) => e));
    addObject("rightBottomText", _rightBottomText?.toDictionary((e) => e));
    addObject("rightMiddleText", _rightMiddleText?.toDictionary((e) => e));
    addObject("rightTopText", _rightTopText?.toDictionary((e) => e));
    addObject("titleText", _titleText?.toDictionary((e) => e));

    addDictionary("style", style.dictionary);
    addDictionary("badgeStyle", badgeStyle.dictionary);
    addDictionary("bottomStyle", bottomStyle.dictionary);
    addDictionary("buttonStyle", buttonStyle.dictionary);
    addDictionary("descriptionStyle", descriptionStyle.dictionary);
    addDictionary("leftStyle", leftStyle.dictionary);
    addDictionary("leftBottomStyle", leftBottomStyle.dictionary);
    addDictionary("leftMiddleStyle", leftMiddleStyle.dictionary);
    addDictionary("leftTopStyle", leftTopStyle.dictionary);
    addDictionary("rightStyle", rightStyle.dictionary);
    addDictionary("rightBottomStyle", rightBottomStyle.dictionary);
    addDictionary("rightMiddleStyle", rightMiddleStyle.dictionary);
    addDictionary("rightTopStyle", rightTopStyle.dictionary);
    addDictionary("titleStyle", titleStyle.dictionary);
    return map;
  }

  factory InAppPurchasePaywallProduct.fromConfigs({
    required InAppPurchaseProduct product,
    required Map configs,
    required bool dark,
  }) {
    final parser = InAppPurchaser.parseConfig;

    return InAppPurchasePaywallProduct(
      product: product,
      period: InAppPurchasePaywallState.parse(
        configs['period'],
        (v) => parser<String?>(v, null),
      ),
      price: InAppPurchasePaywallState.parse(
        configs['price'],
        (v) => parser<double?>(v, null),
      ),
      unit: InAppPurchasePaywallState.parse(
        configs['unit'],
        (v) => parser<int?>(v, null),
      ),
      style: InAppPurchasePaywallStyle.parse(
        configs['style'],
        dark,
      ),
      leftStyle: InAppPurchasePaywallStyle.parse(
        configs['leftStyle'],
        dark,
      ),
      leftTopText: InAppPurchasePaywallState.parse(
        configs['leftTopText'],
        (v) => parser<String?>(v, null),
      ),
      leftTopStyle: InAppPurchasePaywallStyle.parse(
        configs["leftTopStyle"],
        dark,
      ),
      leftMiddleText: InAppPurchasePaywallState.parse(
        configs['leftMiddleText'],
        (v) => parser<String?>(v, null),
      ),
      leftMiddleStyle: InAppPurchasePaywallStyle.parse(
        configs["leftMiddleStyle"],
        dark,
      ),
      leftBottomText: InAppPurchasePaywallState.parse(
        configs['leftBottomText'],
        (v) => parser<String?>(v, null),
      ),
      leftBottomStyle: InAppPurchasePaywallStyle.parse(
        configs["leftBottomStyle"],
        dark,
      ),
      rightStyle: InAppPurchasePaywallStyle.parse(
        configs["rightStyle"],
        dark,
      ),
      rightTopText: InAppPurchasePaywallState.parse(
        configs['rightTopText'],
        (v) => parser<String?>(v, null),
      ),
      rightTopStyle: InAppPurchasePaywallStyle.parse(
        configs["rightTopStyle"],
        dark,
      ),
      rightMiddleText: InAppPurchasePaywallState.parse(
        configs['rightMiddleText'],
        (v) => parser<String?>(v, null),
      ),
      rightMiddleStyle: InAppPurchasePaywallStyle.parse(
        configs["rightMiddleStyle"],
        dark,
      ),
      rightBottomText: InAppPurchasePaywallState.parse(
        configs['rightBottomText'],
        (v) => parser<String?>(v, null),
      ),
      rightBottomStyle: InAppPurchasePaywallStyle.parse(
        configs["rightBottomStyle"],
        dark,
      ),
      badgeText: InAppPurchasePaywallState.parse(
        configs['badgeText'],
        (v) => parser<String?>(v, null),
      ),
      badgeStyle: InAppPurchasePaywallStyle.parse(
        configs["badgeStyle"],
        dark,
      ),
      buttonText: InAppPurchasePaywallState.parse(
        configs['buttonText'],
        (v) => parser<String?>(v, null),
      ),
      buttonStyle: InAppPurchasePaywallStyle.parse(
        configs["buttonStyle"],
        dark,
      ),
      bottomText: InAppPurchasePaywallState.parse(
        configs['bottomText'],
        (v) => parser<String?>(v, null),
      ),
      bottomStyle: InAppPurchasePaywallStyle.parse(
        configs["bottomStyle"],
        dark,
      ),
      titleText: InAppPurchasePaywallState.parse(
        configs['titleText'],
        (v) => parser<String?>(v, null),
      ),
      titleStyle: InAppPurchasePaywallStyle.parse(
        configs["titleStyle"],
        dark,
      ),
      descriptionText: InAppPurchasePaywallState.parse(
        configs['descriptionText'],
        (v) => parser<String?>(v, null),
      ),
      descriptionStyle: InAppPurchasePaywallStyle.parse(
        configs["descriptionStyle"],
        dark,
      ),
    );
  }

  InAppPurchasePaywallProduct copyWith({
    bool? selected,
    InAppPurchaseProduct? product,
    InAppPurchasePaywallState<double?>? price,
    InAppPurchasePaywallState<String?>? period,
    InAppPurchasePaywallState<int?>? unit,
    InAppPurchasePaywallState<String?>? titleText,
    InAppPurchasePaywallStyle? titleStyle,
    InAppPurchasePaywallState<String?>? descriptionText,
    InAppPurchasePaywallStyle? descriptionStyle,
    InAppPurchasePaywallStyle? style,
    InAppPurchasePaywallStyle? leftStyle,
    InAppPurchasePaywallState<String?>? leftTopText,
    InAppPurchasePaywallStyle? leftTopStyle,
    InAppPurchasePaywallState<String?>? leftMiddleText,
    InAppPurchasePaywallStyle? leftMiddleStyle,
    InAppPurchasePaywallState<String?>? leftBottomText,
    InAppPurchasePaywallStyle? leftBottomStyle,
    InAppPurchasePaywallStyle? rightStyle,
    InAppPurchasePaywallState<String?>? rightTopText,
    InAppPurchasePaywallStyle? rightTopStyle,
    InAppPurchasePaywallState<String?>? rightMiddleText,
    InAppPurchasePaywallStyle? rightMiddleStyle,
    InAppPurchasePaywallState<String?>? rightBottomText,
    InAppPurchasePaywallStyle? rightBottomStyle,
    InAppPurchasePaywallState<String?>? badgeText,
    InAppPurchasePaywallStyle? badgeStyle,
    InAppPurchasePaywallState<String?>? buttonText,
    InAppPurchasePaywallStyle? buttonStyle,
    InAppPurchasePaywallState<String?>? bottomText,
    InAppPurchasePaywallStyle? bottomStyle,
  }) {
    return InAppPurchasePaywallProduct(
      selected: selected ?? this.selected,
      product: product ?? this.product,
      style: style ?? this.style,
      badgeStyle: badgeStyle ?? this.badgeStyle,
      badgeText: badgeText ?? _badgeText,
      bottomStyle: bottomStyle ?? this.bottomStyle,
      bottomText: bottomText ?? _bottomText,
      buttonStyle: buttonStyle ?? this.buttonStyle,
      buttonText: buttonText ?? _buttonText,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      descriptionText: descriptionText ?? _descriptionText,
      leftStyle: leftStyle ?? this.leftStyle,
      leftBottomStyle: leftBottomStyle ?? this.leftBottomStyle,
      leftBottomText: leftBottomText ?? _leftBottomText,
      leftMiddleStyle: leftMiddleStyle ?? this.leftMiddleStyle,
      leftMiddleText: leftMiddleText ?? _leftMiddleText,
      leftTopStyle: leftTopStyle ?? this.leftTopStyle,
      leftTopText: leftTopText ?? _leftTopText,
      period: period ?? _period,
      price: price ?? _price,
      rightStyle: rightStyle ?? this.rightStyle,
      rightBottomStyle: rightBottomStyle ?? this.rightBottomStyle,
      rightBottomText: rightBottomText ?? _rightBottomText,
      rightMiddleStyle: rightMiddleStyle ?? this.rightMiddleStyle,
      rightMiddleText: rightMiddleText ?? _rightMiddleText,
      rightTopStyle: rightTopStyle ?? this.rightTopStyle,
      rightTopText: rightTopText ?? _rightTopText,
      titleStyle: titleStyle ?? this.titleStyle,
      titleText: titleText ?? _titleText,
      unit: unit ?? _unit,
    );
  }

  InAppPurchasePaywallProduct resolveWith({
    bool? selected,
    InAppPurchasePaywallScaler? scaler,
    TextDirection? textDirection,
  }) {
    return copyWith(
      style: style.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      badgeStyle: badgeStyle.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      bottomStyle: bottomStyle.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      buttonStyle: buttonStyle.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      descriptionStyle: descriptionStyle.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      leftStyle: leftStyle.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      leftBottomStyle: leftBottomStyle.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      leftMiddleStyle: leftMiddleStyle.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      leftTopStyle: leftTopStyle.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      rightStyle: rightStyle.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      rightBottomStyle: rightBottomStyle.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      rightMiddleStyle: rightMiddleStyle.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      rightTopStyle: rightTopStyle.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      titleStyle: titleStyle.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
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
  final InAppPurchasePaywallStyle heroImageStyle;
  final String? image;
  final InAppPurchasePaywallStyle imageStyle;
  final String? headerText;
  final InAppPurchasePaywallStyle headerStyle;
  final String? bodyText;
  final InAppPurchasePaywallStyle bodyStyle;
  final String? titleText;
  final InAppPurchasePaywallStyle titleStyle;
  final String? descriptionText;
  final InAppPurchasePaywallStyle descriptionStyle;
  final List features;
  final InAppPurchasePaywallStyle featureStyle;
  final InAppPurchasePaywallStyle style;

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
    this.descriptionText,
    this.descriptionStyle = const InAppPurchasePaywallStyle(),
    this.features = const [],
    this.featureStyle = const InAppPurchasePaywallStyle(),
    this.style = const InAppPurchasePaywallStyle(),
  });

  Map<String, dynamic> get dictionary {
    final map = {
      if (initialIndex > 0) "initialIndex": initialIndex,
      if (designType.isNotEmpty) "designType": designType,
      if (skipMode) "skipMode": skipMode,
      if ((heroImage ?? '').isNotEmpty) "heroImage": heroImage,
      if ((image ?? '').isNotEmpty) "image": image,
      if ((headerText ?? '').isNotEmpty) "headerText": headerText,
      if ((bodyText ?? '').isNotEmpty) "bodyText": bodyText,
      if ((titleText ?? '').isNotEmpty) "titleText": titleText,
      if ((descriptionText ?? '').isNotEmpty)
        "descriptionText": descriptionText,
      if (features.isNotEmpty) "features": features,
      if (products.isNotEmpty)
        "products": products
            .map((e) => e.dictionary)
            .where((e) => e.isNotEmpty)
            .toList(),
    };

    void addDictionary(String key, Map map) {
      if (map.isEmpty) return;
      map[key] = map;
    }

    addDictionary("heroImageStyle", heroImageStyle.dictionary);
    addDictionary("imageStyle", imageStyle.dictionary);
    addDictionary("headerStyle", headerStyle.dictionary);
    addDictionary("bodyStyle", bodyStyle.dictionary);
    addDictionary("titleStyle", titleStyle.dictionary);
    addDictionary("descriptionStyle", descriptionStyle.dictionary);
    addDictionary("featureStyle", featureStyle.dictionary);
    addDictionary("style", style.dictionary);
    return map;
  }

  factory InAppPurchasePaywall.fromOffering(
    InAppPurchaseOffering offering,
    bool dark,
  ) {
    final parser = InAppPurchaser.parseConfig;
    final configs = offering.configs;

    final initialIndex = parser(configs["initialIndex"], 0);
    final designType = parser(configs["designType"], 'v1');
    final skipMode = parser(configs["skipMode"], false);
    final heroImage = parser<String?>(configs["heroImage"], null);
    final image = parser<String?>(configs["image"], null);
    final headerText = parser<String?>(configs["headerText"], null);
    final bodyText = parser<String?>(configs["bodyText"], null);
    final titleText = parser<String?>(configs["titleText"], null);
    final descriptionText = parser<String?>(configs["descriptionText"], null);
    final features = parser<List?>(configs["features"], null);
    final products = parser<List?>(configs["products"], null);
    final heroImageStyle = parser<Map?>(configs["heroImageStyle"], null);
    final imageStyle = parser<Map?>(configs["imageStyle"], null);
    final headerStyle = parser<Map?>(configs["headerStyle"], null);
    final bodyStyle = parser<Map?>(configs["bodyStyle"], null);
    final titleStyle = parser<Map?>(configs["titleStyle"], null);
    final descriptionStyle = parser<Map?>(configs["descriptionStyle"], null);
    final featureStyle = parser<Map?>(configs["featureStyle"], null);
    final style = parser<Map?>(configs["style"], null);

    final mProducts = List.generate(offering.products.length, (index) {
      final productConfigs = products?.elementAtOrNull(index);
      return InAppPurchasePaywallProduct.fromConfigs(
        product: offering.products[index],
        configs: productConfigs is Map ? productConfigs : {},
        dark: dark,
      );
    });

    return InAppPurchasePaywall(
      id: offering.id,
      initialIndex: initialIndex,
      products: mProducts,
      designType: designType,
      skipMode: skipMode,
      heroImage: heroImage,
      heroImageStyle: InAppPurchasePaywallStyle.parse(heroImageStyle, dark),
      image: image,
      imageStyle: InAppPurchasePaywallStyle.parse(imageStyle, dark),
      headerText: headerText,
      headerStyle: InAppPurchasePaywallStyle.parse(headerStyle, dark),
      bodyText: bodyText,
      bodyStyle: InAppPurchasePaywallStyle.parse(bodyStyle, dark),
      titleText: titleText,
      titleStyle: InAppPurchasePaywallStyle.parse(titleStyle, dark),
      descriptionText: descriptionText,
      descriptionStyle: InAppPurchasePaywallStyle.parse(descriptionStyle, dark),
      features: features ?? [],
      featureStyle: InAppPurchasePaywallStyle.parse(featureStyle, dark),
      style: InAppPurchasePaywallStyle.parse(style, dark),
    );
  }

  InAppPurchasePaywall copyWith({
    String? id,
    List<InAppPurchasePaywallProduct>? products,
    int? initialIndex,
    String? designType,
    bool? skipMode,
    String? heroImage,
    InAppPurchasePaywallStyle? heroImageStyle,
    String? image,
    InAppPurchasePaywallStyle? imageStyle,
    String? headerText,
    InAppPurchasePaywallStyle? headerStyle,
    String? bodyText,
    InAppPurchasePaywallStyle? bodyStyle,
    String? titleText,
    InAppPurchasePaywallStyle? titleStyle,
    String? descriptionText,
    InAppPurchasePaywallStyle? descriptionStyle,
    List? features,
    InAppPurchasePaywallStyle? featureStyle,
    InAppPurchasePaywallStyle? style,
  }) {
    return InAppPurchasePaywall(
      id: id ?? this.id,
      initialIndex: initialIndex ?? this.initialIndex,
      designType: designType ?? this.designType,
      skipMode: skipMode ?? this.skipMode,
      products: products ?? this.products,
      heroImage: heroImage ?? this.heroImage,
      heroImageStyle: heroImageStyle ?? this.heroImageStyle,
      image: image ?? this.image,
      imageStyle: imageStyle ?? this.imageStyle,
      headerText: headerText ?? this.headerText,
      headerStyle: headerStyle ?? this.headerStyle,
      bodyText: bodyText ?? this.bodyText,
      bodyStyle: bodyStyle ?? this.bodyStyle,
      titleText: titleText ?? this.titleText,
      titleStyle: titleStyle ?? this.titleStyle,
      descriptionText: descriptionText ?? this.descriptionText,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      features: features ?? this.features,
      featureStyle: featureStyle ?? this.featureStyle,
      style: style ?? this.style,
    );
  }

  InAppPurchasePaywall resolveWith({
    bool? selected,
    InAppPurchasePaywallScaler? scaler,
    TextDirection? textDirection,
  }) {
    return copyWith(
      bodyStyle: bodyStyle.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      descriptionStyle: bodyStyle.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      featureStyle: bodyStyle.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      headerStyle: bodyStyle.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      heroImageStyle: bodyStyle.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      imageStyle: bodyStyle.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      titleStyle: bodyStyle.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      style: style.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      products: products.map((e) {
        return e.resolveWith(
          selected: selected,
          scaler: scaler,
          textDirection: textDirection,
        );
      }).toList(),
    );
  }
}
