import 'offering.dart';
import 'package.dart';

abstract class PurchaseDelegate<T> {
  const PurchaseDelegate();

  String get apiKey;

  String get uid;

  String? get offerId => null;

  String? get otoOfferId => null;

  bool get isCustomOffering => offerId != null && offerId!.isNotEmpty;

  bool get isCustomOtoOffering => otoOfferId != null && otoOfferId!.isNotEmpty;

  Stream<Object?> get stream;

  Future<void> init();

  Future<void> initAdjustSdk();

  Future<void> initFacebookSdk();

  Future<bool> checkStatus(Object data);

  Future<InAppOffering<T>> fetchPackages();

  Future<InAppOffering<T>> fetchOtoPackages();

  Iterable<String> filterAbTestingIds(InAppOffering<T> offering);

  Future<Object?> identify(String uid);

  Future<void> logout();

  Future<void> logShow(String id);

  Iterable<InAppPackage> parsePackages(Iterable<T> packages);

  Future<Object?> purchase(T raw);

  Future<Object?> restore();

  Future<void> update();

  void dispose() {}
}
