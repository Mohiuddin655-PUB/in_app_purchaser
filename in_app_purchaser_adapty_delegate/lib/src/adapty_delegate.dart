// import 'dart:io';
//
// import 'package:adapty_flutter/adapty_flutter.dart';
// import 'package:flutter/services.dart';
//
// import 'delegate.dart';
// import 'product.dart';
//
// class AdaptyDelegate extends PurchaseDelegate<AdaptyPaywallProduct> {
//   final bool? observerMode;
//   final AdaptyLogLevel logLevel;
//   final String fallbackAssetsDirectory;
//   final String? locale;
//   final AdaptyPaywallFetchPolicy? fetchPolicy;
//   final Duration? loadTimeout;
//
//   const AdaptyDelegate({
//     required super.apiKey,
//     super.uid,
//     super.offerId,
//     super.otoOfferId,
//     this.observerMode,
//     this.logLevel = AdaptyLogLevel.debug,
//     this.fallbackAssetsDirectory = "assets/fallback_",
//     this.locale,
//     this.fetchPolicy,
//     this.loadTimeout,
//   });
//
//   Adapty get _instance => Adapty();
//
//   @override
//   Future<void> init() async {
//     await _instance.setLogLevel(logLevel);
//     await _instance.activate(
//       configuration: AdaptyConfiguration(apiKey: apiKey),
//     );
//     await _fallbacks();
//   }
//
//   Future<void> _fallbacks() async {
//     final path = Platform.isIOS
//         ? 'assets/fallback_ios.json'
//         : 'assets/fallback_android.json';
//     final json = await rootBundle.loadString(path);
//     await _instance.setFallbackPaywalls(json);
//   }
//
//   @override
//   Future<void> initAdjustSdk(String id, Map<String, String> attribution) {
//     return _instance.updateAttribution(
//       networkUserId: id,
//       attribution,
//       source: AdaptyAttributionSource.adjust,
//     );
//   }
//
//   @override
//   Future<void> initFacebookSdk(String id) {
//     final builder = AdaptyProfileParametersBuilder();
//     builder.setFacebookAnonymousId(id);
//     return _instance.updateProfile(builder.build());
//   }
//
//   @override
//   Future<bool> checkStatus(Object data) async {
//     if (data is! AdaptyProfile) return false;
//     final id = data.accessLevels.keys.firstOrNull;
//     if (id == null || id.isEmpty) return false;
//     final info = data.accessLevels[id];
//     if (info == null) return false;
//     return info.isActive;
//   }
//
//   @override
//   Stream<Object?> get profileChanges => _instance.didUpdateProfileStream;
//
//   @override
//   Future<PurchasableOffering<AdaptyPaywallProduct>> fetchOtoProducts() async {
//     if (!isCustomOtoOffering) return const PurchasableOffering.empty();
//     final offering = await _instance.getPaywall(
//       placementId: otoOfferId!,
//       loadTimeout: loadTimeout,
//       locale: locale,
//       fetchPolicy: fetchPolicy,
//     );
//     final products = await _instance.getPaywallProducts(paywall: offering);
//     return PurchasableOffering(id: offering.placementId, products: products);
//   }
//
//   @override
//   Future<PurchasableOffering<AdaptyPaywallProduct>> fetchProducts() async {
//     AdaptyPaywall? offering;
//     if (isCustomOffering) {
//       offering = await _instance.getPaywall(
//         placementId: offerId!,
//         loadTimeout: loadTimeout,
//         locale: locale,
//         fetchPolicy: fetchPolicy,
//       );
//     }
//     offering ??= await _instance.getPaywall(
//       placementId: "default",
//       loadTimeout: loadTimeout,
//       locale: locale,
//       fetchPolicy: fetchPolicy,
//     );
//     final products = await _instance.getPaywallProducts(paywall: offering);
//     return PurchasableOffering(id: offering.placementId, products: products);
//   }
//
//   @override
//   Iterable<String> filterAbTestingIds(
//       PurchasableOffering<AdaptyPaywallProduct> offering,
//       ) {
//     return offering.products.map((e) => e.paywallABTestName);
//   }
//
//   @override
//   Future<Object?> identify(String uid) => _instance.identify(uid);
//
//   @override
//   Future<void> logout() => _instance.logout();
//
//   @override
//   Future<void> logShow(String id) async {
//     final paywall = await _instance.getPaywall(placementId: id);
//     await _instance.logShowPaywall(paywall: paywall);
//   }
//
//   @override
//   Iterable<PurchasableProduct<AdaptyPaywallProduct>> parseProducts(
//       Iterable<AdaptyPaywallProduct> products,
//       ) {
//     return products.map((e) {
//       final id = e.vendorProductId;
//       final description = e.localizedDescription;
//       final title = e.localizedTitle;
//       final price = e.price.amount;
//       final currency = e.price.currencySymbol ?? e.price.currencyCode ?? "USD";
//       return PurchasableProduct(
//         id: id,
//         title: title,
//         description: description,
//         currency: currency,
//         price: price,
//         product: e,
//         priceString: e.price.localizedString ?? "0.0\$",
//       );
//     });
//   }
//
//   @override
//   Future<Object?> purchase(AdaptyPaywallProduct product) async {
//     final result = await _instance.makePurchase(product: product);
//     if (result is! AdaptyPurchaseResultSuccess) return null;
//     return result.profile;
//   }
//
//   @override
//   Future<Object?> restore() => _instance.restorePurchases();
//
//   @override
//   Future<void> update() async {
//     const gender = "male";
//     const birthday = 0;
//     const email = "example@gmail.com";
//     final builder = AdaptyProfileParametersBuilder();
//     builder.setGender(
//       gender == "male"
//           ? AdaptyProfileGender.male
//           : gender == "female"
//           ? AdaptyProfileGender.female
//           : AdaptyProfileGender.other,
//     );
//     builder.setBirthday(DateTime(birthday, 1, 1));
//     if (email.isNotEmpty) {
//       builder.setEmail(email);
//     }
//     await _instance.updateProfile(builder.build());
//   }
// }
