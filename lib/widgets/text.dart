import 'package:flutter/material.dart';
import 'package:flutter_text_parser/flutter_text_parser.dart';

import '../src/paywall.dart';

class InAppPurchasePaywallText extends StatelessWidget {
  final String data;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextStyle? style;
  final TextDirection? textDirection;
  final InAppPurchasePaywallScaler? scaler;
  final Widget Function(BuildContext context, List<TextSpan> spans)? builder;

  const InAppPurchasePaywallText(
    this.data, {
    super.key,
    this.maxLines,
    this.scaler,
    this.style,
    this.textAlign,
    this.textDirection,
    this.builder,
  });

  Color? _color(String source) {
    return InAppPurchasePaywallStyle.parseColor(source);
  }

  double? _double(String source, [bool scaleMode = false]) {
    final value = InAppPurchasePaywallStyle.parseDouble(source);
    if (value == null) return null;
    if (scaler == null) return value;
    return scaler!(value);
  }

  TextDecorationStyle? _decorationStyle(String source) {
    return InAppPurchasePaywallStyle.parseDecorationStyle(source);
  }

  FontWeight? _fontWeight(String source) {
    return InAppPurchasePaywallStyle.parserFontWeight(source);
  }

  FontStyle? _fontStyle(String source) {
    return InAppPurchasePaywallStyle.parseFontStyle(source);
  }

  Locale? _locale(String source) {
    return InAppPurchasePaywallStyle.parseLocale(source);
  }

  String? _string(String source) {
    return InAppPurchasePaywallStyle.parseString(source);
  }

  TextStyle _spanStyle(TextStyle s, SpannedTag tag) {
    switch (tag.tag) {
      case 'b':
      case 'bold':
        return s.merge(TextStyle(fontWeight: FontWeight.bold));
      case 'i':
      case 'italic':
        return s.merge(TextStyle(fontStyle: FontStyle.italic));
      case 'u':
      case 'underline':
        return s.merge(TextStyle(decoration: TextDecoration.underline));
      case 'l':
      case 'lt':
      case 'line_through':
      case 'line-through':
        return s.merge(TextStyle(decoration: TextDecoration.lineThrough));
      case 'bg':
      case 'background':
      case 'background_color':
      case 'background-color':
        if (tag.attr == null) return s;
        return s.merge(TextStyle(backgroundColor: _color(tag.attr!)));
      case 'c':
      case 'color':
        if (tag.attr == null) return s;
        return s.merge(TextStyle(color: _color(tag.attr!)));
      case 'dc':
      case 'decoration_color':
      case 'decoration-color':
        if (tag.attr == null) return s;
        return s.merge(TextStyle(decorationColor: _color(tag.attr!)));
      case 'ds':
      case 'decoration_style':
      case 'decoration-style':
        if (tag.attr == null) return s;
        return s.merge(
          TextStyle(decorationStyle: _decorationStyle(tag.attr!)),
        );
      case 'dt':
      case 'decoration_thickness':
      case 'decoration-thickness':
        if (tag.attr == null) return s;
        return s.merge(
          TextStyle(decorationThickness: _double(tag.attr!, true)),
        );
      case 'f':
      case 'ff':
      case 'family':
      case 'font_family':
      case 'font-family':
        if (tag.attr == null) return s;
        return s.merge(TextStyle(fontFamily: _string(tag.attr!)));
      case 'st':
      case 'font_size':
      case 'font-size':
        if (tag.attr == null) return s;
        return s.merge(TextStyle(fontSize: _double(tag.attr!, true)));
      case 'fs':
      case 'font_style':
      case 'font-style':
        if (tag.attr == null) return s;
        return s.merge(TextStyle(fontStyle: _fontStyle(tag.attr!)));
      case 'w':
      case 'fw':
      case 'weight':
      case 'font_weight':
      case 'font-weight':
        if (tag.attr == null) return s;
        return s.merge(
          TextStyle(fontWeight: _fontWeight(tag.attr!)),
        );
      case 'h':
      case 'height':
        if (tag.attr == null) return s;
        return s.merge(TextStyle(height: _double(tag.attr!)));
      case 'lo':
      case 'locale':
        if (tag.attr == null) return s;
        return s.merge(TextStyle(locale: _locale(tag.attr!)));
      case 'ls':
      case 'letter_spacing':
      case 'letter-spacing':
        if (tag.attr == null) return s;
        return s.merge(TextStyle(letterSpacing: _double(tag.attr!)));
      case 'ws':
      case 'word_spacing':
      case 'word-spacing':
        if (tag.attr == null) return s;
        return s.merge(TextStyle(wordSpacing: _double(tag.attr!)));
      default:
        return s;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return SizedBox();
    final parts = data.parsedSpanTexts;
    if (parts.isEmpty) return SizedBox();
    final spans = parts.map((part) {
      if (part is SpannedText) {
        TextStyle s = part.tags.fold(TextStyle(), _spanStyle);
        return TextSpan(text: part.text, style: s);
      }
      return TextSpan(text: part.text, style: style);
    }).toList();
    if (builder != null) return builder!(context, spans);
    return RichText(
      text: TextSpan(children: spans, style: style),
      maxLines: maxLines,
      textAlign: textAlign ?? TextAlign.start,
      textDirection: textDirection,
    );
  }
}
