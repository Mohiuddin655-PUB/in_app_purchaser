import 'package:flutter/material.dart';

import 'position.dart';
import 'state.dart';
import 'style_parser.dart';
import 'typedefs.dart';

enum PaywallLayoutType { flex, stack, wrap }

class PaywallStyle {
  final bool selected;
  final PaywallState<Alignment?>? alignmentState;
  final PaywallState<Color?>? backgroundColorState;
  final PaywallState<BlendMode?>? blendModeState;
  final PaywallState<double?>? blurState;
  final PaywallState<Border?>? borderState;
  final PaywallState<BorderRadius?>? borderRadiusState;
  final PaywallState<List<BoxShadow>?>? boxShadowState;
  final PaywallState<Color?>? colorState;
  final PaywallState<BoxConstraints?>? constraintsState;
  final PaywallState<Alignment?>? contentAlignmentState;
  final PaywallState<int?>? durationState;
  final PaywallState<int?>? flexState;
  final PaywallState<Color?>? foregroundColorState;
  final PaywallState<LinearGradient?>? foregroundGradientState;
  final PaywallState<LinearGradient?>? gradientState;
  final PaywallState<double?>? heightState;
  final PaywallState<double?>? heightPercentageState;
  final PaywallState<String?>? imageState;
  final PaywallState<double?>? imageOpacityState;
  final PaywallState<double?>? imageScaleState;

  final PaywallState<PaywallLayoutType?>? layoutState;
  final PaywallState<Alignment?>? layoutAlignmentState;
  final PaywallState<Clip?>? layoutClipBehaviorState;
  final PaywallState<CrossAxisAlignment?>? layoutCrossAxisAlignmentState;
  final PaywallState<Axis?>? layoutDirectionState;
  final PaywallState<MainAxisAlignment?>? layoutMainAxisAlignmentState;
  final PaywallState<MainAxisSize?>? layoutMainAxisSizeState;
  final PaywallState<double?>? layoutRunSpacingState;
  final PaywallState<double?>? layoutSpacingState;
  final PaywallState<StackFit?>? layoutStackFitState;
  final PaywallState<TextBaseline?>? layoutTextBaselineState;
  final PaywallState<VerticalDirection?>? layoutVerticalDirectionState;
  final PaywallState<WrapAlignment?>? layoutWrapAlignmentState;
  final PaywallState<WrapAlignment?>? layoutWrapRunAlignmentState;
  final PaywallState<WrapCrossAlignment?>? layoutWrapCrossAlignmentState;

  final PaywallState<EdgeInsets?>? marginState;
  final PaywallState<int?>? maxLinesState;
  final PaywallState<double?>? opacityState;
  final PaywallState<EdgeInsets?>? paddingState;
  final PaywallState<PaywallPosition?>? positionState;
  final PaywallState<double?>? scaleState;
  final PaywallState<double?>? sizeState;
  final PaywallState<TextAlign?>? textAlignState;
  final PaywallState<TextStyle?>? textStyleState;
  final PaywallState<double?>? widthState;
  final PaywallState<double?>? widthPercentageState;

  Alignment? get alignment => alignmentState?.of(selected);

  Color? get backgroundColor => backgroundColorState?.of(selected);

  BlendMode? get blendMode => blendModeState?.of(selected);

  double? get blur => blurState?.of(selected);

  Border? get border => borderState?.of(selected);

  BorderRadius? get borderRadius => borderRadiusState?.of(selected);

  List<BoxShadow>? get boxShadow => boxShadowState?.of(selected);

  Color? get color => colorState?.of(selected);

  BoxConstraints? get constraints => constraintsState?.of(selected);

  Alignment? get contentAlignment => contentAlignmentState?.of(selected);

  int? get duration => durationState?.of(selected);

  int? get flex => flexState?.of(selected);

  Color? get foregroundColor => foregroundColorState?.of(selected);

  LinearGradient? get foregroundGradient {
    return foregroundGradientState?.of(selected);
  }

  LinearGradient? get gradient => gradientState?.of(selected);

  double? get height => heightState?.of(selected);

  double? get heightPercentage => heightPercentageState?.of(selected);

  String? get image => imageState?.of(selected);

  double? get imageOpacity => imageOpacityState?.of(selected);

