import 'package:flutter/material.dart';

import '../utils/style.dart';
import '../utils/typedefs.dart';
import 'decorated_box.dart';

class PaywallLayout extends StatelessWidget {
  final bool primary;
  final bool decoration;
  final bool safeArea;
  final bool? selected;
  final PaywallStyle? style;
  final PaywallScaler? scaler;
  final TextDirection? textDirection;
  final List<Widget> children;

  const PaywallLayout({
    super.key,
    this.primary = true,
    this.decoration = true,
    this.safeArea = false,
    this.selected,
    this.scaler,
    this.style,
    this.textDirection,
    required this.children,
  });

  PaywallStyle? get _style {
    if (!primary) return style;
    if (textDirection != null || scaler != null) {
      return style?.resolveWith(
        selected: selected,
        textDirection: textDirection,
        scaler: scaler,
      );
    }
    if (selected != null) return style?.copyWith(selected: selected);
    return style;
  }

  Widget _build(BuildContext context, PaywallStyle s) {
    switch (s.layout!) {
      case PaywallLayoutType.flex:
        return Flex(
          clipBehavior: s.layoutClipBehavior ?? Clip.none,
          crossAxisAlignment:
              s.layoutCrossAxisAlignment ?? CrossAxisAlignment.center,
          direction: s.layoutDirection ?? Axis.vertical,
          mainAxisAlignment:
              s.layoutMainAxisAlignment ?? MainAxisAlignment.start,
          mainAxisSize: s.layoutMainAxisSize ?? MainAxisSize.max,
          spacing: s.layoutSpacing ?? 0,
          textBaseline: s.layoutTextBaseline,
          textDirection: textDirection,
          verticalDirection:
              s.layoutVerticalDirection ?? VerticalDirection.down,
          children: children,
        );
      case PaywallLayoutType.stack:
        return Stack(
          alignment: s.layoutAlignment ?? AlignmentDirectional.topStart,
          clipBehavior: s.layoutClipBehavior ?? Clip.hardEdge,
          fit: s.layoutStackFit ?? StackFit.loose,
          textDirection: textDirection,
          children: children,
        );
      case PaywallLayoutType.wrap:
        return Wrap(
          alignment: s.layoutWrapAlignment ?? WrapAlignment.start,
          clipBehavior: s.layoutClipBehavior ?? Clip.none,
          crossAxisAlignment:
              s.layoutWrapCrossAlignment ?? WrapCrossAlignment.start,
          direction: s.layoutDirection ?? Axis.horizontal,
          spacing: s.layoutSpacing ?? 0,
          runAlignment: s.layoutWrapRunAlignment ?? WrapAlignment.start,
          runSpacing: s.layoutRunSpacing ?? 0,
          textDirection: textDirection,
          verticalDirection:
              s.layoutVerticalDirection ?? VerticalDirection.down,
          children: children,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;
    if (style == null) return SizedBox();
    Widget child = _build(context, style);
    if (!decoration) return child;
    return PaywallDecoratedBox(
      primary: false,
      style: style,
      child: safeArea ? SafeArea(child: child) : child,
    );
  }
}
