import 'package:flutter/material.dart';

import 'position.dart';
import 'state.dart';

abstract final class StyleParser {
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

  static BoxConstraints? parseBoxConstraints(Object? source) {
    if (source is! Map || source.isEmpty) return null;
    return BoxConstraints(
      minWidth: parseDouble(source['minWidth']) ?? 0,
      maxWidth: parseDouble(source['maxWidth']) ?? double.infinity,
      minHeight: parseDouble(source['minHeight']) ?? 0,
      maxHeight: parseDouble(source['maxHeight']) ?? double.infinity,
    );
  }

  static Object? safeEncodableDouble(double? value) {
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

  static Color? parseThemedColor(Object? source, bool dark) {
    if (source is Map && source.isNotEmpty) {
      return PaywallState(
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
      color: parseThemedColor(source['color'], dark) ?? Colors.transparent,
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
      backgroundColor: parseThemedColor(source['backgroundColor'], dark),
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
      color: parseThemedColor(source['color'], dark),
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
      decorationColor: parseThemedColor(source['decorationColor'], dark),
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
        ? colors
            .map((e) => parseThemedColor(e, dark))
            .whereType<Color>()
            .toList()
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
    final color = parseThemedColor(source['color'], dark);
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

  static PaywallPosition? parsePosition(Object? source) {
    if (source is! Map || source.isEmpty) return null;
    return PaywallPosition(
      left: parseDouble(source['left']),
      right: parseDouble(source['right']),
      top: parseDouble(source['top']),
      bottom: parseDouble(source['bottom']),
      width: parseDouble(source['width']),
      height: parseDouble(source['height']),
    );
  }
}