  double? get imageScale => imageScaleState?.of(selected);

  PaywallLayoutType? get layout => layoutState?.of(selected);

  Alignment? get layoutAlignment => layoutAlignmentState?.of(selected);

  Clip? get layoutClipBehavior => layoutClipBehaviorState?.of(selected);

  CrossAxisAlignment? get layoutCrossAxisAlignment {
    return layoutCrossAxisAlignmentState?.of(selected);
  }

  Axis? get layoutDirection => layoutDirectionState?.of(selected);

  MainAxisAlignment? get layoutMainAxisAlignment {
    return layoutMainAxisAlignmentState?.of(selected);
  }

  MainAxisSize? get layoutMainAxisSize => layoutMainAxisSizeState?.of(selected);

  double? get layoutRunSpacing => layoutRunSpacingState?.of(selected);

  double? get layoutSpacing => layoutSpacingState?.of(selected);

  StackFit? get layoutStackFit => layoutStackFitState?.of(selected);

  TextBaseline? get layoutTextBaseline {
    return layoutTextBaselineState?.of(selected);
  }

  VerticalDirection? get layoutVerticalDirection {
    return layoutVerticalDirectionState?.of(selected);
  }

  WrapAlignment? get layoutWrapAlignment {
    return layoutWrapAlignmentState?.of(selected);
  }

  WrapAlignment? get layoutWrapRunAlignment {
    return layoutWrapRunAlignmentState?.of(selected);
  }

  WrapCrossAlignment? get layoutWrapCrossAlignment {
    return layoutWrapCrossAlignmentState?.of(selected);
  }

  EdgeInsets? get margin => marginState?.of(selected);

  int? get maxLines => maxLinesState?.of(selected);

  double? get opacity => opacityState?.of(selected);

  EdgeInsets? get padding => paddingState?.of(selected);

  PaywallPosition? get position => positionState?.of(selected);

  double? get scale => scaleState?.of(selected);

  double? get size => sizeState?.of(selected);

  TextAlign? get textAlign => textAlignState?.of(selected);

  TextStyle? get textStyle => textStyleState?.of(selected);

  double? get width => widthState?.of(selected);

  double? get widthPercentage => widthPercentageState?.of(selected);

  const PaywallStyle({
    this.selected = false,
    this.alignmentState,
    this.backgroundColorState,
    this.blendModeState,
    this.blurState,
    this.borderState,
    this.borderRadiusState,
    this.boxShadowState,
    this.colorState,
    this.constraintsState,
    this.contentAlignmentState,
    this.durationState,
    this.flexState,
    this.foregroundColorState,
    this.foregroundGradientState,
    this.gradientState,
    this.heightState,
    this.heightPercentageState,
    this.imageState,
    this.imageOpacityState,
    this.imageScaleState,
    this.layoutState,
    this.layoutAlignmentState,
    this.layoutClipBehaviorState,
    this.layoutCrossAxisAlignmentState,
    this.layoutDirectionState,
    this.layoutMainAxisAlignmentState,
    this.layoutMainAxisSizeState,
    this.layoutRunSpacingState,
    this.layoutSpacingState,
    this.layoutStackFitState,
    this.layoutTextBaselineState,
    this.layoutVerticalDirectionState,
    this.layoutWrapAlignmentState,
    this.layoutWrapRunAlignmentState,
    this.layoutWrapCrossAlignmentState,
    this.marginState,
    this.maxLinesState,
    this.opacityState,
    this.paddingState,
    this.positionState,
    this.scaleState,
    this.sizeState,
    this.textAlignState,
    this.textStyleState,
    this.widthState,
    this.widthPercentageState,
  });

