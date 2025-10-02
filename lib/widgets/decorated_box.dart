import 'dart:ui';

import 'package:flutter/material.dart';

import '../utils/style.dart';
import '../utils/typedefs.dart';

class PaywallDecoratedBox extends StatelessWidget {
  final bool primary;
  final bool? selected;
  final PaywallStyle? style;
  final PaywallScaler? scaler;
  final TextDirection? textDirection;
  final Widget child;

  const PaywallDecoratedBox({
    super.key,
    this.primary = true,
    this.selected,
    this.style,
    this.textDirection,
    this.scaler,
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

    final alignment = s.alignment;
    final position = s.position;

    Widget child = AnimatedContainer(
      duration: duration,
      constraints: s.constraints,
      decoration: BoxDecoration(
        color: s.backgroundColor,
        borderRadius: s.borderRadius,
        boxShadow: s.boxShadow,
        border: s.border,
        gradient: s.gradient,
        backgroundBlendMode: s.blendMode,
        image: (s.image ?? '').isNotEmpty
            ? DecorationImage(
                image: _image(s.image)!,
                fit: BoxFit.cover,
                opacity: s.imageOpacity ?? 1,
                scale: s.imageScale ?? 1,
              )
            : null,
      ),
      padding: s.padding,
      margin: s.margin,
      alignment: s.contentAlignment,
      clipBehavior: Clip.antiAlias,
      height: s.height,
      width: s.width,
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
    final blur = s.blur;
    if (blur != null && blur > 0) {
      child = ClipRect(
        clipBehavior: Clip.antiAlias,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: child,
        ),
      );
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
