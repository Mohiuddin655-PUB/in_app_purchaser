import 'dart:ui';

import 'package:flutter/material.dart';

import '../src/paywall.dart'
    show InAppPurchasePaywallStyle, InAppPurchasePaywallScaler;

class InAppPurchasePaywallDecoratedBox extends StatelessWidget {
  final bool? selected;
  final InAppPurchasePaywallStyle style;
  final InAppPurchasePaywallScaler? scaler;
  final TextDirection? textDirection;
  final Widget child;

  const InAppPurchasePaywallDecoratedBox({
    super.key,
    this.selected,
    required this.style,
    this.textDirection,
    this.scaler,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final style = selected != null || scaler != null || textDirection != null
        ? this.style.resolveWith(
              scaler: scaler,
              textDirection: textDirection,
              selected: selected,
            )
        : this.style;

    final duration = Duration(milliseconds: style.duration ?? 0);

    final alignment = style.alignment;
    final position = style.position;

    Widget child = AnimatedContainer(
      duration: duration,
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: style.borderRadius,
        boxShadow: style.boxShadow,
        border: style.border,
        gradient: style.gradient,
        backgroundBlendMode: style.blendMode,
        image: _image != null
            ? DecorationImage(
                image: _image!,
                fit: BoxFit.cover,
                opacity: style.imageOpacity ?? 1,
                scale: style.imageScale ?? 1,
              )
            : null,
      ),
      padding: style.padding,
      margin: style.margin,
      alignment: style.contentAlignment,
      clipBehavior: Clip.antiAlias,
      height: style.height,
      width: style.width,
      child: this.child,
    );
    final opacity = style.opacity ?? 0;
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
    final scale = style.scale;
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
    final blur = style.blur;
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

  ImageProvider? get _image {
    final src = style.image ?? '';
    if (src.isEmpty) return null;
    if (src.startsWith("https")) {
      return NetworkImage(src);
    } else if (src.startsWith("assets")) {
      return AssetImage(src);
    }
    return null;
  }
}
