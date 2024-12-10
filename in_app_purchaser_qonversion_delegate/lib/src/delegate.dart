import 'package:in_app_purchaser_delegate/in_app_purchaser_delegate.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

abstract class QonversionDelegate extends PurchaseDelegate<QProduct> {
  final QLaunchMode launchMode;

  const QonversionDelegate({
    this.launchMode = QLaunchMode.subscriptionManagement,
  });

  Qonversion get instance => Qonversion.getSharedInstance();

  @override
  Future<void> init() async {
    final config = QonversionConfigBuilder(apiKey, launchMode).build();
    Qonversion.initialize(config);
    await instance.collectAdvertisingId();
  }

  @override
  Future<bool> checkStatus(Object data) async {
    if (data is! Map<String, QEntitlement>) return false;
    final info = data.values.firstOrNull;
    if (info == null) return false;
    return info.isActive;
  }

  @override
  Stream<Object?> get stream {
    return instance.updatedEntitlementsStream;
  }

  @override
  Future<InAppOffering<QProduct>> fetchOtoPackages() async {
    if (!isCustomOtoOffering) return const InAppOffering.empty();
    final offerings = await instance.offerings();
    final offering = offerings.offeringForIdentifier(otoOfferId!);
    if (offering == null) return const InAppOffering.empty();
    return InAppOffering(id: offering.id, products: offering.products);
  }

  @override
  Future<InAppOffering<QProduct>> fetchPackages() async {
    final offerings = await instance.offerings();
    QOffering? offering;
    if (isCustomOffering) {
      offering = offerings.offeringForIdentifier(offerId!);
    }
    offering ??= offerings.main;
    if (offering == null) return const InAppOffering.empty();
    return InAppOffering(id: offering.id, products: offering.products);
  }

  @override
  Iterable<String> filterAbTestingIds(InAppOffering<QProduct> offering) {
    return [offering.id];
  }

  @override
  Future<Object?> identify(String uid) => instance.identify(uid);

  @override
  Future<void> logout() => instance.logout();

  @override
  Future<void> logShow(String id) async {}

  @override
  Iterable<InAppPackage> parsePackages(
    Iterable<QProduct> packages,
  ) {
    return packages.map((e) {
      final id = e.qonversionId;
      final description = e.storeDetails?.description;
      final title = e.storeDetails?.title;
      final price = e.price;
      final currency = e.currencyCode;
      return InAppPackage(
        id: id,
        plan: title ?? "",
        details: description ?? "",
        currency: currency ?? "",
        price: price ?? 0,
        raw: e,
        priceString: e.prettyPrice ?? "",
      );
    });
  }

  @override
  Future<Object?> purchase(QProduct raw) {
    return instance.purchase(raw.toPurchaseModel());
  }

  @override
  Future<Object?> restore() async {
    final value = await instance.restore();
    await instance.syncHistoricalData();
    return value;
  }
}