  Map<String, dynamic> get dictionary {
    final entries = {
      "alignment": alignmentState?.toJson(StyleParser.alignmentToJson),
      "backgroundColor": backgroundColorState?.toJson(StyleParser.colorToHex),
      "blendMode": blendModeState?.toJson(StyleParser.enumToJson),
      "blur": blurState?.toJson((e) => e),
      "border": borderState?.toJson(StyleParser.borderToJson),
      "borderRadius": borderRadiusState?.toJson(StyleParser.borderRadiusToJson),
      "boxShadow": boxShadowState?.toJson(StyleParser.boxShadowToJson),
      "color": colorState?.toJson(StyleParser.colorToHex),
      "constraints": constraintsState?.toJson(StyleParser.boxConstraintsToJson),
      "contentAlignment":
          contentAlignmentState?.toJson(StyleParser.alignmentToJson),
      "duration": durationState?.toJson((e) => e),
      "flex": flexState?.toJson((e) => e),
      "foregroundColor": foregroundColorState?.toJson(StyleParser.colorToHex),
      "foregroundGradient":
          foregroundGradientState?.toJson(StyleParser.gradientToJson),
      "gradient": gradientState?.toJson(StyleParser.gradientToJson),
      "height": heightState?.toJson(StyleParser.safeEncodableDouble),
      "heightPercentage": heightPercentageState?.toJson((e) => e),
      "image": imageState?.toJson((e) => e),
      "imageOpacity": imageOpacityState?.toJson((e) => e),
      "imageScale": imageScaleState?.toJson((e) => e),
      "layout": layoutState?.toJson(StyleParser.enumToJson),
      "layoutAlignment":
          layoutAlignmentState?.toJson(StyleParser.alignmentToJson),
      "layoutClipBehavior":
          layoutClipBehaviorState?.toJson(StyleParser.enumToJson),
      "layoutCrossAxisAlignment":
          layoutCrossAxisAlignmentState?.toJson(StyleParser.enumToJson),
      "layoutDirection": layoutDirectionState?.toJson(StyleParser.enumToJson),
      "layoutMainAxisAlignment":
          layoutMainAxisAlignmentState?.toJson(StyleParser.enumToJson),
      "layoutMainAxisSize":
          layoutMainAxisSizeState?.toJson(StyleParser.enumToJson),
      "layoutRunSpacing": layoutRunSpacingState?.toJson((e) => e),
      "layoutSpacing": layoutSpacingState?.toJson((e) => e),
      "layoutStackFit": layoutStackFitState?.toJson(StyleParser.enumToJson),
      "layoutTextBaseline":
          layoutTextBaselineState?.toJson(StyleParser.enumToJson),
      "layoutVerticalDirection":
          layoutVerticalDirectionState?.toJson(StyleParser.enumToJson),
      "layoutWrapAlignment":
          layoutWrapAlignmentState?.toJson(StyleParser.enumToJson),
      "layoutWrapRunAlignment":
          layoutWrapRunAlignmentState?.toJson(StyleParser.enumToJson),
      "layoutWrapCrossAlignment":
          layoutWrapCrossAlignmentState?.toJson(StyleParser.enumToJson),
      "margin": marginState?.toJson(StyleParser.edgeInsetsToJson),
      "maxLines": maxLinesState?.toJson((e) => e),
      "opacity": opacityState?.toJson((e) => e),
      "padding": paddingState?.toJson(StyleParser.edgeInsetsToJson),
      "position": positionState?.toJson((e) => e?.dictionary),
      "scale": scaleState?.toJson((e) => e),
      "size": sizeState?.toJson((e) => e),
      "textAlign": textAlignState?.toJson(StyleParser.enumToJson),
      "textStyle": textStyleState?.toJson(StyleParser.textStyleToJson),
      "width": widthState?.toJson(StyleParser.safeEncodableDouble),
      "widthPercentage": widthPercentageState?.toJson((e) => e),
    }.entries.where((e) => e.value != null);
    return Map.fromEntries(entries);
  }

