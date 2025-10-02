import 'dart:ui';

import 'package:flutter/material.dart';

import '../utils/style.dart';
import '../utils/typedefs.dart';

class PaywallDecoratedBox extends StatefulWidget {
  final bool? selected;
  final PaywallStyle style;
  final PaywallScaler? scaler;
  final TextDirection? textDirection;
  final Widget child;

  const PaywallDecoratedBox({
    super.key,
    this.selected,
    required this.style,
    this.textDirection,
    this.scaler,
    required this.child,
  });

  @override
  State<PaywallDecoratedBox> createState() => _PaywallDecoratedBoxState();
}

class _PaywallDecoratedBoxState extends State<PaywallDecoratedBox> {
  late PaywallStyle style;

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
  void didUpdateWidget(covariant PaywallDecoratedBox oldWidget) {
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
    final duration = Duration(milliseconds: style.duration ?? 0);

    final alignment = style.alignment;
    final position = style.position;

    Widget child = AnimatedContainer(
      duration: duration,
      constraints: style.constraints,
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
      child: widget.child,
    );
    final opacity = style.opacity ?? 0.0;
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
}
