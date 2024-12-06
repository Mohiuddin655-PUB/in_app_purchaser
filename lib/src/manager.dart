import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';

import 'delegate.dart';
import 'product.dart';

const _kLogger = "IN_APP_PURCHASER";

typedef AdjustSdkCallback = Future<void> Function(Map<String, String> data);
typedef FbSdkCallback = Future<void> Function(String id);

class PurchaseManager<T> extends ChangeNotifier {
  final PurchaseDelegate<T> _delegate;

  PurchaseManager(PurchaseDelegate<T> delegate) : _delegate = delegate;

  /// --------------------------------------------------------------------------
  /// EMITTER START
  /// --------------------------------------------------------------------------

  final Map<String, int> _emitters = {};

  Future<void> emit(String name, Future<void> Function() callback) async {
    final count = _emitters[name] ?? 0;
    if (count > 5) return;
    _emitters[name] = count + 1;
    await Future.delayed(const Duration(seconds: 3));
    await callback();
  }

  /// --------------------------------------------------------------------------
  /// EMITTER END
  /// --------------------------------------------------------------------------

  /// --------------------------------------------------------------------------
  /// INIT START
  /// --------------------------------------------------------------------------

  bool isActive = false;

  Future<void> init() async {
    try {
      await _delegate.init();
      _delegate.profileChanges.listen(_listen);
      emit("_login", _login);
      emit("_fetchProducts", _fetchProducts);
      emit("_fetchOtoProducts", _fetchOtoProducts);
      if (!kIsWeb && Platform.isIOS) {
        emit("initAdjust", initAdjust);
        emit("initFBAnonID", initFBAnonID);
        emit("initFBApplicationId", initFBApplicationId);
      }
      _log("initialized!");
    } catch (e) {
      _log(e, "INIT");
    }
  }

  Future<void> initAdjust() async {
    try {
      final id = await Adjust.getAdid();
      if (id == null || id.isEmpty) return;
      final attributionData = await Adjust.getAttribution();
      var attribution = <String, String>{};
      if (attributionData.trackerToken != null) {
        attribution['trackerToken'] = attributionData.trackerToken!;
      }
      if (attributionData.trackerName != null) {
        attribution['trackerName'] = attributionData.trackerName!;
      }
      if (attributionData.network != null) {
        attribution['network'] = attributionData.network!;
      }
      if (attributionData.adgroup != null) {
        attribution['adgroup'] = attributionData.adgroup!;
      }
      if (attributionData.creative != null) {
        attribution['creative'] = attributionData.creative!;
      }
      if (attributionData.clickLabel != null) {
        attribution['clickLabel'] = attributionData.clickLabel!;
      }
      if (attributionData.costType != null) {
        attribution['costType'] = attributionData.costType!;
      }
      if (attributionData.costAmount != null) {
        attribution['costAmount'] = attributionData.costAmount!.toString();
      }
      if (attributionData.costCurrency != null) {
        attribution['costCurrency'] = attributionData.costCurrency!;
      }
      if (attributionData.fbInstallReferrer != null) {
        attribution['fbInstallReferrer'] = attributionData.fbInstallReferrer!;
      }
      await _delegate.initAdjustSdk(id, attribution);
      _emitters["initAdjust"] = 10;
      _log("adjust sdk initialized!");
    } catch (e) {
      _log(e, "INIT_ADJUST");
    }
  }

  Future<void> initFBAnonID() async {
    try {
      final id = await FacebookAppEvents().getAnonymousId();
      _emitters["initFBAnonID"] = 4;
      if (id == null || id.isEmpty) return;
      await _delegate.initFacebookSdk(id);
      _log("facebook anonymous id initialized!");
    } catch (e) {
      _log(e, "INIT_FACEBOOK_ANONYMOUS_ID");
    }
  }

  Future<void> initFBApplicationId() async {
    try {
      final id = await FacebookAppEvents().getApplicationId();
      _emitters["initFBApplicationId"] = 4;
      if (id == null || id.isEmpty) return;
      await _delegate.initFacebookSdk(id);
      _log("facebook application id initialized!");
    } catch (e) {
      _log(e, "INIT_FACEBOOK_APPLICATION_ID");
    }
  }

  Future<void> _check(Object? data) async {
    try {
      if (data == null) return;
      isActive = await _delegate.checkStatus(data);
      _log(isActive, "CHECK_ACTIVITY_STATUS");
    } catch (e) {
      _log(e, "CHECK_ACTIVITY_STATUS");
    }
  }

  void _listen(Object? data) => notify(() async => await _check(data));

  Future<void> _login() async {
    try {
      if (_delegate.uid == null || _delegate.uid!.isEmpty) return;
      final data = await _delegate.identify(_delegate.uid!);
      if (data == null) return;
      _emitters["_login"] = 10;
      _log("user identified!");
    } catch (e) {
      _log(e, "USER_IDENTIFY");
    }
  }