  static PaywallStyle? parse<T>(Object? source, bool dark) {
    if (source is! Map || source.isEmpty) return null;
    return PaywallStyle(
      selected: false,
      alignmentState: PaywallState.parse(
        source['alignment'],
        StyleParser.parseAlignment,
      ),
      backgroundColorState: PaywallState.parse(
        source['backgroundColor'],
        (value) => StyleParser.parseThemedColor(value, dark),
      ),
      blendModeState: PaywallState.parse(
        source['blendMode'],
        StyleParser.parseBlendMode,
      ),
      blurState: PaywallState.parse(
        source['blur'],
        StyleParser.parseDouble,
      ),
      borderState: PaywallState.parse(
        source['border'],
        (value) => StyleParser.parseBorder(value, dark),
      ),
      borderRadiusState: PaywallState.parse(
        source['borderRadius'],
        StyleParser.parseBorderRadius,
      ),
      boxShadowState: PaywallState.parse(source['boxShadow'], (v) {
        return StyleParser.parseList(
            v, (e) => StyleParser.parseBoxShadow(e, dark));
      }),
      colorState: PaywallState.parse(
        source['color'],
        (value) => StyleParser.parseThemedColor(value, dark),
      ),
      constraintsState: PaywallState.parse(
        source['constraints'],
        StyleParser.parseBoxConstraints,
      ),
      contentAlignmentState: PaywallState.parse(
        source['contentAlignment'],
        StyleParser.parseAlignment,
      ),
      durationState: PaywallState.parse(
        source['duration'],
        StyleParser.parseInt,
      ),
      flexState: PaywallState.parse(
        source['flex'],
        StyleParser.parseInt,
      ),
      foregroundColorState: PaywallState.parse(
        source['foregroundColor'],
        (value) => StyleParser.parseThemedColor(value, dark),
      ),
      foregroundGradientState: PaywallState.parse(
        source['foregroundGradient'],
        (value) => StyleParser.parseGradient(value, dark),
      ),
      gradientState: PaywallState.parse(
        source['gradient'],
        (value) => StyleParser.parseGradient(value, dark),
      ),
      heightState: PaywallState.parse(
        source['height'],
        StyleParser.parseDouble,
      ),
      heightPercentageState: PaywallState.parse(
        source['heightPercentage'],
        StyleParser.parseDouble,
      ),
      imageState: PaywallState.parse(
        source['image'],
        StyleParser.parseString,
      ),
      imageOpacityState: PaywallState.parse(
        source['imageOpacity'],
        StyleParser.parseDouble,
      ),
      imageScaleState: PaywallState.parse(
        source['imageScale'],
        StyleParser.parseDouble,
      ),
      layoutState: PaywallState.parse(
        source['layout'],
        (source) => StyleParser.parseEnum(source, PaywallLayoutType.values),
      ),
      layoutAlignmentState: PaywallState.parse(
        source['layoutAlignment'],
        StyleParser.parseAlignment,
      ),
      layoutClipBehaviorState: PaywallState.parse(
        source['layoutClipBehavior'],
        (source) => StyleParser.parseEnum(source, Clip.values),
      ),
      layoutCrossAxisAlignmentState: PaywallState.parse(
        source['layoutCrossAxisAlignment'],
        (source) => StyleParser.parseEnum(source, CrossAxisAlignment.values),
      ),
      layoutDirectionState: PaywallState.parse(
        source['layoutDirection'],
        (source) => StyleParser.parseEnum(source, Axis.values),
      ),
      layoutMainAxisAlignmentState: PaywallState.parse(
        source['layoutMainAxisAlignment'],
        (source) => StyleParser.parseEnum(source, MainAxisAlignment.values),
      ),
      layoutMainAxisSizeState: PaywallState.parse(
        source['layoutMainAxisSize'],
        (source) => StyleParser.parseEnum(source, MainAxisSize.values),
      ),
      layoutRunSpacingState: PaywallState.parse(
        source['layoutRunSpacing'],
        StyleParser.parseDouble,
      ),
      layoutSpacingState: PaywallState.parse(
        source['layoutSpacing'],
        StyleParser.parseDouble,
      ),
      layoutStackFitState: PaywallState.parse(
        source['layoutStackFit'],
        (source) => StyleParser.parseEnum(source, StackFit.values),
      ),
      layoutTextBaselineState: PaywallState.parse(
        source['layoutTextBaseline'],
        (source) => StyleParser.parseEnum(source, TextBaseline.values),
      ),
      layoutVerticalDirectionState: PaywallState.parse(
        source['layoutVerticalDirection'],
        (source) => StyleParser.parseEnum(source, VerticalDirection.values),
      ),
      layoutWrapAlignmentState: PaywallState.parse(
        source['layoutWrapAlignment'],
        (source) => StyleParser.parseEnum(source, WrapAlignment.values),
      ),
      layoutWrapRunAlignmentState: PaywallState.parse(
        source['layoutWrapRunAlignment'],
        (source) => StyleParser.parseEnum(source, WrapAlignment.values),
      ),
      layoutWrapCrossAlignmentState: PaywallState.parse(
        source['layoutWrapCrossAlignment'],
        (source) => StyleParser.parseEnum(source, WrapCrossAlignment.values),
      ),
      marginState: PaywallState.parse(
        source['margin'],
        StyleParser.parseEdgeInsets,
      ),
      maxLinesState: PaywallState.parse(
        source['maxLines'],
        StyleParser.parseInt,
      ),
      opacityState: PaywallState.parse(
        source['opacity'],
        StyleParser.parseDouble,
      ),
      paddingState: PaywallState.parse(
        source['padding'],
        StyleParser.parseEdgeInsets,
      ),
      positionState: PaywallState.parse(
        source['position'],
        StyleParser.parsePosition,
      ),
      scaleState: PaywallState.parse(
        source['scale'],
        StyleParser.parseDouble,
      ),
      sizeState: PaywallState.parse(
        source['size'],
        StyleParser.parseDouble,
      ),
      textAlignState: PaywallState.parse(
        source['textAlign'],
        StyleParser.parseTextAlign,
      ),
      textStyleState: PaywallState.parse(
        source['textStyle'],
        (value) => StyleParser.parseTextStyle(value, dark),
      ),
      widthState: PaywallState.parse(
        source['width'],
        StyleParser.parseDouble,
      ),
      widthPercentageState: PaywallState.parse(
        source['widthPercentage'],
        StyleParser.parseDouble,
      ),
    );
  }

