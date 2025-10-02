import 'package:flutter/material.dart';

import '../utils/style.dart';
import '../utils/typedefs.dart';

class PaywallLayout extends StatefulWidget {
  final bool? selected;
  final PaywallStyle style;
  final PaywallScaler? scaler;
  final TextDirection? textDirection;
  final List<Widget> children;

  const PaywallLayout({
    super.key,
    this.selected,
    this.scaler,
    this.textDirection,
    required this.style,
    required this.children,
  });

  @override
  State<PaywallLayout> createState() => _PaywallLayoutState();
}

class _PaywallLayoutState extends State<PaywallLayout> {
  late PaywallStyle style;

  @override
  void initState() {
    super.initState();
    if (widget.textDirection != null || widget.scaler != null) {
      style = widget.style.resolveWith(
        selected: widget.selected,
        textDirection: widget.textDirection,
        scaler: widget.scaler,
      );
    } else if (widget.selected != null) {
      style = widget.style.copyWith(selected: widget.selected);
    } else {
      style = widget.style;
    }
  }

  @override
  void didUpdateWidget(covariant PaywallLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.textDirection != oldWidget.textDirection) {
      style = widget.style.resolveWith(
        selected: widget.selected,
        textDirection: widget.textDirection,
        scaler: widget.scaler,
      );
    } else if (widget.selected != oldWidget.selected) {
      style = widget.style.copyWith(selected: widget.selected);
    } else if (widget.style != oldWidget.style) {
      style = widget.style;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (style.layout == null) return SizedBox();
    switch (style.layout!) {
      case PaywallLayoutType.flex:
        return Flex(
          clipBehavior: style.layoutClipBehavior ?? Clip.none,
          crossAxisAlignment:
              style.layoutCrossAxisAlignment ?? CrossAxisAlignment.center,
          direction: style.layoutDirection ?? Axis.vertical,
          mainAxisAlignment:
              style.layoutMainAxisAlignment ?? MainAxisAlignment.start,
          mainAxisSize: style.layoutMainAxisSize ?? MainAxisSize.max,
          spacing: style.layoutSpacing ?? 0,
          textBaseline: style.layoutTextBaseline,
          textDirection: widget.textDirection,
          verticalDirection:
              style.layoutVerticalDirection ?? VerticalDirection.down,
          children: widget.children,
        );
      case PaywallLayoutType.stack:
        return Stack(
          alignment: style.layoutAlignment ?? AlignmentDirectional.topStart,
          clipBehavior: style.layoutClipBehavior ?? Clip.hardEdge,
          fit: style.layoutStackFit ?? StackFit.loose,
          textDirection: widget.textDirection,
          children: widget.children,
        );
      case PaywallLayoutType.wrap:
        return Wrap(
          alignment: style.layoutWrapAlignment ?? WrapAlignment.start,
          clipBehavior: style.layoutClipBehavior ?? Clip.none,
          crossAxisAlignment:
              style.layoutWrapCrossAlignment ?? WrapCrossAlignment.start,
          direction: style.layoutDirection ?? Axis.horizontal,
          spacing: style.layoutSpacing ?? 0,
          runAlignment: style.layoutWrapRunAlignment ?? WrapAlignment.start,
          runSpacing: style.layoutRunSpacing ?? 0,
          textDirection: widget.textDirection,
          verticalDirection:
              style.layoutVerticalDirection ?? VerticalDirection.down,
          children: widget.children,
        );
    }
  }
}
