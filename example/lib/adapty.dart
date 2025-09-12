import 'dart:io';

import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchaser/in_app_purchaser.dart';

class AdaptyInAppPurchaseDelegate extends InAppPurchaseDelegate {
  const AdaptyInAppPurchaseDelegate();

  Adapty get instance => Adapty();

  @override
  Set<String> get placements => {"default"};

  @override
  Future<void> init() async {
    await instance.setLogLevel(AdaptyLogLevel.debug);

    bool isActivated = kDebugMode ? await instance.isActivated() : false;

    if (isActivated) return instance.setupAfterHotRestart();
    await instance.activate(
      configuration: AdaptyConfiguration(apiKey: "API_KEY")
        ..withLogLevel(AdaptyLogLevel.debug)
        ..withObserverMode(false)
        ..withCustomerUserId("USER_ID")
        ..withIpAddressCollectionDisabled(false)
        ..withAppleIdfaCollectionDisabled(false)
        ..withGoogleAdvertisingIdCollectionDisabled(false),
    );

    await _fallbacks();
  }

  Future<void> _fallbacks() async {
    try {
      final path = Platform.isIOS
          ? 'assets/fallbacks/ios.json'
          : 'assets/fallbacks/android.json';
      await instance.setFallback(path);
    } catch (_) {}
  }

  @override
  Stream<InAppPurchaseProfile> get stream {
    return instance.didUpdateProfileStream.asyncMap(profile);
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
    final paywall = await instance.getPaywall(placementId: placement);
    final configs = paywall.remoteConfig?.dictionary ?? {};
    final products = await instance.getPaywallProducts(paywall: paywall).then((
      products,
    ) {
      return products.map((e) {
        return InAppPurchaseProduct(
          id: e.vendorProductId,
          plan: e.localizedTitle,
          description: e.localizedDescription,
          currency: e.price.currencySymbol ?? e.price.currencyCode ?? "USD",
          price: e.price.amount,
          priceString: e.price.localizedString ?? "0.0\$",
          raw: e,
        );
      });
    });
    return InAppPurchaseOffering(
      id: paywall.placement.id,
      products: List.of(products),
      configs: configs,
    );
  }

  @override
  T parseConfig<T extends Object?>(Map source, String key, T defaultValue) {
    final x = source[key];
    if (x is T) return x;
    return defaultValue;
  }

  @override
  Future<InAppPurchaseProfile> profile(Object? raw) async {
    if (raw is! AdaptyProfile) return instance.getProfile().then(profile);
    return InAppPurchaseProfile(
      profileId: raw.profileId,
      customAttributes: raw.customAttributes,
      accessLevels: raw.accessLevels.map((k, v) {
        return MapEntry(
          k,
          InAppPurchaseAccessLevel(
            id: v.id,
            isActive: v.isActive,
            vendorProductId: v.vendorProductId,
            store: v.store,
            activatedAt: v.activatedAt,
            renewedAt: v.renewedAt,
            expiresAt: v.expiresAt,
            isLifetime: v.isLifetime,
            activeIntroductoryOfferType: v.activeIntroductoryOfferType,
            activePromotionalOfferType: v.activePromotionalOfferType,
            activePromotionalOfferId: v.activePromotionalOfferId,
            offerId: v.offerId,
            willRenew: v.willRenew,
            isInGracePeriod: v.isInGracePeriod,
            unsubscribedAt: v.unsubscribedAt,
            billingIssueDetectedAt: v.billingIssueDetectedAt,
            startsAt: v.startsAt,
            cancellationReason: v.cancellationReason,
            isRefund: v.isRefund,
            isSandbox: raw.isTestUser,
            ownershipType: '',
            productPlanIdentifier: '',
            verification: '',
          ),
        );
      }),
      subscriptions: raw.subscriptions.map((k, v) {
        return MapEntry(
          k,
          InAppPurchaseSubscription(
            store: v.store,
            vendorProductId: v.vendorProductId,
            vendorTransactionId: v.vendorTransactionId,
            vendorOriginalTransactionId: v.vendorOriginalTransactionId,
            isActive: v.isActive,
            isLifetime: v.isLifetime,
            activatedAt: v.activatedAt,
            renewedAt: v.renewedAt,
            expiresAt: v.expiresAt,
            startsAt: v.startsAt,
            unsubscribedAt: v.unsubscribedAt,
            billingIssueDetectedAt: v.billingIssueDetectedAt,
            isInGracePeriod: v.isInGracePeriod,
            isSandbox: v.isSandbox,
            isRefund: v.isRefund,
            willRenew: v.willRenew,
            activeIntroductoryOfferType: v.activeIntroductoryOfferType,
            activePromotionalOfferType: v.activePromotionalOfferType,
            activePromotionalOfferId: v.activePromotionalOfferId,
            offerId: v.offerId,
            cancellationReason: v.cancellationReason,
          ),
        );
      }),
      nonSubscriptions: raw.nonSubscriptions.map((k, v) {
        return MapEntry(
          k,
          v.map((e) {
            return InAppPurchaseNonSubscription(
              purchaseId: e.purchaseId,
              store: e.store,
              vendorProductId: e.vendorProductId,
              vendorTransactionId: e.vendorTransactionId,
              purchasedAt: e.purchasedAt,
              isSandbox: e.isSandbox,
              isRefund: e.isRefund,
              isConsumable: e.isConsumable,
            );
          }).toList(),
        );
      }),
      isTestUser: raw.isTestUser,
    );
  }

  @override
  Future<InAppPurchaseResult> purchase(InAppPurchaseProduct product) async {
    final raw = product.raw;
    if (raw is! AdaptyPaywallProduct) return InAppPurchaseResultInvalid();
    return instance.makePurchase(product: raw).then((result) async {
      switch (result) {
        case AdaptyPurchaseResultPending():
          return InAppPurchaseResultPending();
        case AdaptyPurchaseResultUserCancelled():
          return InAppPurchaseResultUserCancelled();
        case AdaptyPurchaseResultSuccess():
          return InAppPurchaseResultSuccess(
            product: product,
            profile: await profile(result.profile),
            jwsTransaction: result.jwsTransaction,
          );
      }
    });
  }

  @override
  Future<void> purchased(InAppPurchaseResultSuccess result) async {
    // handle purchased
  }

  @override
  Future<InAppPurchaseProfile?> restore() {
    return instance.restorePurchases().then(profile);
  }
}