  PaywallStyle copyWith({
    bool? selected,
    PaywallState<Alignment?>? alignmentState,
    PaywallState<Color?>? backgroundColorState,
    PaywallState<BlendMode?>? blendModeState,
    PaywallState<double?>? blurState,
    PaywallState<Border?>? borderState,
    PaywallState<BorderRadius?>? borderRadiusState,
    PaywallState<List<BoxShadow>?>? boxShadowState,
    PaywallState<Color?>? colorState,
    PaywallState<BoxConstraints?>? constraintsState,
    PaywallState<Alignment?>? contentAlignmentState,
    PaywallState<int?>? durationState,
    PaywallState<int?>? flexState,
    PaywallState<Color?>? foregroundColorState,
    PaywallState<LinearGradient?>? foregroundGradientState,
    PaywallState<LinearGradient?>? gradientState,
    PaywallState<double?>? heightState,
    PaywallState<double?>? heightPercentageState,
    PaywallState<String?>? imageState,
    PaywallState<double?>? imageOpacityState,
    PaywallState<double?>? imageScaleState,
    PaywallState<PaywallLayoutType?>? layoutState,
    PaywallState<Alignment?>? layoutAlignmentState,
    PaywallState<Clip?>? layoutClipBehaviorState,
    PaywallState<CrossAxisAlignment?>? layoutCrossAxisAlignmentState,
    PaywallState<Axis?>? layoutDirectionState,
    PaywallState<MainAxisAlignment?>? layoutMainAxisAlignmentState,
    PaywallState<MainAxisSize?>? layoutMainAxisSizeState,
    PaywallState<double?>? layoutRunSpacingState,
    PaywallState<double?>? layoutSpacingState,
    PaywallState<StackFit?>? layoutStackFitState,
    PaywallState<TextBaseline?>? layoutTextBaselineState,
    PaywallState<VerticalDirection?>? layoutVerticalDirectionState,
    PaywallState<WrapAlignment?>? layoutWrapAlignmentState,
    PaywallState<WrapAlignment?>? layoutWrapRunAlignmentState,
    PaywallState<WrapCrossAlignment?>? layoutWrapCrossAlignmentState,
    PaywallState<EdgeInsets?>? marginState,
    PaywallState<int?>? maxLinesState,
    PaywallState<double?>? opacityState,
    PaywallState<EdgeInsets?>? paddingState,
    PaywallState<PaywallPosition?>? positionState,
    PaywallState<double?>? scaleState,
    PaywallState<double?>? sizeState,
    PaywallState<TextAlign?>? textAlignState,
    PaywallState<TextStyle?>? textStyleState,
    PaywallState<double?>? widthState,
    PaywallState<double?>? widthPercentageState,
  }) {
    return PaywallStyle(
      selected: selected ?? this.selected,
      alignmentState: alignmentState ?? this.alignmentState,
      backgroundColorState: backgroundColorState ?? this.backgroundColorState,
      blendModeState: blendModeState ?? this.blendModeState,
      blurState: blurState ?? this.blurState,
      borderState: borderState ?? this.borderState,
      borderRadiusState: borderRadiusState ?? this.borderRadiusState,
      boxShadowState: boxShadowState ?? this.boxShadowState,
      colorState: colorState ?? this.colorState,
      constraintsState: constraintsState ?? this.constraintsState,
      contentAlignmentState:
          contentAlignmentState ?? this.contentAlignmentState,
      durationState: durationState ?? this.durationState,
      flexState: flexState ?? this.flexState,
      foregroundColorState: foregroundColorState ?? this.foregroundColorState,
      foregroundGradientState:
          foregroundGradientState ?? this.foregroundGradientState,
      gradientState: gradientState ?? this.gradientState,
      heightState: heightState ?? this.heightState,
      heightPercentageState:
          heightPercentageState ?? this.heightPercentageState,
      imageState: imageState ?? this.imageState,
      imageOpacityState: imageOpacityState ?? this.imageOpacityState,
      imageScaleState: imageScaleState ?? this.imageScaleState,
      layoutState: layoutState ?? this.layoutState,
      layoutAlignmentState: layoutAlignmentState ?? this.layoutAlignmentState,
      layoutClipBehaviorState:
          layoutClipBehaviorState ?? this.layoutClipBehaviorState,
      layoutCrossAxisAlignmentState:
          layoutCrossAxisAlignmentState ?? this.layoutCrossAxisAlignmentState,
      layoutDirectionState: layoutDirectionState ?? this.layoutDirectionState,
      layoutMainAxisAlignmentState:
          layoutMainAxisAlignmentState ?? this.layoutMainAxisAlignmentState,
      layoutMainAxisSizeState:
          layoutMainAxisSizeState ?? this.layoutMainAxisSizeState,
      layoutRunSpacingState:
          layoutRunSpacingState ?? this.layoutRunSpacingState,
      layoutSpacingState: layoutSpacingState ?? this.layoutSpacingState,
      layoutStackFitState: layoutStackFitState ?? this.layoutStackFitState,
      layoutTextBaselineState:
          layoutTextBaselineState ?? this.layoutTextBaselineState,
      layoutVerticalDirectionState:
          layoutVerticalDirectionState ?? this.layoutVerticalDirectionState,
      layoutWrapAlignmentState:
          layoutWrapAlignmentState ?? this.layoutWrapAlignmentState,
      layoutWrapRunAlignmentState:
          layoutWrapRunAlignmentState ?? this.layoutWrapRunAlignmentState,
      layoutWrapCrossAlignmentState:
          layoutWrapCrossAlignmentState ?? this.layoutWrapCrossAlignmentState,
      marginState: marginState ?? this.marginState,
      maxLinesState: maxLinesState ?? this.maxLinesState,
      opacityState: opacityState ?? this.opacityState,
      paddingState: paddingState ?? this.paddingState,
      positionState: positionState ?? this.positionState,
      scaleState: scaleState ?? this.scaleState,
      sizeState: sizeState ?? this.sizeState,
      textAlignState: textAlignState ?? this.textAlignState,
      textStyleState: textStyleState ?? this.textStyleState,
      widthState: widthState ?? this.widthState,
      widthPercentageState: widthPercentageState ?? this.widthPercentageState,
    );
  }

