import 'package:qonversion_flutter/qonversion_flutter.dart';

import 'delegate.dart';
import 'product.dart';

class QonversionDelegate extends PurchaseDelegate<QProduct> {
  const QonversionDelegate({
    required super.apiKey,
    super.offerId,
    super.otoOfferId,
    super.uid,
  });

  Qonversion get _instance => Qonversion.getSharedInstance();

  @override
  Future<void> init() async {
    final config = QonversionConfigBuilder(
      "kQonversionApiKey",
      QLaunchMode.subscriptionManagement,
    ).build();
    Qonversion.initialize(config);
    await _instance.collectAdvertisingId();
  }

  @override
  Future<void> initAdjustSdk(String id, Map<String, String> attribution) {
    return _instance.setUserProperty(QUserPropertyKey.adjustAdId, id);
  }

  @override
  Future<void> initFacebookSdk(String id) {
    return _instance.setUserProperty(
        QUserPropertyKey.firebaseAppInstanceId, id);
  }

  @override
  Future<bool> checkStatus(Object data) async {
    if (data is! Map<String, QEntitlement>) return false;
    final info = data.values.firstOrNull;
    if (info == null) return false;
    return info.isActive;
  }

  @override
  Stream<Object?> get profileChanges {
    return _instance.updatedEntitlementsStream;
  }

  @override
  Future<PurchasableOffering<QProduct>> fetchOtoProducts() async {
    if (!isCustomOtoOffering) return const PurchasableOffering.empty();
    final offerings = await _instance.offerings();
    final offering = offerings.offeringForIdentifier(otoOfferId!);
    if (offering == null) return const PurchasableOffering.empty();
    return PurchasableOffering(id: offering.id, products: offering.products);
  }

  @override
  Future<PurchasableOffering<QProduct>> fetchProducts() async {
    final offerings = await _instance.offerings();
    QOffering? offering;
    if (isCustomOffering) {
      offering = offerings.offeringForIdentifier(offerId!);
    }
    offering ??= offerings.main;
    if (offering == null) return const PurchasableOffering.empty();
    return PurchasableOffering(id: offering.id, products: offering.products);
  }

  @override
  Iterable<String> filterAbTestingIds(PurchasableOffering<QProduct> offering) {
    return [offering.id];
  }

  @override
  Future<Object?> identify(String uid) => _instance.identify(uid);

  @override
  Future<void> logout() => _instance.logout();

  @override
  Iterable<PurchasableProduct<QProduct>> parseProducts(
    Iterable<QProduct> products,
  ) {
    return products.map((e) {
      final id = e.qonversionId;
      final description = e.storeDetails?.description;
      final title = e.storeDetails?.title;
      final price = e.price;
      final currency = e.currencyCode;
      return PurchasableProduct(
        id: id,
        title: title ?? "",
        description: description ?? "",
        currency: currency ?? "",
        price: price ?? 0,
        product: e,
        priceString: e.prettyPrice ?? "",
      );
    });
  }

  @override
  Future<Object?> purchase(QProduct product) {
    return _instance.purchase(product.toPurchaseModel());
  }

  @override
  Future<Object?> restore() async {
    final value = await _instance.restore();
    await _instance.syncHistoricalData();
    return value;
  }

  @override
  Future<void> update() async {
    const email = "example@gmail.com"; // TODO: TEMPORARY
    final data = <String, String>{};
    for (final i in data.entries) {
      _instance.setCustomUserProperty(i.key, i.value);
    }
    if (email.isNotEmpty) {
      _instance.setUserProperty(QUserPropertyKey.email, email);
    }
  }
}
