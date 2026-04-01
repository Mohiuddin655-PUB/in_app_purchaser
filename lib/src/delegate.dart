import 'offering.dart';
import 'purchase_result.dart';

/// Base class for all in-app purchase service delegates.
///
/// Implement this class for each subscription backend (RevenueCat, Adapty,
/// Qonversion, …) and pass the concrete instance to [InAppPurchaser.init].
/// Swapping services requires only replacing the delegate — all other code
/// remains unchanged.
abstract class InAppPurchaseDelegate {
  const InAppPurchaseDelegate();

  /// The set of offering placement identifiers that should be pre-fetched on
  /// startup.
  ///
  /// Defaults to `{"default"}`.
  Set<String> get placements => const {'default'};

  /// A stream that emits the latest [InAppPurchaseProfile] whenever the
  /// subscription status changes (e.g. after a purchase or renewal).
  Stream<InAppPurchaseProfile?> get stream;

  /// Initialises the underlying SDK.
  ///
  /// [uid] is the optional user identifier to associate with this session.
  Future<void> init(String? uid);

  /// Initialises the Adjust attribution SDK.
  Future<void> initAdjustSdk();

  /// Initialises the Facebook attribution SDK.
  Future<void> initFacebookSdk();

  /// Associates the session with [uid] in the underlying service.
  Future<void> login(String uid);

  /// Removes the current user association from the underlying service.
  Future<void> logout();

  /// Fetches the offering for [placement].
  Future<InAppPurchaseOffering> offering(String placement);

  /// Initiates a purchase of [product].
  Future<InAppPurchaseResult> purchase(InAppPurchaseProduct product);

  /// Constructs an [InAppPurchaseProfile] from [raw] SDK data.
  Future<InAppPurchaseProfile> profile(Object? raw);

  /// Attempts to restore previous purchases.
  ///
  /// Returns the restored [InAppPurchaseProfile], or `null` if nothing was
  /// found.
  Future<InAppPurchaseProfile?> restore();

  /// Shows the native paywall UI if supported by the underlying SDK.
  Future<void> show() async {}

  /// Dismisses the native paywall UI if supported by the underlying SDK.
  Future<void> dismiss() async {}

  /// Releases any resources held by the delegate.
  void dispose() {}
}
