import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchaser_delegate/in_app_purchaser_delegate.dart';

import 'status.dart';

const _kLogger = "IN_APP_PURCHASER";

typedef AdjustSdkCallback = Future<void> Function(Map<String, String> data);
typedef FbSdkCallback = Future<void> Function(String id);

class Purchaser extends ChangeNotifier {
  final bool logEnabled;
  final PurchaseDelegate _delegate;

  Purchaser._({
    required PurchaseDelegate delegate,
    required this.logEnabled,
  }) : _delegate = delegate;

  static Purchaser? _i;

  static Purchaser get i => _i!;

  static Purchaser init({
    required PurchaseDelegate delegate,
    bool logEnabled = true,
  }) {
    _i = Purchaser._(
      delegate: delegate,
      logEnabled: logEnabled,
    );
    return i;
  }

  void _log(Object? msg, [String? method]) {
    if (!logEnabled) return;
    dev.log(method != null ? "$method: $msg" : msg.toString(), name: _kLogger);
  }

  void notify() => notifyListeners();

  /// --------------------------------------------------------------------------
  /// EMITTER START
  /// --------------------------------------------------------------------------

  final Map<String, int> _emitters = {};

  Future<void> _emit(String name, Future<void> Function() callback) async {
    final count = _emitters[name] ?? 0;
    if (count > 5) return;
    _emitters[name] = count + 1;
    await callback();
    await Future.delayed(const Duration(seconds: 3));
  }

  /// --------------------------------------------------------------------------
  /// EMITTER END
  /// --------------------------------------------------------------------------

  /// --------------------------------------------------------------------------
  /// INIT START
  /// --------------------------------------------------------------------------

  bool isActive = false;

  Future<void> _check(Object? data) async {
    try {
      _log("checking...");
      if (data == null) {
        _log("nullable!", "checking error");
        return;
      }
      isActive = await _delegate.checkStatus(data);
      _log(isActive, "checked");
    } catch (e) {
      _log(e, "checking error");
    }
  }

  Future<void> _listen(Object? data) async {
    await _check(data);
    notify();
  }

  ValueNotifier<InAppPurchaseState> initState = ValueNotifier(
    InAppPurchaseState.none,
  );

  Future<void> configure() async {
    try {
      _log("initializing...");
      initState.value = InAppPurchaseState.running;
      await _delegate.init();
      _delegate.stream.listen(_listen);
      _emit("login", identify);
      _emit("_fetchProducts", _fetchProducts);
      _emit("_fetchOtoProducts", _fetchOtoProducts);
      if (!kIsWeb && Platform.isIOS) {
        _emit("initAdjust", initAdjust);
        _emit("initFacebookSdk", initFacebookSdk);
      }
      _log("initialized!");
      initState.value = InAppPurchaseState.done;
    } catch (e) {
      _log(e, "initialization error");
      initState.value = InAppPurchaseState.failed;
    }
  }

  ValueNotifier<InAppPurchaseState> adjustSdkState = ValueNotifier(
    InAppPurchaseState.none,
  );

  Future<void> initAdjust() async {
    try {
      _log("adjust sdk initializing...");
      adjustSdkState.value = InAppPurchaseState.running;
      await _delegate.initAdjustSdk();
      _emitters["initAdjust"] = 10;
      _log("adjust sdk initialized!");
      adjustSdkState.value = InAppPurchaseState.done;
    } catch (e) {
      _log(e, "adjust sdk initialization error");
      adjustSdkState.value = InAppPurchaseState.failed;
    }
  }

  ValueNotifier<InAppPurchaseState> facebookSdkState = ValueNotifier(
    InAppPurchaseState.none,
  );

  Future<void> initFacebookSdk() async {
    try {
      _log("facebook sdk initializing...");
      facebookSdkState.value = InAppPurchaseState.running;
      await _delegate.initFacebookSdk();
      _emitters["initFacebookSdk"] = 10;
      _log("facebook sdk initialized!");
      facebookSdkState.value = InAppPurchaseState.done;
    } catch (e) {
      _log(e, "facebook sdk initialization error");
      facebookSdkState.value = InAppPurchaseState.failed;
    }
  }

  ValueNotifier<InAppPurchaseState> identifyState = ValueNotifier(
    InAppPurchaseState.none,
  );

  Future<void> identify([String? id]) async {
    try {
      _log("identifying...");
      identifyState.value = InAppPurchaseState.running;
      if ((id ?? _delegate.uid).isEmpty) {
        _log("invalid id", "identification error");
        identifyState.value = InAppPurchaseState.failed;
        return;
      }
      final data = await _delegate.identify(id ?? _delegate.uid);
      if (data == null) {
        _log("invalid", "identification error");
        identifyState.value = InAppPurchaseState.failed;
        return;
      }
      _emitters["login"] = 10;
      _log("identified!");
      identifyState.value = InAppPurchaseState.done;
    } catch (e) {
      _log(e, "identification error");
      identifyState.value = InAppPurchaseState.failed;
    }
  }

  ValueNotifier<InAppPurchaseState> logShowState = ValueNotifier(
    InAppPurchaseState.none,
  );

