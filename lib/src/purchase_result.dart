import 'offering.dart' show InAppPurchaseProduct;

sealed class InAppPurchaseResult {
  const InAppPurchaseResult();
}

class InAppPurchaseResultPending extends InAppPurchaseResult {}

class InAppPurchaseResultInvalid extends InAppPurchaseResult {}

class InAppPurchaseResultUserCancelled extends InAppPurchaseResult {}

class InAppPurchaseResultFailed extends InAppPurchaseResult {}

class InAppPurchaseResultSuccess extends InAppPurchaseResult {
  final InAppPurchaseProfile? profile;
  final String? jwsTransaction;
  final InAppPurchaseProduct product;

  const InAppPurchaseResultSuccess({
    required this.product,
    this.profile,
    this.jwsTransaction,
  });
}

class InAppPurchaseResultAlreadyPurchased extends InAppPurchaseResultSuccess {
  const InAppPurchaseResultAlreadyPurchased({
    required super.product,
    super.profile,
  });
}

class InAppPurchaseProfile {
  /// An identifier of a user.
  final String profileId;

  /// An identifier of a user in your system.
  ///
  /// [Nullable]
  final String? customerUserId;

  /// Previously set user custom attributes with `.updateProfile()` method.
  final Map<String, dynamic> customAttributes;

  /// The keys are access level identifiers configured by you in Dashboard.
  /// The values are Can be null if the customer has no access levels.
  final Map<String, InAppPurchaseAccessLevel> accessLevels;

  /// The keys are product ids from a store. The values are information about subscriptions.
  /// Can be null if the customer has no subscriptions.
  final Map<String, InAppPurchaseSubscription> subscriptions;

  /// The keys are product ids from the store. The values are arrays of information about consumables.
  /// Can be null if the customer has no purchases.
  final Map<String, List<InAppPurchaseNonSubscription>> nonSubscriptions;

  /// Indicates if the profile belongs to a test devices.
  final bool isTestUser;

  const InAppPurchaseProfile({
    required this.profileId,
    this.customerUserId,
    required this.customAttributes,
    required this.accessLevels,
    required this.subscriptions,
    required this.nonSubscriptions,
    required this.isTestUser,
  });

  @override
  String toString() => '(profileId: $profileId, '
      'customerUserId: $customerUserId, '
      'customAttributes: $customAttributes, '
      'accessLevels: $accessLevels, '
      'subscriptions: $subscriptions, '
      'nonSubscriptions: $nonSubscriptions, '
      'isTestUser: $isTestUser)';
}

class InAppPurchaseAccessLevel {
  /// Unique identifier of the access level configured by you in Dashboard.
  final String id;

  /// `true` if this access level is active. Generally, you can check this property to determine wether a user has an access to premium features.
  final bool isActive;

  /// An identifier of a product in a store that unlocked this access level.
  final String vendorProductId;

  /// A store of the purchase that unlocked this access level.
  ///
  /// Possible values:
  /// - `app_store`
  /// - `play_store`
  /// - `adapty`
  final String store;

  /// Time when this access level was activated.
  final DateTime activatedAt;

  /// Time when the access level was renewed. It can be `null` if the purchase was first in chain or it is non-renewing subscription / non-consumable (e.g. lifetime)
  ///
  /// [Nullable]
  final DateTime? renewedAt;

  /// Time when the access level will expire (could be in the past and could be `null` for lifetime access).
  ///
  /// [Nullable]
  final DateTime? expiresAt;

  /// `true` if this access level is active for a lifetime (no expiration date).
  final bool isLifetime;

  /// A type of an active introductory offer. If the value is not `null`, it means that the offer was applied during the current subscription period.
  ///
  /// Possible values:
  /// - `free_trial`
  /// - `pay_as_you_go`
  /// - `pay_up_front`
  final String? activeIntroductoryOfferType;

  ///  A type of an active promotional offer. If the value is not `null`, it means that the offer was applied during the current subscription period.
  ///
  /// Possible values:
  /// - `free_trial`
  /// - `pay_as_you_go`
  /// - `pay_up_front`
  ///
  /// [Nullable]
  final String? activePromotionalOfferType;

  /// An id of active promotional offer.
  ///
  /// [Nullable]
  final String? activePromotionalOfferId;

  /// [Nullable]
  final String? offerId;

  /// `true` if this auto-renewable subscription is set to renew.
  final bool willRenew;

  /// `true` if this auto-renewable subscription is in the grace period.
  final bool isInGracePeriod;

  /// Time when the auto-renewable subscription was cancelled. Subscription can still be active, it just means that auto-renewal turned off.
  /// Will be set to `null` if the user reactivates the subscription.
  ///
  /// [Nullable]
  final DateTime? unsubscribedAt;