  /// --------------------------------------------------------------------------
  /// INIT END
  /// --------------------------------------------------------------------------

  /// --------------------------------------------------------------------------
  /// EXTERNAL CALLBACKS START
  /// --------------------------------------------------------------------------

  List<String> abTestingIds = [];

  bool isAbTesting(String id) => abTestingIds.contains(id);

  Future<void> upload() async {
    try {
      if (!kIsWeb && Platform.isIOS) {
        emit("initAdjust", initAdjust);
        emit("initFBAnonID", initFBAnonID);
        emit("initFBApplicationId", initFBApplicationId);
      }
      await _delegate.update();
      _log("user data uploaded!");
    } catch (e) {
      _log(e, "UPLOAD_USER_DATA");
    }
  }

  /// --------------------------------------------------------------------------
  /// EXTERNAL CALLBACKS END
  /// --------------------------------------------------------------------------

  /// --------------------------------------------------------------------------
  /// FETCH PRODUCTS START
  /// --------------------------------------------------------------------------

  List<PurchasableProduct<T>> products = const [];
  List<PurchasableProduct<T>> otoProducts = const [];
  PurchasableOffering<T> offering = PurchasableOffering.empty();
  PurchasableOffering<T> otoOffering = PurchasableOffering.empty();

  Future<void> _fetchProducts() async {
    notify(() async {
      try {
        final result = await _delegate.fetchProducts();
        if (result.isEmpty) return;
        _emitters["_fetchProducts"] = 10;
        offering = result;
        abTestingIds = _delegate.filterAbTestingIds(result).toList();
        products = _delegate.parseProducts(result.products).toList();
        _log(products, "FETCH_PRODUCTS");
      } catch (e) {
        _log(e, "FETCH_PRODUCTS");
      }
    });
  }

  Future<void> _fetchOtoProducts() async {
    notify(() async {
      try {
        final result = await _delegate.fetchOtoProducts();
        if (result.isEmpty) return;
        _emitters["_fetchOtoProducts"] = 10;
        otoOffering = result;
        otoProducts = _delegate.parseProducts(result.products).toList();
        _log(otoProducts, "FETCH_OTO_PRODUCTS");
      } catch (e) {
        _log(e, "FETCH_OTO_PRODUCTS");
      }
    });
  }

  /// --------------------------------------------------------------------------
  /// FETCH PRODUCTS END
  /// --------------------------------------------------------------------------

  /// --------------------------------------------------------------------------
  /// PURCHASE AND RESTORE START
  /// --------------------------------------------------------------------------

  String error = '';
  PurchaseStatus status = PurchaseStatus.none;

  Future<Object?> purchase(T product) async {
    try {
      notify(() => status = PurchaseStatus.purchasing);
      final data = await _delegate.purchase(product);
      await Future.delayed(const Duration(milliseconds: 50));
      if (data != null) await _check(data);
      _log(isActive, "PURCHASE_STATUS");
      notify(() {
        error = isActive ? '' : "Purchasing failed!";
        isActive ? PurchaseStatus.purchased : PurchaseStatus.purchasingFailed;
      });
      return data;
    } catch (e) {
      _log(e, "PURCHASE_STATUS");
      notify(() {
        error = e.toString();
        status = PurchaseStatus.purchasingFailed;
      });
      return null;
    }
  }

  Future<Object?> purchaseAt(int index) async {
    final list = index != 3 ? products : otoProducts;
    final product = list.elementAtOrNull(index != 3 ? index : 0)?.product;
    if (product == null) return PurchaseStatus.purchasingFailed;
    return _delegate.purchase(product);
  }

  Future<Object?> restore([bool silent = false]) async {
    try {
      if (!silent) notify(() => status = PurchaseStatus.restoring);
      final data = await _delegate.restore();
      await Future.delayed(const Duration(milliseconds: 50));
      if (data != null) await _check(data);
      _log(isActive, "RESTORE_PURCHASE_STATUS");
      if (!silent) {
        notify(() {
          error = isActive ? '' : "Restore purchasing failed!";
          isActive ? PurchaseStatus.restored : PurchaseStatus.restoringFailed;
        });
      }
      return data;
    } catch (e) {
      _log(e, "RESTORE_PURCHASE_STATUS");
      if (!silent) {
        error = e.toString();
        status = PurchaseStatus.restoringFailed;
      }
      return null;
    }
  }

  /// --------------------------------------------------------------------------
  /// PURCHASE AND RESTORE END
  /// --------------------------------------------------------------------------

  void notify([VoidCallback? callback]) {
    if (callback != null) callback();
    notifyListeners();
  }

  void _log(Object? msg, [String? method]) {
    dev.log(method != null ? "$method: $msg" : msg.toString(), name: _kLogger);
  }
}
