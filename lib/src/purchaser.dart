import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'delegate.dart';
import 'offering.dart';
import 'paywall.dart';
import 'purchase_result.dart';

const _kLogger = "IN_APP_PURCHASER";

enum InAppPurchaseState {
  none,
  running,
  done,
  pending,
  cancel,
  failed,
  exist,
  invalid,
  empty;

  bool get isRunning => this == running;

  bool get isDone => this == done;

  bool get isExist => this == exist;

  bool get isPending => this == pending;

  bool get isCancelled => this == cancel;

  bool get isFailed => this == failed;

  bool get isInvalid => this == invalid;

  bool get isEmpty => this == empty;
}

class InAppPurchaser extends ChangeNotifier {
  /// --------------------------------------------------------------------------
  /// INIT START
  /// --------------------------------------------------------------------------

  final bool logEnabled;

  final InAppPurchaseDelegate _delegate;

  bool initialized = false;

  InAppPurchaser._({
    required InAppPurchaseDelegate delegate,
    required this.logEnabled,
  }) : _delegate = delegate;

  static InAppPurchaser? _i;

  static InAppPurchaser get i => _i!;

  static Future<void> init({
    required InAppPurchaseDelegate delegate,
    bool logEnabled = true,
  }) async {
    _i = InAppPurchaser._(delegate: delegate, logEnabled: logEnabled);
    await i.configure();
  }

  void _log(Object? msg, [String? method]) {
    if (!logEnabled) return;
    dev.log(method != null ? "$method: $msg" : msg.toString(), name: _kLogger);
  }

  void notify() => notifyListeners();

  ValueNotifier<InAppPurchaseState> initState = ValueNotifier(
    InAppPurchaseState.none,
  );

  StreamSubscription? _sub;

  Future<void> configure() async {
    try {
      _log("initializing...");
      initState.value = InAppPurchaseState.running;
      await _delegate.init();
      await _delegate.init();
      _sub?.cancel();
      _sub = _delegate.stream.listen(_listen);
      _emit("initProfile", initProfile);
      if (!kIsWeb && Platform.isIOS) {
        _emit("initAdjust", initAdjust);
        _emit("initFacebookSdk", initFacebookSdk);
      }
      _log("initialized!");
      initState.value = InAppPurchaseState.done;
      fetchAll();
      initialized = true;
    } catch (e) {
      _log(e, "initialization error");
      initState.value = InAppPurchaseState.failed;
    }
  }

  ValueNotifier<InAppPurchaseState> profileState = ValueNotifier(
    InAppPurchaseState.none,
  );

