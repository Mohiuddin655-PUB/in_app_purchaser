import 'package:flutter/material.dart';

class InAppPurchasePaywallText extends StatelessWidget {
  final String data;
  final TextAlign? textAlign;
  final int? maxLines;
  final Color? color;
  final double? fontSize;
  final TextStyle? style;
  final Widget child;

  const InAppPurchasePaywallText(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.style,
    this.textAlign,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return SizedBox();
    final spans = InAppPurchasePaywallTextParser.parse(data);
    if (spans.length > 1) {
      return Text.rich(
        TextSpan(
          text: spans[0].text,
          children: List.generate(spans.length - 1, (index) {
            final text = spans[index + 1];
            return TextSpan(
              text: text.text,
              style: TextStyle(
                decoration:
                    text.isLineThrough ? TextDecoration.lineThrough : null,
                fontWeight: text.isBold ? FontWeight.bold : null,
                fontStyle: text.isItalic ? FontStyle.italic : null,
              ),
            );
          }),
        ),
        maxLines: maxLines,
        textAlign: textAlign,
        style: (style ?? TextStyle()).copyWith(
          color: style?.color ?? color,
          fontSize: style?.fontSize ?? fontSize,
        ),
      );
    } else {
      return Text(
        data,
        maxLines: maxLines,
        textAlign: textAlign,
        style: (style ?? TextStyle()).copyWith(
          color: style?.color ?? color,
          fontSize: style?.fontSize ?? fontSize,
        ),
      );
    }
  }
}

class InAppPurchasePaywallTextParser {
  static List<InAppPurchasePaywallSpanText> parse(String paragraph) {
    if (paragraph.isEmpty) return [];
    if (!paragraph.startsWith("<p>")) {
      paragraph = "<p>$paragraph";
    }
    if (!paragraph.endsWith("</p>")) {
      paragraph = "$paragraph</p>";
    }
    List<InAppPurchasePaywallSpanText> texts = [];

    // Regex to extract everything inside <p> and spans within <p>
    RegExp pTagExp = RegExp(r'<p[^>]*>(.*?)</p>', dotAll: true);
    RegExp spanTagExp = RegExp(r'<(\w+)[^>]*>(.*?)</\1>', dotAll: true);

    // Helper function to recursively extract nested spans
    List<InAppPurchasePaywallSpanText> parseSpans(
        String text, List<String> tags) {
      List<InAppPurchasePaywallSpanText> texts = [];

      Iterable<RegExpMatch> spanMatches = spanTagExp.allMatches(text);

      int lastIndex = 0;

      for (var spanMatch in spanMatches) {
        String spanText = spanMatch.group(2)!;
        String spanType = spanMatch.group(1)!;
        int spanStart = spanMatch.start;
        int spanEnd = spanMatch.end;

        // Add any normal text between last index and span start
        if (spanStart > lastIndex) {
          String normalText = text.substring(lastIndex, spanStart);
          if (normalText.isNotEmpty) {
            texts.add(InAppPurchasePaywallNormalText(text: normalText));
          }
        }

        // Parse nested spans recursively
        List<String> nestedTags = [...tags, spanType];
        var nestedElements = parseSpans(spanText, nestedTags);
        if (nestedElements.isEmpty) {
          texts.add(InAppPurchasePaywallSpannedText(
              text: spanText, types: nestedTags));
        } else {
          texts.addAll(nestedElements);
        }

        lastIndex = spanEnd;
      }

      // Add any remaining normal text after the last span
      if (lastIndex < text.length) {
        String remainingText = text.substring(lastIndex);
        if (remainingText.isNotEmpty) {
          if (tags.isNotEmpty) {
            texts.add(InAppPurchasePaywallSpannedText(
              text: remainingText,
              types: tags,
            ));
          } else {
            texts.add(InAppPurchasePaywallNormalText(text: remainingText));
          }
        }
      }

      return texts;
    }

    // Find the content inside <p> tags
    Iterable<RegExpMatch> pMatches = pTagExp.allMatches(paragraph);

    for (var pMatch in pMatches) {
      String pContent = pMatch.group(1)!; // Get the inner content of <p>

      // Parse content, starting with no parent tags
      texts.addAll(parseSpans(pContent, []));
    }

    return texts;
  }
}

abstract class InAppPurchasePaywallSpanText {
  final String text;

  bool get isSpannedText => this is InAppPurchasePaywallSpannedText;

  bool get isLineThrough {
    final x = this;
    return x is InAppPurchasePaywallSpannedText && x.types.any((e) => e == "l");
  }

  bool get isItalic {
    final x = this;
    return x is InAppPurchasePaywallSpannedText && x.types.any((e) => e == "i");
  }

  bool get isBold {
    final x = this;
    return x is InAppPurchasePaywallSpannedText && x.types.any((e) => e == "b");
  }

  const InAppPurchasePaywallSpanText({
    required this.text,
  });

  @override
  String toString() => '$InAppPurchasePaywallSpanText(text: $text)';
}

class InAppPurchasePaywallNormalText extends InAppPurchasePaywallSpanText {
  const InAppPurchasePaywallNormalText({
    required super.text,
  });

  @override
  String toString() => '$InAppPurchasePaywallNormalText(text: $text)';
}

class InAppPurchasePaywallSpannedText extends InAppPurchasePaywallSpanText {
  final List<String> types;

  const InAppPurchasePaywallSpannedText({
    required super.text,
    required this.types,
  });

  @override
  String toString() {
    return '$InAppPurchasePaywallSpannedText(text: $text, types: $types)';
  }
}
