// import 'dart:async';
//
// import 'package:purchases_flutter/purchases_flutter.dart';
//
// import 'delegate.dart';
// import 'product.dart';
//
// class RevenueCatDelegate extends PurchaseDelegate<Package> {
//   const RevenueCatDelegate({
//     required super.apiKey,
//     super.uid,
//     super.offerId,
//     super.otoOfferId,
//   });
//
//   @override
//   Future<void> init() async {
//     await Purchases.configure(PurchasesConfiguration(apiKey)..appUserID = uid);
//     await Purchases.collectDeviceIdentifiers();
//   }
//
//   @override
//   Future<void> initAdjustSdk(String id, Map<String, String> attribution) {
//     return Purchases.setAdjustID(id);
//   }
//
//   @override
//   Future<void> initFacebookSdk(String id) {
//     return Purchases.setFBAnonymousID(id);
//   }
//
//   @override
//   Future<bool> checkStatus(Object data) async {
//     if (data is! CustomerInfo) return false;
//     final id = data.entitlements.all.keys.firstOrNull;
//     if (id == null || id.isEmpty) return false;
//     final info = data.entitlements.all[id];
//     if (info == null) return false;
//     return info.isActive;
//   }
//
//   @override
//   Stream<Object?> get profileChanges {
//     final controller = StreamController();
//     Purchases.addCustomerInfoUpdateListener(controller.add);
//     return controller.stream;
//   }
//
//   @override
//   Future<PurchasableOffering<Package>> fetchOtoProducts() async {
//     if (!isCustomOtoOffering) return const PurchasableOffering.empty();
//     final offerings = await Purchases.getOfferings();
//     final offering = offerings.getOffering(otoOfferId!);
//     if (offering == null) return const PurchasableOffering.empty();
//     return PurchasableOffering(
//       id: offering.identifier,
//       products: offering.availablePackages,
//     );
//   }
//
//   @override
//   Future<PurchasableOffering<Package>> fetchProducts() async {
//     final offerings = await Purchases.getOfferings();
//     Offering? offering;
//     if (isCustomOffering) {
//       offering = offerings.getOffering(offerId!);
//     }
//     offering ??= offerings.current;
//     if (offering == null) return const PurchasableOffering.empty();
//     return PurchasableOffering(
//       id: offering.identifier,
//       products: offering.availablePackages,
//     );
//   }
//
//   @override
//   Iterable<String> filterAbTestingIds(PurchasableOffering<Package> offering) {
//     return [offering.id];
//   }
//
//   @override
//   Future<Object?> identify(String uid) => Purchases.logIn(uid);
//
//   @override
//   Future<void> logout() => Purchases.logOut();
//
//   @override
//   Future<void> logShow(String id) async {}
//
//   @override
//   Iterable<PurchasableProduct<Package>> parseProducts(
//       Iterable<Package> products,
//       ) {
//     return products.map((e) {
//       final id = e.storeProduct.identifier;
//       final description = e.storeProduct.description;
//       final title = e.storeProduct.title;
//       final price = e.storeProduct.price;
//       final currency = e.storeProduct.currencyCode;
//       return PurchasableProduct(
//         id: id,
//         title: title,
//         description: description,
//         currency: currency,
//         price: price,
//         product: e,
//         priceString: e.storeProduct.priceString,
//       );
//     });
//   }
//
//   @override
//   Future<Object?> purchase(Package product) {
//     return Purchases.purchasePackage(product);
//   }
//
//   @override
//   Future<Object?> restore() async {
//     final value = await Purchases.restorePurchases();
//     return value;
//   }
//
//   @override
//   Future<void> update() async {
//     const email = "example@gmail.com";
//     final data = <String, String>{};
//     await Purchases.enableAdServicesAttributionTokenCollection();
//     if (data.isNotEmpty) await Purchases.setAttributes(data);
//     if (email.isNotEmpty) await Purchases.setEmail(email);
//     await Purchases.syncAttributesAndOfferingsIfNeeded();
//   }
// }