  Future<void> initProfile() async {
    try {
      _log("profile initializing...");
      profileState.value = InAppPurchaseState.running;
      profile = await _delegate.profile(null);
      if (profile != null) await _check(profile);
      _emitters["initProfile"] = 10;
      _log("profile initialized!");
      profileState.value = InAppPurchaseState.done;
    } catch (e) {
      _log(e, "profile initialization error");
      profileState.value = InAppPurchaseState.failed;
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

  void _disposeInit() {
    _sub?.cancel();
    initState.dispose();
    profileState.dispose();
    adjustSdkState.dispose();
    facebookSdkState.dispose();
  }

  /// --------------------------------------------------------------------------
  /// INIT END
  /// --------------------------------------------------------------------------

  /// --------------------------------------------------------------------------
  /// EMITTER START
  /// --------------------------------------------------------------------------

  final Map<String, int> _emitters = {};

  Future<void> _emit(String name, Future<void> Function() callback) async {
    final count = _emitters[name] ?? 0;
    if (count > 5) return;
    _emitters[name] = count + 1;
    await callback();
    await Future.delayed(const Duration(seconds: 5));
  }

  /// --------------------------------------------------------------------------
  /// EMITTER END
  /// --------------------------------------------------------------------------

  /// --------------------------------------------------------------------------
  /// PREMIUM CHECKER START
  /// --------------------------------------------------------------------------

  String? _uid;

  bool _premium = false;

  bool _premiumDefault = false;

  Set<String> _ignorableUsers = {};

  Set<String> _features = {};

  Map<String, Set<int>> _ignorableIndexes = {};

  InAppPurchaseProfile? profile;

  Future<void> _check(InAppPurchaseProfile? data) async {
    try {
      _log("checking...");
      if (data == null) {
        _log("nullable!", "checking error");
        return;
      }
      _premium = await check(data);
      _log(isPremium, "checked");
    } catch (e) {
      _log(e, "checking error");
    }
  }

  Future<void> _listen(InAppPurchaseProfile? data) async {
    await _check(data);
    notify();
  }

  bool get premium => isPremium;

  static bool get isPremium => isPremiumUser(i._uid);

  static bool isPremiumUser(String? uid) {
    if (i._premiumDefault) return true;
    if (i._premium) return true;
    if ((uid ?? '').isNotEmpty && i._ignorableUsers.contains(uid)) return true;
    return false;
  }

  static bool isPremiumFeature(String feature, [int? ignoreIndex]) {
    if (isPremium) return false;
    if ((i._ignorableIndexes[feature] ?? {}).contains(ignoreIndex)) {
      return false;
    }
    return i._features.contains(feature);
  }

  static Future<bool> check([InAppPurchaseProfile? data]) async {
    data ??= i.profile ??= await i._delegate.profile(null);
    final id = data.accessLevels.keys.firstOrNull;
    if (id == null || id.isEmpty) return false;
    final info = data.accessLevels[id];
    if (info == null) return false;
    return info.isActive;
  }

  static void setFeatures(Set<String> features) {
    i._features = features;
    i.notify();
  }

  static void setIgnorableUsers(Set<String> uids) {
    i._ignorableUsers = uids;
    i.notify();
  }

  static void setIgnorableFeatureIndexes(String feature, Set<int> indexes) {
    if (indexes.isEmpty) {
      i._ignorableIndexes.remove(feature);
    } else {
      i._ignorableIndexes[feature] = indexes;
    }
    i.notify();
  }

  static void setIgnorableMappedFeatureIndexes(Map<String, Set<int>> indexes) {
    if (indexes.isEmpty) {
      i._ignorableIndexes.clear();
    } else {
      i._ignorableIndexes = indexes;
    }
    i.notify();
  }

  static void setDefaultPremiumStatus(bool status) {
    i._premiumDefault = status;
    i.notify();
  }

  static ValueNotifier<InAppPurchaseState> loginState = ValueNotifier(
    InAppPurchaseState.none,
  );

  static Future<void> login(String uid, {bool isDefaultPremium = false}) async {
    try {
      i._log("logging...");
      loginState.value = InAppPurchaseState.running;
      await i._delegate.login(uid);
      i._premiumDefault = isDefaultPremium;
      i._premium = await check();
      i._uid = uid;
      i._log("loggedIn");
      loginState.value = InAppPurchaseState.done;
    } catch (e) {
      i._log("logging_failed");
      loginState.value = InAppPurchaseState.failed;
    }
    i.notify();
  }

  static ValueNotifier<InAppPurchaseState> logoutState = ValueNotifier(
    InAppPurchaseState.none,
  );

  static Future<void> logout() async {
    try {
      i._log("logging_out...");
      logoutState.value = InAppPurchaseState.running;
      await i._delegate.logout();
      i.profile = null;
      i._premiumDefault = false;
      i._premium = false;
      i._uid = null;
      i._log("loggedOut");
      logoutState.value = InAppPurchaseState.done;
    } catch (e) {
      i._log("logged_out_failed");
      logoutState.value = InAppPurchaseState.failed;
    }
    i.notify();
  }

  void _disposePremiumChecker() {
    loginState.dispose();
    logoutState.dispose();
  }

  /// --------------------------------------------------------------------------
  /// PREMIUM CHECKER END
  /// --------------------------------------------------------------------------

  /// --------------------------------------------------------------------------
  /// OFFERING START
  /// --------------------------------------------------------------------------

  final Map<String, InAppPurchaseOffering> _offerings = {};
  final Map<String, ValueNotifier<InAppPurchaseState>> fetchingStates = {};

  Future<void> _fetch(String key, String placement) async {
    final state = fetchingState(placement);
    try {
      _log("offering fetching...");
      state.value = InAppPurchaseState.running;
      final result = await _delegate.offering(placement);
      if (result.isEmpty) {
        _log("Not found!", "offering error");
        state.value = InAppPurchaseState.failed;
        return;
      }
      _offerings[placement] = result;
      _emitters[key] = 10;
      _log("offering fetched");
      state.value = InAppPurchaseState.done;
    } catch (e) {
      _log(e, "offering error");
      state.value = InAppPurchaseState.failed;
    }
  }

  static Future<void> fetch(String placement) {
    final key = "_fetch:$placement";
    return i._emit(key, () => i._fetch(key, placement));
  }

  static Future<void> fetchAll() async {
    await Future.wait(i._delegate.placements.map(fetch));
  }

  late String placement = _delegate.placements.first;

  static InAppPurchaseOffering? offering([String? placement]) {
    return i._offerings[placement ?? i.placement];
  }

  static T parseConfig<T extends Object?>(Object? value, T defaultValue) {
    return i._delegate.parseConfig(value, defaultValue);
  }

  static InAppPurchasePaywall? paywall([String? placement]) {
    final offer = offering(placement);
    if (offer == null) return null;
    return i._delegate.paywall(offer);
  }

  static InAppPurchaseProduct? productAt(int index, [String? placement]) {
    return products(placement).elementAtOrNull(index);
  }

  static List<InAppPurchaseProduct> products([String? placement]) {
    return offering(placement)?.products ?? [];
  }

  static ValueNotifier<InAppPurchaseState> get fetchingDefaultState {
    return fetchingState(i.placement);
  }

  static ValueNotifier<InAppPurchaseState> fetchingState(String placement) {
    return i.fetchingStates[placement] ??= ValueNotifier(
      InAppPurchaseState.none,
    );
  }

  static void changeDefaultPlacement(String placement) {
    i.placement = placement;
    if (!i._offerings.containsKey(placement)) {
      fetch(placement);
    }
    i.notify();
  }

  void _disposeOffering() {
    for (var state in fetchingStates.values) {
      state.dispose();
    }
  }

  /// --------------------------------------------------------------------------
  /// OFFERING END
  /// --------------------------------------------------------------------------

  /// --------------------------------------------------------------------------
  /// PURCHASE AND RESTORE START
  /// --------------------------------------------------------------------------

  static ValueNotifier<InAppPurchaseState> purchasingState = ValueNotifier(
    InAppPurchaseState.none,
  );

  static Future<InAppPurchaseResult> purchase(
    InAppPurchaseProduct product,
  ) async {
    try {
      if (isPremium) {
        i._log("purchasing_failed: already purchased");
        purchasingState.value = InAppPurchaseState.exist;
        return InAppPurchaseResultAlreadyPurchased(
          product: product,
          profile: i.profile,
        );
      }
      i._log("purchasing...");
      purchasingState.value = InAppPurchaseState.running;
      if (product.raw == null) {
        i._log("purchasing_failed: nullable product");
        return InAppPurchaseResultInvalid();
      }
      final data = await i._delegate.purchase(product);
      if (data is InAppPurchaseResultSuccess) {
        await i._check(data.profile);
        i._log(isPremium, "purchased");
        purchasingState.value = InAppPurchaseState.done;
        i.notify();
        await i._delegate.purchased(data);
      } else if (data is InAppPurchaseResultPending) {
        i._log("purchase_pending");
        purchasingState.value = InAppPurchaseState.pending;
      } else if (data is InAppPurchaseResultUserCancelled) {
        i._log("purchasing_cancelled");
        purchasingState.value = InAppPurchaseState.cancel;
      } else {
        i._log("purchase_failed");
        purchasingState.value = InAppPurchaseState.failed;
      }
      return data;
    } catch (e) {
      i._log(e, "purchasing error");
      purchasingState.value = InAppPurchaseState.failed;
      return InAppPurchaseResultFailed();
    }
  }

  static Future<InAppPurchaseResult> purchaseAt(
    int index, {
    String? placement,
  }) async {
    i._log("purchasing_at[$index]");
    placement ??= i._delegate.placements.firstOrNull;
    if (placement == null || placement.isEmpty) {
      i._log("purchasing_failed: invalid placement");
      purchasingState.value = InAppPurchaseState.invalid;
      return InAppPurchaseResultInvalid();
    }
    final products = offering(placement)?.products;
    if (products == null || products.isEmpty) {
      i._log("purchasing_failed: products is empty!");
      purchasingState.value = InAppPurchaseState.empty;
      return InAppPurchaseResultInvalid();
    }
    final product = products.elementAtOrNull(index);
    if (product == null) {
      i._log("purchasing_failed: invalid product or index");
      purchasingState.value = InAppPurchaseState.invalid;
      return InAppPurchaseResultInvalid();
    }
    return purchase(product);
  }

  static ValueNotifier<InAppPurchaseState> restoringState = ValueNotifier(
    InAppPurchaseState.none,
  );

  static Future<InAppPurchaseProfile?> restore([bool silent = false]) async {
    try {
      i._log("restoring...");
      if (!silent) restoringState.value = InAppPurchaseState.running;
      final data = await i._delegate.restore();
      if (data != null) await i._check(data);
      i._log(isPremium, "restored");
      if (!silent) restoringState.value = InAppPurchaseState.done;
      i.notify();
      return data;
    } catch (e) {
      i._log(e, "restoring error");
      if (!silent) restoringState.value = InAppPurchaseState.failed;
      return null;
    }
  }

  void _disposePurchaseAndRestore() {
    purchasingState.dispose();
    restoringState.dispose();
  }

  /// --------------------------------------------------------------------------
  /// PURCHASE AND RESTORE END
  /// --------------------------------------------------------------------------

  /// --------------------------------------------------------------------------
  /// STRINGIFY START
  /// --------------------------------------------------------------------------

  /// --------------------------------------------------------------------------
  /// STRINGIFY END
  /// --------------------------------------------------------------------------

  @override
  void dispose() {
    _disposeInit();
    _disposePremiumChecker();
    _disposeOffering();
    _disposePurchaseAndRestore();
    super.dispose();
  }
}
