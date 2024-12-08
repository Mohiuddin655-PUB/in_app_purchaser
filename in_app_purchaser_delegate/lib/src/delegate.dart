import 'offering.dart';
import 'product.dart';

abstract class PurchaseDelegate<T> {
  final String apiKey;
  final String? uid;
  final String? offerId;
  final String? otoOfferId;

  const PurchaseDelegate({
    required this.apiKey,
    this.uid,
    this.offerId,
    this.otoOfferId,
  });

  bool get isCustomOffering => offerId != null && offerId!.isNotEmpty;

  bool get isCustomOtoOffering => otoOfferId != null && otoOfferId!.isNotEmpty;

  Stream<Object?> get profileChanges;

  Future<void> init();

  Future<void> initAdjustSdk(String id, Map<String, String> attribution);

  Future<void> initFacebookSdk(String id);

  Future<bool> checkStatus(Object data);

  Future<PurchasableOffering<T>> fetchProducts();

  Future<PurchasableOffering<T>> fetchOtoProducts();

  Iterable<String> filterAbTestingIds(PurchasableOffering<T> offering);

  Future<Object?> identify(String uid);

  Future<void> logout();

  Future<void> logShow(String id);

  Iterable<PurchasableProduct<T>> parseProducts(Iterable<T> products);

  Future<Object?> purchase(T product);

  Future<Object?> restore();

  Future<void> update();

  void dispose() {}
}
