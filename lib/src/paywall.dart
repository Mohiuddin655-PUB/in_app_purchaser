import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../utils/localized_content.dart';
import '../utils/style.dart';
import '../utils/text_button.dart';
import '../utils/typedefs.dart';
import 'offering.dart';
import 'paywall_product.dart';
import 'purchaser.dart';

const _equality = DeepCollectionEquality();

class Paywall {
  final String id;
  final Map configs;
  final bool defaultMode;
  final List<PaywallProduct> products;

  final int? initialIndex;
  final String? designType;
  final bool? skipMode;
  final bool? safeArea;

  final PaywallLocalizedContent<String?>? hero;
  final PaywallLocalizedContent<String?>? image;
  final PaywallLocalizedContent<String?>? title;
  final PaywallLocalizedContent<String?>? subtitle;
  final PaywallLocalizedContent<List?>? features;
  final List<PaywallTextButtonContent>? textButtons;

  final PaywallStyle? style;
  final PaywallStyle? heroStyle;
  final PaywallStyle? blurStyle;

  final PaywallStyle? headerStyle;
  final PaywallStyle? bodyStyle;
  final PaywallStyle? footerStyle;

  final PaywallStyle? imageStyle;
  final PaywallStyle? titleStyle;
  final PaywallStyle? subtitleStyle;
  final PaywallStyle? featureStyle;
  final PaywallStyle? featuresStyle;

  final PaywallStyle? closeButtonStyle;
  final PaywallStyle? textButtonStyle;
  final PaywallStyle? textButtonsStyle;

  const Paywall({
    this.id = '',
    this.products = const [],
    this.configs = const {},
    this.defaultMode = true,
    this.initialIndex,
    this.designType,
    this.safeArea,
    this.skipMode,
    this.hero,
    this.image,
    this.title,
    this.subtitle,
    this.features,
    this.textButtons,
    this.style,
    this.heroStyle,
    this.blurStyle,
    this.headerStyle,
    this.bodyStyle,
    this.footerStyle,
    this.imageStyle,
    this.titleStyle,
    this.subtitleStyle,
    this.featureStyle,
    this.featuresStyle,
    this.closeButtonStyle,
    this.textButtonStyle,
    this.textButtonsStyle,
  });

  String? get heroLocalized => hero?.value;

  String? get imageLocalized => image?.value;

  String? get titleLocalized => title?.value;

  String? get subtitleLocalized => subtitle?.value;

  List? get featuresLocalized => features?.value;

  Map<String, dynamic> get dictionary {
    Map<String, dynamic> map = {};

    void addObject(String key, Object? value) {
      if (value == null) return;
      map[key] = value;
    }

    void addDictionary(String key, Map? value) {
      if (value == null || value.isEmpty) return;
      map[key] = value;
    }

    void addList(String key, List? value) {
      if (value == null || value.isEmpty) return;
      map[key] = value;
    }

    addObject("initialIndex", initialIndex);
    addObject("designType", designType);
    addObject("safeArea", safeArea);
    addObject("skipMode", skipMode);
    addObject("hero", hero?.toJson((e) => e));
    addObject("image", image?.toJson((e) => e));
    addObject("title", title?.toJson((e) => e));
    addObject("subtitle", subtitle?.toJson((e) => e));
    addObject("features", features?.toJson((e) {
      if (e == null || e.isEmpty) return null;
      return e;
    }));

    addList(
      "textButtons",
      textButtons?.map((e) => e.dictionary).where((e) => e.isNotEmpty).toList(),
    );

    addDictionary("style", style?.dictionary);
    addDictionary("heroStyle", heroStyle?.dictionary);
    addDictionary("blurStyle", blurStyle?.dictionary);

    addDictionary("headerStyle", headerStyle?.dictionary);
    addDictionary("bodyStyle", bodyStyle?.dictionary);
    addDictionary("footerStyle", footerStyle?.dictionary);

    addDictionary("imageStyle", imageStyle?.dictionary);
    addDictionary("titleStyle", titleStyle?.dictionary);
    addDictionary("subtitleStyle", subtitleStyle?.dictionary);
    addDictionary("featureStyle", featureStyle?.dictionary);
    addDictionary("featuresStyle", featuresStyle?.dictionary);

    addDictionary("closeButtonStyle", closeButtonStyle?.dictionary);
    addDictionary("textButtonStyle", textButtonStyle?.dictionary);
    addDictionary("textButtonsStyle", textButtonsStyle?.dictionary);

    addList(
      "products",
      products.map((e) => e.dictionary).where((e) => e.isNotEmpty).toList(),
    );
    return map;
  }

  factory Paywall.fromOffering(
    InAppPurchaseOffering offering, {
    bool? dark,
    bool? stringifyAll,
  }) {
    return Paywall.parse(
      placement: offering.id,
      configs: offering.configs,
      packages: offering.products,
      dark: dark ?? false,
      stringifyAll: stringifyAll,
    );
  }

