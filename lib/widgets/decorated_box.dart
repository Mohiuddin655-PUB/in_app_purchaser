import 'dart:ui';

import 'package:flutter/material.dart';

import '../utils/style.dart';
import '../utils/typedefs.dart';

class PaywallDecoratedBox extends StatelessWidget {
  final bool primary;
  final bool? selected;
  final PaywallStyle? style;
  final PaywallScaler? scaler;
  final Size? screenSize;
  final TextDirection? textDirection;
  final Widget child;

  const PaywallDecoratedBox({
    super.key,
    this.primary = true,
    this.selected,
    this.style,
    this.textDirection,
    this.scaler,
    this.screenSize,
    required this.child,
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

  ImageProvider? _image(String? src) {
    src ??= '';
    if (src.isEmpty) return null;
    if (src.startsWith("https")) {
      return NetworkImage(src);
    } else if (src.startsWith("assets")) {
      return AssetImage(src);
    }
    return null;
  }

  Widget _build(BuildContext context, PaywallStyle s) {
    final duration = Duration(milliseconds: s.duration ?? 0);

    final isBackgroundImage = (s.image ?? '').isNotEmpty;
    final blur = s.blur ?? 0;

    final alignment = s.alignment;
    final position = s.position;

    double? heightOrWidth(int type) {
      final a = type == 0 ? s.height : s.width;
      final b = type == 0 ? s.heightPercentage : s.widthPercentage;
      if (a != null) return a;
      if (b == null) return null;
      final c = screenSize ?? MediaQuery.sizeOf(context);
      return (type == 0 ? c.height : c.width) * b;
    }

    Widget child = AnimatedContainer(
      duration: duration,
      constraints: s.constraints,
      decoration: BoxDecoration(
        color: s.backgroundColor,
        borderRadius: blur > 0 ? null : s.borderRadius,
        boxShadow: s.boxShadow,
        border: s.border,
        gradient: s.gradient,
        backgroundBlendMode: s.blendMode,
        image: isBackgroundImage
            ? DecorationImage(
                image: _image(s.image)!,
                fit: BoxFit.cover,
                opacity: s.imageOpacity ?? 1,
                scale: s.imageScale ?? 1,
              )
            : null,
      ),
      foregroundDecoration: isBackgroundImage
          ? null
          : BoxDecoration(
              color: s.foregroundColor,
              gradient: s.foregroundGradient,
            ),
      padding: s.padding,
      margin: s.margin,
      alignment: s.contentAlignment,
      clipBehavior: Clip.antiAlias,
      height: heightOrWidth(0),
      width: heightOrWidth(1),
      child: this.child,
    );
    final opacity = s.opacity ?? 0.0;
    if (opacity > 0) {
      if (duration != Duration.zero) {
        child = AnimatedOpacity(
          opacity: opacity,
          duration: duration,
          child: child,
        );
      } else {
        child = Opacity(
          opacity: opacity,
          child: child,
        );
      }
    }
    final scale = s.scale;
    if (scale != null) {
      if (duration != Duration.zero) {
        child = AnimatedScale(
          scale: scale,
          duration: duration,
          child: child,
        );
      } else {
        child = Transform.scale(
          scale: scale,
          child: child,
        );
      }
    }
    if (blur > 0) {
      if (isBackgroundImage) {
        child = Stack(
          children: [
            child,
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: s.foregroundColor,
                    gradient: s.foregroundGradient,
                  ),
                ),
              ),
            ),
          ],
        );
      } else {
        child = BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: child,
        );
      }
      child = ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: s.borderRadius ?? BorderRadius.zero,
        child: child,
      );
    }
    if (s.center ?? false) {
      child = Center(child: child);
    }
    if (s.overflow ?? false) {
      child = OverflowBox(child: child);
    }
    final expanded = s.expanded ?? 0;
    if (expanded > 0) {
      child = Expanded(flex: expanded, child: child);
    }
    final flex = s.flex ?? 0;
    if (flex > 0) {
      child = Flexible(flex: flex, child: child);
    }
    if (position != null) {
      if (duration != Duration.zero) {
        child = AnimatedPositioned(
          top: position.top,
          right: position.right,
          left: position.left,
          bottom: position.bottom,
          width: position.width,
          height: position.height,
          duration: duration,
          child: child,
        );
      } else {
        child = Positioned(
          top: position.top,
          right: position.right,
          left: position.left,
          bottom: position.bottom,
          width: position.width,
          height: position.height,
          child: child,
        );
      }
    }
    if (alignment != null) {
      child = AnimatedAlign(
        alignment: alignment,
        duration: duration,
        child: child,
      );
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;
    if (style == null) return child;
    return _build(context, style);
  }
}