  PaywallStyle resolveWith({
    bool? selected,
    PaywallScaler? scaler,
    TextDirection? textDirection,
  }) {
    double? dp(double? value) {
      if (value == null || value == 0 || value.isInfinite) return value;
      if (scaler == null) return value;
      return scaler(value);
    }

    T td<T>(T a, T b) {
      if (textDirection == null) return a;
      return textDirection == TextDirection.rtl ? b : a;
    }

    Offset? resolveOffset(Offset? e) {
      if (e == null) return null;
      return Offset(dp(e.dx) ?? 0, dp(e.dy) ?? 0);
    }

    Alignment? resolveAlignment(Alignment? e) {
      if (e == null || textDirection == null) return e;
      if (textDirection == TextDirection.ltr) return e;
      return Alignment(-e.x, e.y);
    }

    EdgeInsets? resolveEdge(EdgeInsets? e) {
      if (e == null) return null;
      return e.copyWith(
        left: dp(td(e.left, e.right)),
        right: dp(td(e.right, e.left)),
        top: dp(e.top),
        bottom: dp(e.bottom),
      );
    }

    return copyWith(
      selected: selected,
      alignmentState: alignmentState?.resolveWith(resolveAlignment),
      contentAlignmentState:
          contentAlignmentState?.resolveWith(resolveAlignment),
      widthState: widthState?.resolveWith(dp),
      heightState: heightState?.resolveWith(dp),
      blurState: blurState?.resolveWith(dp),
      borderState: borderState?.resolveWith((e) {
        if (e == null) return null;
        BorderSide resolve(BorderSide s) => s.copyWith(width: dp(s.width));
        return Border(
          top: resolve(e.top),
          bottom: resolve(e.bottom),
          left: resolve(td(e.left, e.right)),
          right: resolve(td(e.right, e.left)),
        );
      }),
      borderRadiusState: borderRadiusState?.resolveWith((value) {
        if (value == null) return null;
        Radius resolve(Radius e) {
          return Radius.elliptical(dp(e.x) ?? 0, dp(e.y) ?? 0);
        }

        return value.copyWith(
          topLeft: resolve(td(value.topLeft, value.topRight)),
          topRight: resolve(td(value.topRight, value.topLeft)),
          bottomRight: resolve(td(value.bottomRight, value.bottomLeft)),
          bottomLeft: resolve(td(value.bottomLeft, value.bottomRight)),
        );
      }),
      boxShadowState: boxShadowState?.resolveWith((values) {
        return values?.map((value) {
          return value.copyWith(
            offset: resolveOffset(value.offset),
            blurRadius: dp(value.blurRadius),
            spreadRadius: dp(value.spreadRadius),
          );
        }).toList();
      }),
      constraintsState: constraintsState?.resolveWith((e) {
        if (e == null) return null;
        return e.copyWith(
          minWidth: dp(e.minWidth),
          maxWidth: dp(e.maxWidth),
          minHeight: dp(e.minHeight),
          maxHeight: dp(e.maxHeight),
        );
      }),
      marginState: marginState?.resolveWith(resolveEdge),
      paddingState: paddingState?.resolveWith(resolveEdge),
      positionState: positionState?.resolveWith((value) {
        return value?.resolveWith(
          scaler: scaler,
          textDirection: textDirection,
        );
      }),
      foregroundGradientState: foregroundGradientState?.resolveWith((e) {
        if (e == null || e.colors.length < 2) return null;
        final begin = e.begin;
        final end = e.end;
        return LinearGradient(
          begin: begin is Alignment ? resolveAlignment(begin) ?? begin : begin,
          end: end is Alignment ? resolveAlignment(end) ?? end : end,
          colors: e.colors,
          stops: e.stops,
          tileMode: e.tileMode,
          transform: e.transform,
        );
      }),
      gradientState: gradientState?.resolveWith((e) {
        if (e == null || e.colors.length < 2) return null;
        final begin = e.begin;
        final end = e.end;
        return LinearGradient(
          begin: begin is Alignment ? resolveAlignment(begin) ?? begin : begin,
          end: end is Alignment ? resolveAlignment(end) ?? end : end,
          colors: e.colors,
          stops: e.stops,
          tileMode: e.tileMode,
          transform: e.transform,
        );
      }),
      sizeState: sizeState?.resolveWith(dp),
      textStyleState: textStyleState?.resolveWith((value) {
        return value?.copyWith(
          fontSize: dp(value.fontSize),
          decorationThickness: dp(value.decorationThickness),
        );
      }),
      layoutAlignmentState: layoutAlignmentState?.resolveWith(resolveAlignment),
      layoutCrossAxisAlignmentState:
          layoutCrossAxisAlignmentState?.resolveWith((e) {
        if (e == null) return null;
        switch (e) {
          case CrossAxisAlignment.start:
            return td(CrossAxisAlignment.start, CrossAxisAlignment.end);
          case CrossAxisAlignment.end:
            return td(CrossAxisAlignment.end, CrossAxisAlignment.start);
          default:
            return e;
        }
      }),
      layoutRunSpacingState: layoutRunSpacingState?.resolveWith(dp),
      layoutSpacingState: layoutSpacingState?.resolveWith(dp),
      layoutWrapCrossAlignmentState:
          layoutWrapCrossAlignmentState?.resolveWith((e) {
        if (e == null) return null;
        switch (e) {
          case WrapCrossAlignment.start:
            return td(WrapCrossAlignment.start, WrapCrossAlignment.end);
          case WrapCrossAlignment.end:
            return td(WrapCrossAlignment.end, WrapCrossAlignment.start);
          default:
            return e;
        }
      }),
    );
  }