  Future<void> logShow([String? id]) async {
    try {
      _log("log showing...");
      logShowState.value = InAppPurchaseState.running;
      await _delegate.logShow(id ?? offering.id);
      _log("log shown!");
      logShowState.value = InAppPurchaseState.done;
    } catch (e) {
      _log(e, "log showing error");
      logShowState.value = InAppPurchaseState.failed;
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

  ValueNotifier<InAppPurchaseState> uploadState = ValueNotifier(
    InAppPurchaseState.none,
  );

  Future<void> upload() async {
    try {
      _log("uploading...");
      uploadState.value = InAppPurchaseState.running;
      if (!kIsWeb && Platform.isIOS) {
        _emit("initAdjust", initAdjust);
        _emit("initFacebookSdk", initFacebookSdk);
      }
      await _delegate.update();
      _log("uploaded!");
      uploadState.value = InAppPurchaseState.done;
    } catch (e) {
      _log(e, "uploading error");
      uploadState.value = InAppPurchaseState.failed;
    }
  }

  /// --------------------------------------------------------------------------
  /// EXTERNAL CALLBACKS END
  /// --------------------------------------------------------------------------

  /// --------------------------------------------------------------------------
  /// FETCH PRODUCTS START
  /// --------------------------------------------------------------------------

  List<InAppPackage> products = [];
  InAppOffering offering = InAppOffering.empty();
  ValueNotifier<InAppPurchaseState> offeringState = ValueNotifier(
    InAppPurchaseState.none,
  );

  Future<void> _fetchProducts() async {
    try {
      _log("offering fetching...");
      offeringState.value = InAppPurchaseState.running;
      final result = await _delegate.fetchPackages();
      if (result.isEmpty) {
        _log("Not found!", "offering error");
        offeringState.value = InAppPurchaseState.failed;
        return;
      }
      offering = result;
      abTestingIds = _delegate.filterAbTestingIds(result).toList();
      products = _delegate.parsePackages(result.products).toList();
      _emitters["_fetchProducts"] = 10;
      _log(products, "offering fetched");
      offeringState.value = InAppPurchaseState.done;
    } catch (e) {
      _log(e, "offering error");
      offeringState.value = InAppPurchaseState.failed;
    }
  }

  List<InAppPackage> otoProducts = [];
  InAppOffering otoOffering = InAppOffering.empty();
  ValueNotifier<InAppPurchaseState> otoOfferingState = ValueNotifier(
    InAppPurchaseState.none,
  );

  Future<void> _fetchOtoProducts() async {
    try {
      _log("oto offering fetching...");
      otoOfferingState.value = InAppPurchaseState.running;
      final result = await _delegate.fetchOtoPackages();
      if (result.isEmpty) {
        _log("Not found!", "oto offering error");
        otoOfferingState.value = InAppPurchaseState.failed;
        return;
      }
      otoOffering = result;
      otoProducts = _delegate.parsePackages(result.products).toList();
      _emitters["_fetchOtoProducts"] = 10;
      _log(products, "oto offering fetched");
      otoOfferingState.value = InAppPurchaseState.done;
    } catch (e) {
      _log(e, "oto offering error");
      otoOfferingState.value = InAppPurchaseState.failed;
    }
  }

  /// --------------------------------------------------------------------------
  /// FETCH PRODUCTS END
  /// --------------------------------------------------------------------------

  /// --------------------------------------------------------------------------
  /// PURCHASE AND RESTORE START
  /// --------------------------------------------------------------------------

  ValueNotifier<InAppPurchaseState> purchasingState = ValueNotifier(
    InAppPurchaseState.none,
  );

  Future<bool> purchase(Object raw) async {
    try {
      _log("purchasing...");
      purchasingState.value = InAppPurchaseState.running;
      final data = await _delegate.purchase(raw);
      if (data != null) await _check(data);
      _log(isActive, "purchased");
      purchasingState.value = InAppPurchaseState.done;
      return isActive;
    } catch (e) {
      _log(e, "purchasing error");
      purchasingState.value = InAppPurchaseState.failed;
      return false;
    }
  }

  Future<bool> purchaseAt(int index) async {
    _log("purchase_at[$index]");
    final package = products.elementAtOrNull(index)?.raw;
    if (package == null) return false;
    return purchase(package);
  }

  ValueNotifier<InAppPurchaseState> restoringState = ValueNotifier(
    InAppPurchaseState.none,
  );

  Future<bool> restore([bool silent = false]) async {
    try {
      _log("restoring...");
      if (!silent) restoringState.value = InAppPurchaseState.running;
      final data = await _delegate.restore();
      if (data != null) await _check(data);
      _log(isActive, "restored");
      if (!silent) restoringState.value = InAppPurchaseState.done;
      return isActive;
    } catch (e) {
      _log(e, "restoring error");
      if (!silent) restoringState.value = InAppPurchaseState.failed;
      return false;
    }
  }

  /// --------------------------------------------------------------------------
  /// PURCHASE AND RESTORE END
  /// --------------------------------------------------------------------------

  @override
  void dispose() {
    initState.dispose();
    adjustSdkState.dispose();
    facebookSdkState.dispose();
    identifyState.dispose();
    logShowState.dispose();
    uploadState.dispose();
    offeringState.dispose();
    otoOfferingState.dispose();
    purchasingState.dispose();
    restoringState.dispose();
    super.dispose();
  }
}
