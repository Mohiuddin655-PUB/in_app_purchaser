import 'dart:async';

import 'package:flutter/services.dart';
import 'package:in_app_purchaser/in_app_purchaser.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatInAppPurchaseDelegate extends InAppPurchaseDelegate {
  const RevenueCatInAppPurchaseDelegate();

  @override
  Set<String> get placements => {"default"};

  @override
  Future<void> init() async {
    await Purchases.configure(
      PurchasesConfiguration("API_KEY")..appUserID = "USER_ID",
    );
    await Purchases.collectDeviceIdentifiers();
  }

  @override
  Stream<InAppPurchaseProfile> get stream {
    final controller = StreamController();
    Purchases.addCustomerInfoUpdateListener(controller.add);
    return controller.stream.asyncMap(profile);
  }

  @override
  Future<void> login(String uid) => Purchases.logIn(uid);

  @override
  Future<void> initAdjustSdk() async {}

  @override
  Future<void> initFacebookSdk() async {}

  @override
  Future<void> logout() => Purchases.logOut();

  @override
  Future<InAppPurchaseOffering> offering(String placement) async {
    final offerings = await Purchases.getOfferings();
    Offering? offering = offerings.getOffering(placement);
    offering ??= offerings.current;
    if (offering == null) return const InAppPurchaseOffering.empty();
    final products = offering.availablePackages.map((e) {
      return InAppPurchaseProduct(
        id: e.storeProduct.identifier,
        plan: e.storeProduct.title,
        description: e.storeProduct.description,
        currencyCode: e.storeProduct.currencyCode,
        currencySymbol: e.storeProduct.currencyCode,
        price: e.storeProduct.price,
        priceString: e.storeProduct.priceString,
        raw: e,
      );
    });
    return InAppPurchaseOffering(
      id: offering.identifier,
      products: List.of(products),
      configs: offering.metadata,
    );
  }

  @override
  Future<InAppPurchaseProfile> profile(Object? raw) async {
    if (raw is! CustomerInfo) return Purchases.getCustomerInfo().then(profile);
    return InAppPurchaseProfile(
      profileId: raw.originalAppUserId,
      customAttributes: {},
      accessLevels: raw.entitlements.all.map((k, v) {
        return MapEntry(
          k,
          InAppPurchaseAccessLevel(
            id: v.identifier,
            isActive: v.isActive,
            isSandbox: v.isSandbox,
            vendorProductId: v.productIdentifier,
            store: v.store.name,
            activatedAt: DateTime.tryParse(v.latestPurchaseDate) ?? DateTime(0),
            renewedAt: DateTime.tryParse(v.latestPurchaseDate) ?? DateTime(0),
            expiresAt: DateTime.tryParse(v.expirationDate ?? '') ?? DateTime(0),
            isLifetime: v.expirationDate == null && v.isActive,
            activeIntroductoryOfferType:
                [PeriodType.intro, PeriodType.trial].contains(v.periodType)
                    ? v.periodType.name
                    : null,
            activePromotionalOfferType:
                [PeriodType.prepaid].contains(v.periodType)
                    ? v.periodType.name
                    : null,
            activePromotionalOfferId: v.periodType.name,
            offerId: v.identifier,
            willRenew: v.willRenew,
            isInGracePeriod: false,
            unsubscribedAt:
                DateTime.tryParse(v.unsubscribeDetectedAt ?? '') ?? DateTime(0),
            billingIssueDetectedAt:
                DateTime.tryParse(v.billingIssueDetectedAt ?? '') ??
                    DateTime(0),
            startsAt: DateTime.tryParse(v.originalPurchaseDate) ?? DateTime(0),
            cancellationReason: null,
            isRefund: false,
            productPlanIdentifier: v.productPlanIdentifier,
            verification: v.verification.name,
            ownershipType: v.ownershipType.name,
          ),
        );
      }),
      subscriptions: raw.entitlements.active.map((k, v) {
        return MapEntry(
          k,
          InAppPurchaseSubscription(
            vendorTransactionId: '',
            vendorOriginalTransactionId: '',
            isActive: v.isActive,
            isSandbox: v.isSandbox,
            vendorProductId: v.productIdentifier,
            store: v.store.name,
            activatedAt: DateTime.tryParse(v.latestPurchaseDate) ?? DateTime(0),
            renewedAt: DateTime.tryParse(v.latestPurchaseDate) ?? DateTime(0),
            expiresAt: DateTime.tryParse(v.expirationDate ?? '') ?? DateTime(0),
            isLifetime: v.expirationDate == null && v.isActive,
            activeIntroductoryOfferType:
                [PeriodType.intro, PeriodType.trial].contains(v.periodType)
                    ? v.periodType.name
                    : null,
            activePromotionalOfferType:
                [PeriodType.prepaid].contains(v.periodType)
                    ? v.periodType.name
                    : null,
            activePromotionalOfferId: v.periodType.name,
            offerId: v.identifier,
            willRenew: v.willRenew,
            isInGracePeriod: false,
            unsubscribedAt:
                DateTime.tryParse(v.unsubscribeDetectedAt ?? '') ?? DateTime(0),
            billingIssueDetectedAt:
                DateTime.tryParse(v.billingIssueDetectedAt ?? '') ??
                    DateTime(0),
            startsAt: DateTime.tryParse(v.originalPurchaseDate) ?? DateTime(0),
            cancellationReason: null,
            isRefund: false,
          ),
        );
      }),
      nonSubscriptions: {
        "purchases": raw.nonSubscriptionTransactions.map((e) {
          return InAppPurchaseNonSubscription(
            purchaseId: e.transactionIdentifier,
            store: "app_store",
            vendorProductId: e.productIdentifier,
            vendorTransactionId: e.transactionIdentifier,
            purchasedAt: DateTime.tryParse(e.purchaseDate) ?? DateTime(0),
            isSandbox: false,
            isRefund: false,
            isConsumable: true,
          );
        }).toList(),
      },
      isTestUser: raw.entitlements.all.values.any((e) => e.isSandbox),
    );
  }

  @override
  Future<InAppPurchaseResult> purchase(InAppPurchaseProduct product) async {
    final raw = product.raw;
    if (raw is! StoreProduct) return InAppPurchaseResultInvalid();

    try {
      final customerInfo = await Purchases.purchase(
        PurchaseParams.storeProduct(raw),
      );
      return InAppPurchaseResultSuccess(
        product: product,
        profile: await profile(customerInfo.customerInfo),
        jwsTransaction: customerInfo.storeTransaction.transactionIdentifier,
      );
    } on PlatformException catch (e) {
      if (e.code == PurchasesErrorCode.purchaseCancelledError.name) {
        return InAppPurchaseResultUserCancelled();
      } else if ([
        PurchasesErrorCode.purchaseNotAllowedError.name,
        PurchasesErrorCode.paymentPendingError.name,
      ].contains(e.code)) {
        return InAppPurchaseResultPending();
      } else if ([
        PurchasesErrorCode.purchaseInvalidError.name,
      ].contains(e.code)) {
        return InAppPurchaseResultInvalid();
      } else {
        return InAppPurchaseResultFailed();
      }
    } catch (_) {
      return InAppPurchaseResultFailed();
    }
  }

  @override
  Future<void> purchased(InAppPurchaseResultSuccess result) async {
    // handle purchased
  }

  @override
  Future<InAppPurchaseProfile?> restore() {
    return Purchases.restorePurchases().then(profile);
  }
}