  @override
  int get hashCode {
    return Object.hashAll([
      selected,
      alignmentState,
      backgroundColorState,
      blendModeState,
      blurState,
      borderState,
      borderRadiusState,
      boxShadowState,
      colorState,
      constraintsState,
      contentAlignmentState,
      durationState,
      flexState,
      foregroundColorState,
      foregroundGradientState,
      gradientState,
      heightState,
      heightPercentageState,
      imageState,
      imageOpacityState,
      imageScaleState,
      layoutState,
      layoutAlignmentState,
      layoutClipBehaviorState,
      layoutCrossAxisAlignmentState,
      layoutDirectionState,
      layoutMainAxisAlignmentState,
      layoutMainAxisSizeState,
      layoutRunSpacingState,
      layoutSpacingState,
      layoutStackFitState,
      layoutTextBaselineState,
      layoutVerticalDirectionState,
      layoutWrapAlignmentState,
      layoutWrapRunAlignmentState,
      layoutWrapCrossAlignmentState,
      marginState,
      maxLinesState,
      opacityState,
      paddingState,
      positionState,
      scaleState,
      sizeState,
      textAlignState,
      textStyleState,
      widthState,
      widthPercentageState,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is PaywallStyle &&
        selected == other.selected &&
        alignmentState == other.alignmentState &&
        backgroundColorState == other.backgroundColorState &&
        blendModeState == other.blendModeState &&
        blurState == other.blurState &&
        borderState == other.borderState &&
        borderRadiusState == other.borderRadiusState &&
        boxShadowState == other.boxShadowState &&
        colorState == other.colorState &&
        constraintsState == other.constraintsState &&
        contentAlignmentState == other.contentAlignmentState &&
        durationState == other.durationState &&
        flexState == other.flexState &&
        foregroundColorState == other.foregroundColorState &&
        foregroundGradientState == other.foregroundGradientState &&
        gradientState == other.gradientState &&
        heightState == other.heightState &&
        heightPercentageState == other.heightPercentageState &&
        imageState == other.imageState &&
        imageOpacityState == other.imageOpacityState &&
        imageScaleState == other.imageScaleState &&
        layoutState == other.layoutState &&
        layoutAlignmentState == other.layoutAlignmentState &&
        layoutClipBehaviorState == other.layoutClipBehaviorState &&
        layoutCrossAxisAlignmentState == other.layoutCrossAxisAlignmentState &&
        layoutDirectionState == other.layoutDirectionState &&
        layoutMainAxisAlignmentState == other.layoutMainAxisAlignmentState &&
        layoutMainAxisSizeState == other.layoutMainAxisSizeState &&
        layoutRunSpacingState == other.layoutRunSpacingState &&
        layoutSpacingState == other.layoutSpacingState &&
        layoutStackFitState == other.layoutStackFitState &&
        layoutTextBaselineState == other.layoutTextBaselineState &&
        layoutVerticalDirectionState == other.layoutVerticalDirectionState &&
        layoutWrapAlignmentState == other.layoutWrapAlignmentState &&
        layoutWrapRunAlignmentState == other.layoutWrapRunAlignmentState &&
        layoutWrapCrossAlignmentState == other.layoutWrapCrossAlignmentState &&
        marginState == other.marginState &&
        maxLinesState == other.maxLinesState &&
        opacityState == other.opacityState &&
        paddingState == other.paddingState &&
        positionState == other.positionState &&
        scaleState == other.scaleState &&
        sizeState == other.sizeState &&
        textAlignState == other.textAlignState &&
        textStyleState == other.textStyleState &&
        widthState == other.widthState &&
        widthPercentageState == other.widthPercentageState;
  }

  @override
  String toString() => "$PaywallStyle#$hashCode";
}
