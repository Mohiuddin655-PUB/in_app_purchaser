## in_app_purchaser

### DELEGATES

#### ADAPTY DELEGATE

```dart
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
```

#### REVENUE_CAT DELEGATE

```dart
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
        currency: e.storeProduct.currencyCode,
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
```

#### QONVERSION DELEGATE

```dart
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
        currency: e.currencyCode,
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
              (t) =>
              t.transactions.any(
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
            (e) =>
            e.transactions.any(
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
```

### USE CASE

```dart
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchaser/in_app_purchaser.dart';

import 'adapty.dart';
import 'qonversion.dart';
import 'revenue_cat.dart';

void main() {
  runApp(
    InAppPurchaseProvider(
      enabled: !kIsWeb,
      delegate: const [
        AdaptyInAppPurchaseDelegate(),
        RevenueCatInAppPurchaseDelegate(),
        QonversionInAppPurchaseDelegate(),
      ][Platform.isIOS ? 0 : 2],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'In App Purchaser',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PurchasePaywall(),
    );
  }
}

class PurchasePaywall extends StatelessWidget {
  const PurchasePaywall({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Stack(
            children: [
              ListenableBuilder(
                listenable: InAppPurchaser.i,
                builder: (context, child) {
                  return const PurchaseButton();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PurchaseButton extends StatefulWidget {
  const PurchaseButton({
    super.key,
  });

  @override
  State<PurchaseButton> createState() => _PurchaseButtonState();
}

class _PurchaseButtonState extends State<PurchaseButton> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    final products = InAppPurchaser.products();
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Get Unlimited Access',
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Column(
              children: List.generate(products.length, (index) {
                final product = products.elementAtOrNull(index);
                final priceString = product?.priceString ?? '0 BDT';
                final monthlyPrice = (product?.price ?? 0) / 12;
                return MonthlyPlan(
                  leftSideString: priceString,
                  selected: selected == index,
                  rightSideString: monthlyPrice.toString(),
                  discount: "25%",
                  onTap: () => setState(() => selected = index),
                );
              }),
            ),
            const SizedBox(height: 5),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => InAppPurchaser.purchaseAt(selected),
              child: Container(
                height: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1000),
                  color: Colors.black,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                alignment: Alignment.center,
                child: Builder(builder: (context) {
                  if (products.isEmpty) {
                    return const SizedBox.square(
                      dimension: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    );
                  }
                  return const FittedBox(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    child: const Text(
                      'Terms ',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.grey,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: InAppPurchaser.restore,
                    child: const Text(
                      'Restore ',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.grey,
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: const Text(
                      'Privacy ',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.grey,
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: const Text(
                      'User ID ',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MonthlyPlan extends StatelessWidget {
  final String leftSideString;
  final bool selected;
  final String rightSideString;
  final String? discount;
  final VoidCallback onTap;

  const MonthlyPlan({
    super.key,
    required this.leftSideString,
    required this.selected,
    required this.rightSideString,
    required this.onTap,
    this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        height: 76,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.black : Colors.transparent,
            width: 3,
          ),
        ),
        padding: const EdgeInsets.only(
          right: 20,
          left: 15,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.centerLeft,
          children: [
            Text(
              leftSideString,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text.rich(
                textScaler: TextScaler.noScaling,
                TextSpan(
                  children: [
                    TextSpan(
                      text: rightSideString, //inchToReadableFt(heightHive),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    // TextSpan(
                    //   text: extension,
                    //   style: const TextStyle(
                    //     fontFamily: defaultFont,
                    //     fontSize: Sizex.h6 + 1,
                    //     fontWeight: Weightx.heavy,
                    //     color: Colorx.black,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            if ((discount ?? '').isNotEmpty) ...[
              Positioned(
                top: -15,
                right: -0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(105),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Text(
                    discount!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```