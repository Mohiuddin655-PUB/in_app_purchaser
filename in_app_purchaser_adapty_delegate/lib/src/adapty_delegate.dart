import 'dart:io';

import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchaser_delegate/in_app_purchaser_delegate.dart';

abstract class AdaptyDelegate extends PurchaseDelegate<AdaptyPaywallProduct> {
  final bool? observerMode;
  final AdaptyLogLevel logLevel;
  final String fallbackAssetsDirectory;
  final String? locale;
  final AdaptyPaywallFetchPolicy? fetchPolicy;
  final Duration? loadTimeout;

  const AdaptyDelegate({
    this.observerMode,
    this.logLevel = AdaptyLogLevel.debug,
    this.fallbackAssetsDirectory = "assets/fallbacks",
    this.locale,
    this.fetchPolicy,
    this.loadTimeout,
  });

  Adapty get instance => Adapty();

  @override
  Future<void> init() async {
    await instance.setLogLevel(logLevel);
    await instance.activate(
      apiKey: apiKey,
      customerUserId: uid,
    );
    await _fallbacks();
  }

  Future<void> _fallbacks() async {
    final path = Platform.isIOS
        ? '$fallbackAssetsDirectory/ios.json'
        : '$fallbackAssetsDirectory/android.json';
    final json = await rootBundle.loadString(path);
    if (json.isEmpty) return;
    await instance.setFallbackPaywalls(json);
  }

  @override
  Future<bool> checkStatus(Object data) async {
    if (data is! AdaptyProfile) return false;
    final id = data.accessLevels.keys.firstOrNull;
    if (id == null || id.isEmpty) return false;
    final info = data.accessLevels[id];
    if (info == null) return false;
    return info.isActive;
  }

  @override
  Stream<Object?> get stream => instance.didUpdateProfileStream;

  @override
  Future<InAppOffering<AdaptyPaywallProduct>> fetchOtoPackages() async {
    if (!isCustomOtoOffering) return const InAppOffering.empty();
    final offering = await instance.getPaywall(
      placementId: otoOfferId!,
      loadTimeout: loadTimeout,
      locale: locale,
      fetchPolicy: fetchPolicy,
    );
    final products = await instance.getPaywallProducts(paywall: offering);
    return InAppOffering(id: offering.placementId, products: products);
  }

  @override
  Future<InAppOffering<AdaptyPaywallProduct>> fetchPackages() async {
    AdaptyPaywall? offering;
    if (isCustomOffering) {
      offering = await instance.getPaywall(
        placementId: offerId!,
        loadTimeout: loadTimeout,
        locale: locale,
        fetchPolicy: fetchPolicy,
      );
    }
    offering ??= await instance.getPaywall(
      placementId: "default",
      loadTimeout: loadTimeout,
      locale: locale,
      fetchPolicy: fetchPolicy,
    );
    final products = await instance.getPaywallProducts(paywall: offering);
    return InAppOffering(id: offering.placementId, products: products);
  }

  @override
  Iterable<String> filterAbTestingIds(
    InAppOffering<AdaptyPaywallProduct> offering,
  ) {
    return offering.products.map((e) => e.paywallABTestName);
  }

  @override
  Future<Object?> identify(String uid) => instance.identify(uid);

  @override
  Future<void> logout() => instance.logout();

  @override
  Future<void> logShow(String id) async {
    final paywall = await instance.getPaywall(placementId: id);
    await instance.logShowPaywall(paywall: paywall);
  }

  @override
  Iterable<InAppPackage> parsePackages(
    Iterable<AdaptyPaywallProduct> packages,
  ) {
    return packages.map((e) {
      final id = e.vendorProductId;
      final description = e.localizedDescription;
      final title = e.localizedTitle;
      final price = e.price.amount;
      final currency = e.price.currencySymbol ?? e.price.currencyCode ?? "USD";
      return InAppPackage(
        id: id,
        plan: title,
        details: description,
        currency: currency,
        price: price,
        priceString: e.price.localizedString ?? "0.0\$",
        raw: e,
      );
    });
  }

  @override
  Future<Object?> purchase(AdaptyPaywallProduct raw) {
    return instance.makePurchase(product: raw);
  }

  @override
  Future<Object?> restore() => instance.restorePurchases();
}
