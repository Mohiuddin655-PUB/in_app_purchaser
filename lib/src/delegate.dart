import 'offering.dart';
import 'purchase_result.dart';

abstract class InAppPurchaseDelegate {
  const InAppPurchaseDelegate();

  Set<String> get placements => {"default"};

  Stream<InAppPurchaseProfile> get stream;

  Future<void> init(String? uid);

  Future<void> initAdjustSdk();

  Future<void> initFacebookSdk();

  Future<void> login(String uid);

  Future<void> logout();

  Future<InAppPurchaseOffering> offering(String placement);

  Future<InAppPurchaseResult> purchase(InAppPurchaseProduct product);

  Future<InAppPurchaseProfile> profile(Object? raw);

  Future<InAppPurchaseProfile?> restore();

  Future<void> show() async {}

  Future<void> dismiss() async {}

  void dispose() {}
}