  factory Paywall.parse({
    required String placement,
    required Map<String, dynamic> configs,
    required List<InAppPurchaseProduct> packages,
    bool dark = false,
    bool? stringifyAll,
  }) {
    final parser = InAppPurchaser.parseConfig;

    final products = parser<List?>(configs["products"], null);

    final mProducts = List.generate(packages.length, (index) {
      final productConfigs = products?.elementAtOrNull(index);
      return PaywallProduct.fromConfigs(
        product: packages[index],
        configs: productConfigs is Map ? productConfigs : {},
        dark: dark,
        stringifyAll: stringifyAll,
      );
    });

    final textButtons = parser<List?>(configs["textButtons"], null)
        ?.map(PaywallTextButtonContent.parse)
        .whereType<PaywallTextButtonContent>()
        .toList();

    return Paywall(
      defaultMode: false,
      id: placement,
      products: mProducts,
      configs: Map.from(configs)..remove("products"),
      initialIndex: parser(configs["initialIndex"], null),
      designType: parser(configs["designType"], null),
      safeArea: parser(configs["safeArea"], null),
      skipMode: parser(configs["skipMode"], null),
      hero: PaywallLocalizedContent.parse(configs['hero']),
      image: PaywallLocalizedContent.parse(configs['image']),
      title: PaywallLocalizedContent.parse(configs['title']),
      subtitle: PaywallLocalizedContent.parse(configs['subtitle']),
      features: PaywallLocalizedContent.parse(configs['features']),
      textButtons: (textButtons ?? []).isEmpty ? null : textButtons,
      style: PaywallStyle.parse(configs["style"], dark),
      heroStyle: PaywallStyle.parse(configs["heroStyle"], dark),
      blurStyle: PaywallStyle.parse(configs["blurStyle"], dark),
      headerStyle: PaywallStyle.parse(configs["headerStyle"], dark),
      bodyStyle: PaywallStyle.parse(configs["bodyStyle"], dark),
      footerStyle: PaywallStyle.parse(configs["footerStyle"], dark),
      imageStyle: PaywallStyle.parse(configs["imageStyle"], dark),
      titleStyle: PaywallStyle.parse(configs["titleStyle"], dark),
      subtitleStyle: PaywallStyle.parse(configs["subtitleStyle"], dark),
      featureStyle: PaywallStyle.parse(configs["featureStyle"], dark),
      featuresStyle: PaywallStyle.parse(configs["featuresStyle"], dark),
      closeButtonStyle: PaywallStyle.parse(configs["closeButtonStyle"], dark),
      textButtonStyle: PaywallStyle.parse(configs["textButtonStyle"], dark),
      textButtonsStyle: PaywallStyle.parse(configs["textButtonsStyle"], dark),
    );
  }

  Paywall localized(
    Locale locale, {
    bool? stringify,
    bool? stringifyAll,
  }) {
    return copyWith(
      hero: hero?.localized(locale),
      image: image?.localized(locale),
      title: title?.localized(locale),
      subtitle: subtitle?.localized(locale),
      features: features?.localized(locale),
      textButtons: textButtons?.map((e) => e.localized(locale)).toList(),
      products: products.map((e) {
        return e.localized(
          locale,
          stringify: stringify,
          stringifyAll: stringifyAll,
        );
      }).toList(),
    );
  }

  Paywall themed(bool dark) {
    if (configs.isEmpty) return this;
    return copyWith(
      style: PaywallStyle.parse(configs["style"], dark),
      heroStyle: PaywallStyle.parse(configs["heroStyle"], dark),
      blurStyle: PaywallStyle.parse(configs["blurStyle"], dark),
      headerStyle: PaywallStyle.parse(configs["headerStyle"], dark),
      bodyStyle: PaywallStyle.parse(configs["bodyStyle"], dark),
      footerStyle: PaywallStyle.parse(configs["footerStyle"], dark),
      imageStyle: PaywallStyle.parse(configs["imageStyle"], dark),
      titleStyle: PaywallStyle.parse(configs["titleStyle"], dark),
      subtitleStyle: PaywallStyle.parse(configs["subtitleStyle"], dark),
      featureStyle: PaywallStyle.parse(configs["featureStyle"], dark),
      featuresStyle: PaywallStyle.parse(configs["featuresStyle"], dark),
      closeButtonStyle: PaywallStyle.parse(configs["closeButtonStyle"], dark),
      textButtonStyle: PaywallStyle.parse(configs["textButtonStyle"], dark),
      textButtonsStyle: PaywallStyle.parse(configs["textButtonsStyle"], dark),
      products: products.map((e) => e.themed(dark)).toList(),
    );
  }

