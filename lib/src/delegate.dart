import 'offering.dart';
import 'paywall.dart';
import 'purchase_result.dart';

abstract class InAppPurchaseDelegate {
  const InAppPurchaseDelegate();

  Set<String> get placements;

  Stream<InAppPurchaseProfile> get stream;

  Future<void> init();

  Future<void> initAdjustSdk();

  Future<void> initFacebookSdk();

  Future<void> login(String uid);

  Future<void> logout();

  Future<InAppPurchaseOffering> offering(String placement);

  InAppPurchasePaywall paywall(InAppPurchaseOffering offering) {
    return InAppPurchasePaywall.fromOffering(offering);
  }

  T parseConfig<T extends Object?>(Map source, String key, T defaultValue);

  Future<InAppPurchaseResult> purchase(InAppPurchaseProduct product);

  Future<void> purchased(InAppPurchaseResultSuccess result);

  Future<InAppPurchaseProfile> profile(Object? raw);

  Future<InAppPurchaseProfile?> restore();

  Future<void> show() async {}

  Future<void> dismiss() async {}

  void dispose() {}
}