  /// Time when billing issue was detected. Subscription can still be active. Would be set to null if a charge is made.
  ///
  /// [Nullable]
  final DateTime? billingIssueDetectedAt;

  /// Time when this access level has started (could be in the future).
  ///
  /// [Nullable]
  final DateTime? startsAt;

  /// A reason why a subscription was cancelled.
  ///
  /// Possible values:
  /// - `voluntarily_cancelled`
  /// - `billing_error`
  /// - `price_increase`
  /// - `product_was_not_available`
  /// - `refund`
  /// - `upgraded`
  /// - `unknown`
  ///
  /// [Nullable]
  final String? cancellationReason;

  /// `true` if this purchase was refunded
  final bool isRefund;

  /// False if this entitlement is unlocked via a production purchase
  final bool isSandbox;

  /// Use this property to determine whether a purchase was made by the current
  /// user or shared to them by a family member. This can be useful for
  /// onboarding users who have had an entitlement shared with them, but might
  /// not be entirely aware of the benefits they now have.
  final String ownershipType;

  /// The base plan identifier that unlocked this entitlement (Google only).
  final String? productPlanIdentifier;

  /// If entitlement verification was enabled, the result of that verification.
  /// If not, `VerificationResult.NOT_REQUESTED`.
  final String verification;

  const InAppPurchaseAccessLevel({
    required this.id,
    required this.isActive,
    required this.vendorProductId,
    required this.store,
    required this.activatedAt,
    required this.renewedAt,
    required this.expiresAt,
    required this.isLifetime,
    required this.activeIntroductoryOfferType,
    required this.activePromotionalOfferType,
    required this.activePromotionalOfferId,
    required this.offerId,
    required this.willRenew,
    required this.isInGracePeriod,
    required this.unsubscribedAt,
    required this.billingIssueDetectedAt,
    required this.startsAt,
    required this.cancellationReason,
    required this.isRefund,
    required this.isSandbox,
    required this.ownershipType,
    required this.productPlanIdentifier,
    required this.verification,
  });

  @override
  String toString() => '(id: $id, '
      'isActive: $isActive, '
      'vendorProductId: $vendorProductId, '
      'store: $store, '
      'activatedAt: $activatedAt, '
      'renewedAt: $renewedAt, '
      'expiresAt: $expiresAt, '
      'isLifetime: $isLifetime, '
      'activeIntroductoryOfferType: $activeIntroductoryOfferType, '
      'activePromotionalOfferType: $activePromotionalOfferType, '
      'activePromotionalOfferId: $activePromotionalOfferId, '
      'offerId: $offerId, '
      'willRenew: $willRenew, '
      'isInGracePeriod: $isInGracePeriod, '
      'unsubscribedAt: $unsubscribedAt, '
      'billingIssueDetectedAt: $billingIssueDetectedAt, '
      'startsAt: $startsAt, '
      'cancellationReason: $cancellationReason, '
      'isRefund: $isRefund '
      'isSandbox: $isSandbox, '
      'ownershipType: $ownershipType, '
      'isRefund: $isRefund)';
}

class InAppPurchaseSubscription {
  /// A store of the purchase.
  ///
  /// Possible values:
  /// - `app_store`
  /// - `play_store`
  /// - `adapty`
  final String store;

  /// An identifier of a product in a store that unlocked this subscription.
  final String vendorProductId;

  /// A transaction id of a purchase in a store that unlocked this subscription.
  final String vendorTransactionId;

  /// An original transaction id of the purchase in a store that unlocked this subscription. For auto-renewable subscription, this will be an id of the first transaction in this subscription.
  final String vendorOriginalTransactionId;

  /// True if the subscription is active
  final bool isActive;

  /// True if the subscription is active for a lifetime (no expiration date)
  final bool isLifetime;

  /// Time when the subscription was activated.
  final DateTime activatedAt;

  /// Time when the subscription was renewed. It can be `null` if the purchase was first in chain or it is non-renewing subscription.
  ///
  /// [Nullable]
  final DateTime? renewedAt;

  /// Time when the access level will expire (could be in the past and could be `null` for lifetime access).
  ///
  /// [Nullable]
  final DateTime? expiresAt;

  /// Time when the subscription has started (could be in the future).
  ///
  /// [Nullable]
  final DateTime? startsAt;

  /// Time when the auto-renewable subscription was cancelled. Subscription can still be active, it means that auto-renewal is turned off. Would be `null` if a user reactivates the subscription.
  ///
  /// [Nullable]
  final DateTime? unsubscribedAt;

  /// Time when a billing issue was detected. Subscription can still be active.
  ///
  /// [Nullable]
  final DateTime? billingIssueDetectedAt;

