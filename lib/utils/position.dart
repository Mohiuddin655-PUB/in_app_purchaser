import 'dart:ui';

import 'typedefs.dart';

class PaywallPosition {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double? width;
  final double? height;

  const PaywallPosition({
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.width,
    this.height,
  });

  PaywallPosition copyWith({
    double? width,
    double? height,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return PaywallPosition(
      width: width ?? this.width,
      height: height ?? this.height,
      left: left ?? this.left,
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
    );
  }

  PaywallPosition resolveWith({
    PaywallScaler? scaler,
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

    return PaywallPosition(
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

  @override
  int get hashCode => Object.hash(width, height, top, bottom, left, right);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is PaywallPosition &&
        other.width == width &&
        other.height == height &&
        other.top == top &&
        other.bottom == bottom &&
        other.left == left &&
        other.right == right;
  }

  @override
  String toString() {
    return "$PaywallPosition#$hashCode(width: $width, height: $height, top: $top, bottom: $bottom, left: $left, right: $right)";
  }
}
