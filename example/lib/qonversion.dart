import 'package:in_app_purchaser/in_app_purchaser.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

class QonversionInAppPurchaseDelegate extends InAppPurchaseDelegate {
  const QonversionInAppPurchaseDelegate();

  Qonversion get instance => Qonversion.getSharedInstance();

  @override
  Set<String> get placements => {"default"};

  @override
  Future<void> init() async {
    final config = QonversionConfigBuilder(
      "API_KEY",
      QLaunchMode.subscriptionManagement,
    ).build();
    Qonversion.initialize(config);
    await instance.collectAdvertisingId();
  }

  @override
  Stream<InAppPurchaseProfile> get stream {
    return instance.updatedEntitlementsStream.asyncMap(profile);
  }

  @override
  Future<void> login(String uid) => instance.identify(uid);

  @override
  Future<void> initAdjustSdk() async {}

  @override
  Future<void> initFacebookSdk() async {}

  @override
  Future<void> logout() => instance.logout();

  @override
  Future<InAppPurchaseOffering> offering(String placement) async {
    final offerings = await instance.offerings();
    QOffering? offering = offerings.offeringForIdentifier(placement);
    offering ??= offerings.main;
    if (offering == null) return const InAppPurchaseOffering.empty();
    final products = offering.products.map((e) {
      return InAppPurchaseProduct(
        id: e.qonversionId,
        plan: e.storeDetails?.title,
        description: e.storeDetails?.description,
        currencyCode: e.currencyCode,
        currencySymbol: e.currencyCode,
        price: e.price,
        priceString: e.prettyPrice,
        raw: e,
      );
    });
    final configs = await instance.remoteConfig(contextKey: placement);
    return InAppPurchaseOffering(
      id: offering.id,
      products: List.of(products),
      configs: configs.payload,
    );
  }

  @override
  Future<InAppPurchaseProfile> profile(Object? raw) async {
    if (raw is! Map<String, QEntitlement>) {
      return instance.checkEntitlements().then(profile);
    }
    final pro = await instance.userInfo();
    return InAppPurchaseProfile(
      profileId: pro.identityId ?? pro.qonversionId,
      customAttributes: {},
      accessLevels: raw.map((k, v) {
        return MapEntry(
          k,
          InAppPurchaseAccessLevel(
            id: v.id,
            isActive: v.isActive,
            vendorProductId: v.productId,
            store: v.source.name,
            activatedAt: v.startedDate ?? DateTime(0),
            renewedAt: v.lastPurchaseDate,
            expiresAt: v.expirationDate,
            isLifetime: v.isActive && v.expirationDate == null,
            activeIntroductoryOfferType:
                v.trialStartDate != null ? "trial" : null,
            activePromotionalOfferType:
                v.lastActivatedOfferCode != null ? "promo" : null,
            activePromotionalOfferId: v.lastActivatedOfferCode,
            offerId: "",
            willRenew: v.renewState == QEntitlementRenewState.willRenew,
            isInGracePeriod: false,
            unsubscribedAt: v.autoRenewDisableDate,
            billingIssueDetectedAt: null,
            startsAt: v.firstPurchaseDate,
            cancellationReason: null,
            isRefund: false,
            isSandbox: v.transactions.any(
              (t) => t.environment.name == QEnvironment.sandbox.name,
            ),
            ownershipType: v.grantType.name,
            productPlanIdentifier: v.productId,
            verification: "",
          ),
        );
      }),
      subscriptions: raw.map((k, v) {
        return MapEntry(
          k,
          InAppPurchaseSubscription(
            store: v.source.name,
            vendorProductId: v.productId,
            vendorTransactionId: v.transactions.isNotEmpty
                ? v.transactions.last.transactionId
                : "",
            vendorOriginalTransactionId: v.transactions.isNotEmpty
                ? v.transactions.first.transactionId
                : "",
            isActive: v.isActive,
            isLifetime: v.isActive && v.expirationDate == null,
            activatedAt: v.startedDate ?? DateTime(0),
            renewedAt: v.lastPurchaseDate,
            expiresAt: v.expirationDate,
            startsAt: v.firstPurchaseDate,
            unsubscribedAt: v.autoRenewDisableDate,
            billingIssueDetectedAt: null,
            isInGracePeriod: false,
            isSandbox: v.transactions.any(
              (t) => t.environment.name == QEnvironment.sandbox.name,
            ),
            isRefund: false,
            willRenew: v.renewState == QEntitlementRenewState.willRenew,
            activeIntroductoryOfferType:
                v.trialStartDate != null ? "trial" : null,
            activePromotionalOfferType:
                v.lastActivatedOfferCode != null ? "promo" : null,
            activePromotionalOfferId: v.lastActivatedOfferCode,
            offerId: "",
            cancellationReason: "",
          ),
        );
      }),
      nonSubscriptions: {
        "transactions": raw.values
            .where(
          (t) => t.transactions.any(
            (e) => e.type.name == "nonConsumablePurchase",
          ),
        )
            .map((t) {
          return InAppPurchaseNonSubscription(
            purchaseId: t.transactions.lastOrNull?.transactionId ?? '',
            store: '',
            vendorProductId: t.productId,
            vendorTransactionId: t.transactions.lastOrNull?.transactionId,
            purchasedAt: t.startedDate ?? DateTime(0),
            isSandbox: t.transactions.any(
              (e) => e.environment.name == QEnvironment.sandbox.name,
            ),
            isRefund: false,
            isConsumable: t.transactions.any(
              (e) => e.type.name == "subscriptionStarted",
            ),
          );
        }).toList(),
      },
      isTestUser: raw.values.any(
        (e) => e.transactions.any(
          (e) => e.environment.name == QEnvironment.sandbox.name,
        ),
      ),
    );
  }

  @override
  Future<InAppPurchaseResult> purchase(InAppPurchaseProduct product) async {
    final raw = product.raw;
    if (raw is! QProduct) return InAppPurchaseResultInvalid();
    return instance.purchaseProduct(raw).then((result) async {
      return InAppPurchaseResultSuccess(
        product: product,
        profile: await profile(result),
        jwsTransaction: '',
      );
    });
  }

  @override
  Future<void> purchased(InAppPurchaseResultSuccess result) async {
    // handle purchased
  }

  @override
  Future<InAppPurchaseProfile?> restore() {
    return instance.restore().then(profile);
  }
}