  /// Whether the auto-renewable subscription is in a grace period.
  final bool isInGracePeriod;

  /// `true` if the product was purchased in a sandbox environment.
  final bool isSandbox;

  /// `true` if the purchase was refunded.
  final bool isRefund;

  /// `true` if the auto-renewable subscription is set to renew
  final bool willRenew;

  /// A type of an active introductory offer. If the value is not null, it means that the offer was applied during the current subscription period.
  ///
  /// Possible values:
  /// - `free_trial`
  /// - `pay_as_you_go`
  /// - `pay_up_front`
  ///
  /// [Nullable]
  final String? activeIntroductoryOfferType;

  /// A type of an active promotional offer. If the value is not null, it means that the offer was applied during the current subscription period.
  ///
  /// Possible values:
  /// - `free_trial`
  /// - `pay_as_you_go`
  /// - `pay_up_front`
  ///
  /// [Nullable]
  final String? activePromotionalOfferType;

  /// An id of active promotional offer.
  ///
  /// [Nullable]
  final String? activePromotionalOfferId;

  /// [Nullable]
  final String? offerId;

  /// A reason why a subscription was cancelled.
  ///
  /// Possible values:
  /// - `voluntarily_cancelled`
  /// - `billing_error`
  /// - `price_increase`
  /// - `product_was_not_available`
  /// - `refund`
  /// - `upgraded`
  /// - `unknown`
  ///
  /// [Nullable]
  final String? cancellationReason;

  const InAppPurchaseSubscription({
    required this.store,
    required this.vendorProductId,
    required this.vendorTransactionId,
    required this.vendorOriginalTransactionId,
    required this.isActive,
    required this.isLifetime,
    required this.activatedAt,
    required this.renewedAt,
    required this.expiresAt,
    required this.startsAt,
    required this.unsubscribedAt,
    required this.billingIssueDetectedAt,
    required this.isInGracePeriod,
    required this.isSandbox,
    required this.isRefund,
    required this.willRenew,
    required this.activeIntroductoryOfferType,
    required this.activePromotionalOfferType,
    required this.activePromotionalOfferId,
    required this.offerId,
    required this.cancellationReason,
  });

  @override
  String toString() => '(store: $store, '
      'vendorProductId: $vendorProductId, '
      'vendorTransactionId: $vendorTransactionId, '
      'vendorOriginalTransactionId: $vendorOriginalTransactionId, '
      'isActive: $isActive, '
      'isLifetime: $isLifetime, '
      'activatedAt: $activatedAt, '
      'renewedAt: $renewedAt, '
      'expiresAt: $expiresAt, '
      'startsAt: $startsAt, '
      'unsubscribedAt: $unsubscribedAt, '
      'billingIssueDetectedAt: $billingIssueDetectedAt, '
      'isInGracePeriod: $isInGracePeriod, '
      'isSandbox: $isSandbox, '
      'isRefund: $isRefund, '
      'willRenew: $willRenew, '
      'activeIntroductoryOfferType: $activeIntroductoryOfferType, '
      'activePromotionalOfferType: $activePromotionalOfferType, '
      'activePromotionalOfferId: $activePromotionalOfferId, '
      'offerId: $offerId, '
      'cancellationReason: $cancellationReason)';
}

class InAppPurchaseNonSubscription {
  /// An identifier of the purchase.
  /// You can use it to ensure that you've already processed this purchase (for example tracking one time products).
  final String purchaseId;

  /// A store of the purchase.
  ///
  /// Possible values:
  /// - `app_store`
  /// - `play_store`
  /// - `adapty`
  final String store;

  /// An identifier of a product in a store that unlocked this subscription.
  final String vendorProductId;

  /// A transaction id of a purchase in a store that unlocked this subscription.
  ///
  /// [Nullable]
  final String? vendorTransactionId;

  /// Date when the product was purchased.
  final DateTime purchasedAt;

  /// `true` if the product was purchased in a sandbox environment.
  final bool isSandbox;

  /// `true` if the purchase was refunded.
  final bool isRefund;

  /// `true` if the product is consumable (should only be processed once).
  final bool isConsumable;

  const InAppPurchaseNonSubscription({
    required this.purchaseId,
    required this.store,
    required this.vendorProductId,
    required this.vendorTransactionId,
    required this.purchasedAt,
    required this.isSandbox,
    required this.isRefund,
    required this.isConsumable,
  });

  @override
  String toString() => '(purchaseId: $purchaseId, '
      'store: $store, '
      'vendorProductId: $vendorProductId, '
      'vendorTransactionId: $vendorTransactionId, '
      'purchasedAt: $purchasedAt, '
      'isSandbox: $isSandbox, '
      'isRefund: $isRefund, '
      'isConsumable: $isConsumable)';
}