  Paywall copyWith({
    String? id,
    Map? configs,
    List<PaywallProduct>? products,
    int? initialIndex,
    String? designType,
    bool? skipMode,
    bool? safeArea,
    bool? defaultMode,
    PaywallLocalizedContent<String?>? hero,
    PaywallLocalizedContent<String?>? image,
    PaywallLocalizedContent<String?>? title,
    PaywallLocalizedContent<String?>? subtitle,
    PaywallLocalizedContent<List?>? features,
    List<PaywallTextButtonContent>? textButtons,
    PaywallStyle? style,
    PaywallStyle? heroStyle,
    PaywallStyle? blurStyle,
    PaywallStyle? headerStyle,
    PaywallStyle? bodyStyle,
    PaywallStyle? footerStyle,
    PaywallStyle? imageStyle,
    PaywallStyle? titleStyle,
    PaywallStyle? subtitleStyle,
    PaywallStyle? featureStyle,
    PaywallStyle? featuresStyle,
    PaywallStyle? closeButtonStyle,
    PaywallStyle? textButtonStyle,
    PaywallStyle? textButtonsStyle,
  }) {
    return Paywall(
      id: id ?? this.id,
      configs: configs ?? this.configs,
      products: products ?? this.products,
      initialIndex: initialIndex ?? this.initialIndex,
      designType: designType ?? this.designType,
      skipMode: skipMode ?? this.skipMode,
      safeArea: safeArea ?? this.safeArea,
      defaultMode: defaultMode ?? this.defaultMode,
      hero: hero ?? this.hero,
      image: image ?? this.image,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      features: features ?? this.features,
      textButtons: textButtons ?? this.textButtons,
      style: style ?? this.style,
      heroStyle: heroStyle ?? this.heroStyle,
      blurStyle: blurStyle ?? this.blurStyle,
      headerStyle: headerStyle ?? this.headerStyle,
      bodyStyle: bodyStyle ?? this.bodyStyle,
      footerStyle: footerStyle ?? this.footerStyle,
      imageStyle: imageStyle ?? this.imageStyle,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      featureStyle: featureStyle ?? this.featureStyle,
      featuresStyle: featuresStyle ?? this.featuresStyle,
      closeButtonStyle: closeButtonStyle ?? this.closeButtonStyle,
      textButtonStyle: textButtonStyle ?? this.textButtonStyle,
      textButtonsStyle: textButtonsStyle ?? this.textButtonsStyle,
    );
  }

  Paywall resolveWith({
    bool? selected,
    PaywallScaler? scaler,
    TextDirection? textDirection,
  }) {
    return copyWith(
      products: products.map((e) {
        return e.resolveWith(
          selected: selected,
          scaler: scaler,
          textDirection: textDirection,
        );
      }).toList(),
      style: style?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      heroStyle: heroStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      blurStyle: blurStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      headerStyle: headerStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      bodyStyle: bodyStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      footerStyle: footerStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      imageStyle: imageStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      titleStyle: titleStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      subtitleStyle: subtitleStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      featureStyle: featureStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      featuresStyle: featuresStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      closeButtonStyle: closeButtonStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      textButtonStyle: textButtonStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
      textButtonsStyle: textButtonsStyle?.resolveWith(
        selected: selected,
        scaler: scaler,
        textDirection: textDirection,
      ),
    );
  }

  @override
  int get hashCode {
    return Object.hashAll([
      id,
      initialIndex,
      designType,
      safeArea,
      skipMode,
      defaultMode,
      hero,
      image,
      title,
      subtitle,
      features,
      style,
      heroStyle,
      blurStyle,
      headerStyle,
      bodyStyle,
      footerStyle,
      imageStyle,
      titleStyle,
      subtitleStyle,
      featureStyle,
      featuresStyle,
      closeButtonStyle,
      textButtonStyle,
      textButtonsStyle,
      _equality.hash(configs),
      _equality.hash(textButtons),
      _equality.hash(products),
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is Paywall &&
        id == other.id &&
        initialIndex == other.initialIndex &&
        designType == other.designType &&
        safeArea == other.safeArea &&
        skipMode == other.skipMode &&
        defaultMode == other.defaultMode &&
        hero == other.hero &&
        image == other.image &&
        title == other.title &&
        subtitle == other.subtitle &&
        features == other.features &&
        style == other.style &&
        heroStyle == other.heroStyle &&
        blurStyle == other.blurStyle &&
        headerStyle == other.headerStyle &&
        bodyStyle == other.bodyStyle &&
        footerStyle == other.footerStyle &&
        imageStyle == other.imageStyle &&
        titleStyle == other.titleStyle &&
        subtitleStyle == other.subtitleStyle &&
        featureStyle == other.featureStyle &&
        featuresStyle == other.featuresStyle &&
        closeButtonStyle == other.closeButtonStyle &&
        textButtonStyle == other.textButtonStyle &&
        textButtonsStyle == other.textButtonsStyle &&
        _equality.equals(configs, other.configs) &&
        _equality.equals(textButtons, other.textButtons) &&
        _equality.equals(products, other.products);
  }

  @override
  String toString() => "$Paywall#$hashCode($id)";
}
