import 'dart:async';

import 'package:in_app_purchaser_delegate/in_app_purchaser_delegate.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

abstract class RevenueCatDelegate extends PurchaseDelegate<Package> {
  const RevenueCatDelegate();

  @override
  Future<void> init() async {
    await Purchases.configure(PurchasesConfiguration(apiKey)..appUserID = uid);
    await Purchases.collectDeviceIdentifiers();
  }

  @override
  Future<bool> checkStatus(Object data) async {
    if (data is! CustomerInfo) return false;
    final id = data.entitlements.all.keys.firstOrNull;
    if (id == null || id.isEmpty) return false;
    final info = data.entitlements.all[id];
    if (info == null) return false;
    return info.isActive;
  }

  @override
  Stream<Object?> get stream {
    final controller = StreamController();
    Purchases.addCustomerInfoUpdateListener(controller.add);
    return controller.stream;
  }

  @override
  Future<InAppOffering<Package>> fetchOtoPackages() async {
    if (!isCustomOtoOffering) return const InAppOffering.empty();
    final offerings = await Purchases.getOfferings();
    final offering = offerings.getOffering(otoOfferId!);
    if (offering == null) return const InAppOffering.empty();
    return InAppOffering(
      id: offering.identifier,
      products: offering.availablePackages,
    );
  }

  @override
  Future<InAppOffering<Package>> fetchPackages() async {
    final offerings = await Purchases.getOfferings();
    Offering? offering;
    if (isCustomOffering) {
      offering = offerings.getOffering(offerId!);
    }
    offering ??= offerings.current;
    if (offering == null) return const InAppOffering.empty();
    return InAppOffering(
      id: offering.identifier,
      products: offering.availablePackages,
    );
  }

  @override
  Iterable<String> filterAbTestingIds(InAppOffering<Package> offering) {
    return [offering.id];
  }

  @override
  Future<Object?> identify(String uid) => Purchases.logIn(uid);

  @override
  Future<void> logout() => Purchases.logOut();

  @override
  Future<void> logShow(String id) async {}

  @override
  Iterable<InAppPackage> parsePackages(
    Iterable<Package> packages,
  ) {
    return packages.map((e) {
      final id = e.storeProduct.identifier;
      final description = e.storeProduct.description;
      final title = e.storeProduct.title;
      final price = e.storeProduct.price;
      final currency = e.storeProduct.currencyCode;
      return InAppPackage(
        id: id,
        plan: title,
        details: description,
        currency: currency,
        price: price,
        raw: e,
        priceString: e.storeProduct.priceString,
      );
    });
  }

  @override
  Future<Object?> purchase(Package raw) {
    return Purchases.purchasePackage(raw);
  }

  @override
  Future<Object?> restore() async {
    final value = await Purchases.restorePurchases();
    return value;
  }
}
