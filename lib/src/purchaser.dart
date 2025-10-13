import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'configs.dart';
import 'delegate.dart';
import 'offering.dart';
import 'paywall.dart';
import 'purchase_result.dart';

const _kLogger = "IN_APP_PURCHASER";

const kPurchaserRtlLocales = [
  "ar",
  "arc",
  "dv",
  "fa",
  "ha",
  "he",
  "khw",
  "ks",
  "ku",
  "ps",
  "sd",
  "ug",
  "ur",
  "yi"
];

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
  final bool logThrowEnabled;
  final bool rtlSupported;

  final InAppPurchaseDelegate _delegate;
  final InAppPurchaseConfigDelegate? configDelegate;
  final List<String> _rltLanguages;

  bool _enabled = true;
  String? defaultPlacement;
  String? uid;
  Locale? _locale;
  bool? _dark;
  bool _premiumDefault = false;
  List<String> _features = [];
  Map<String, List<int>> _ignorableIndexes = {};
  List<String> _ignorableUsers = [];

  InAppPurchaser._({
    required InAppPurchaseDelegate delegate,
    required this.logEnabled,
    this.logThrowEnabled = false,
    this.rtlSupported = true,
    this.configDelegate,
    this.defaultPlacement,
    this.uid,
    bool enabled = true,
    bool premium = false,
    Locale? locale,
    bool? dark,
    List<String>? features,
    Map<String, List<int>>? ignorableIndexes,
    List<String>? ignorableUsers,
    List<String>? rtlLanguages,
  })  : _delegate = delegate,
        _locale = locale,
        _dark = dark,
        _enabled = enabled,
        _premiumDefault = premium,
        _rltLanguages = rtlLanguages ?? kPurchaserRtlLocales,
        _features = features ?? [],
        _ignorableIndexes = ignorableIndexes ?? {},
        _ignorableUsers = ignorableUsers ?? [];

  static InAppPurchaser? iOrNull;

  static InAppPurchaser get i => iOrNull!;

  static Future<void> init({
    required InAppPurchaseDelegate delegate,
    InAppPurchaseConfigDelegate? configDelegate,
    bool logEnabled = true,
    bool logThrowEnabled = false,
    bool rtlSupported = true,
    String? uid,
    String? defaultPlacement,
    bool enabled = true,
    bool premium = false,
    Locale? locale,
    bool? dark,
    List<String>? rtlLanguages,
    List<String>? features,
    Map<String, List<int>>? ignorableIndexes,
    List<String>? ignorableUsers,
  }) async {
    iOrNull = InAppPurchaser._(
      delegate: delegate,
      configDelegate: configDelegate,
      logEnabled: logEnabled,
      logThrowEnabled: logThrowEnabled,
      rtlSupported: rtlSupported,
      rtlLanguages: rtlLanguages,
      defaultPlacement: defaultPlacement,
      uid: uid,
      enabled: enabled,
      premium: premium,
      locale: locale,
      dark: dark,
      features: features,
      ignorableIndexes: ignorableIndexes,
      ignorableUsers: ignorableUsers,
    );
    await i.configure();
  }

  void _log(Object? msg, [String? method]) {
    if (!logEnabled) return;
    dev.log(method != null ? "$method: $msg" : msg.toString(), name: _kLogger);
  }

  void notify() => notifyListeners();

  static final initState = ValueNotifier(InAppPurchaseState.none);

  StreamSubscription? _sub;

  Future<void> configure() async {
    try {
      _log("initializing...");
      initState.value = InAppPurchaseState.running;
      await _delegate.init(uid);
      _log("initialized!");
      initState.value = InAppPurchaseState.done;
      _sub?.cancel();
      _sub = _delegate.stream.listen(_listen);
      _emit("initProfile", initProfile);
      if (!kIsWeb && Platform.isIOS) {
        _emit("initAdjust", initAdjust);
        _emit("initFacebookSdk", initFacebookSdk);
      }
      fetchAll();
    } catch (e) {
      initState.value = InAppPurchaseState.failed;
      if (logThrowEnabled) throw "initialization error [$e]";
      _log(e, "initialization error");
    }
  }

  static final profileState = ValueNotifier(InAppPurchaseState.none);

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
      profileState.value = InAppPurchaseState.failed;
      if (logThrowEnabled) throw "profile initialization error [$e]";
      _log(e, "profile initialization error");
    }
  }

  static final adjustSdkState = ValueNotifier(InAppPurchaseState.none);

  Future<void> initAdjust() async {
    try {
      _log("adjust sdk initializing...");
      adjustSdkState.value = InAppPurchaseState.running;
      await _delegate.initAdjustSdk();
      _emitters["initAdjust"] = 10;
      _log("adjust sdk initialized!");
      adjustSdkState.value = InAppPurchaseState.done;
    } catch (e) {
      adjustSdkState.value = InAppPurchaseState.failed;
      if (logThrowEnabled) throw "adjust sdk initialization error [$e]";
      _log(e, "adjust sdk initialization error");
    }
  }

  static final facebookSdkState = ValueNotifier(InAppPurchaseState.none);

  Future<void> initFacebookSdk() async {
    try {
      _log("facebook sdk initializing...");
      facebookSdkState.value = InAppPurchaseState.running;
      await _delegate.initFacebookSdk();
      _emitters["initFacebookSdk"] = 10;
      _log("facebook sdk initialized!");
      facebookSdkState.value = InAppPurchaseState.done;
    } catch (e) {
      facebookSdkState.value = InAppPurchaseState.failed;
      if (logThrowEnabled) throw "facebook sdk initialization error [$e]";
      _log(e, "facebook sdk initialization error");
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
  /// LOCALIZATION START
  /// --------------------------------------------------------------------------

  Locale get locale => _locale ?? Locale("en", "US");

  static TextDirection get textDirection {
    if (iOrNull == null) return TextDirection.ltr;
    if (i.rtlSupported && i._rltLanguages.contains(i.locale.languageCode)) {
      return TextDirection.rtl;
    }
    return TextDirection.ltr;
  }

  static void changeLocale(
    Locale? locale, {
    bool notifiable = true,
    bool? stringify,
    bool? stringifyAll,
  }) {
    if (iOrNull == null) return;
    i._locale = locale;
    if (i._paywalls.isNotEmpty) {
      i._paywalls = i._paywalls.map((k, v) {
        return MapEntry(
          k,
          v.localized(
            locale ?? i.locale,
            stringify: stringify,
            stringifyAll: stringifyAll,
          ),
        );
      });
    }
    if (notifiable) i.notify();
  }

  /// --------------------------------------------------------------------------
  /// LOCALIZATION END
  /// --------------------------------------------------------------------------

  /// --------------------------------------------------------------------------
  /// THEME START
  /// --------------------------------------------------------------------------

  bool get dark => _dark ?? false;

  static void changeTheme(bool? dark, {bool notifiable = true}) {
    if (iOrNull == null) return;
    i._dark = dark;
    if (i._paywalls.isNotEmpty) {
      i._paywalls = i._paywalls.map((k, v) {
        return MapEntry(k, v.themed(dark ?? i.dark));
      });
    }
    if (notifiable) i.notify();
  }

  /// --------------------------------------------------------------------------
  /// THEME END
  /// --------------------------------------------------------------------------

  /// --------------------------------------------------------------------------
  /// PREMIUM CHECKER START
  /// --------------------------------------------------------------------------

  static final premiumStatus = ValueNotifier(false);

  InAppPurchaseProfile? profile;

  Future<void> _check(InAppPurchaseProfile? data) async {
    try {
      _log("checking...");
      if (data == null) {
        _log("nullable!", "checking error");
        return;
      }
      premiumStatus.value = await check(data);
      _log(isPremium, "checked");
    } catch (e) {
      if (logThrowEnabled) throw "checking error [$e]";
      _log(e, "checking error");
    }
  }

  Future<void> _listen(InAppPurchaseProfile? data) async {
    await _check(data);
    notify();
  }

  bool get premium => isPremium;

  static bool get isPremium => isPremiumUser(i.uid);

  static bool isPremiumUser([String? uid]) {
    if (iOrNull == null) return false;
    if (!i._enabled) return true;
    if (i._premiumDefault) return true;
    if (premiumStatus.value) return true;
    if ((uid ?? '').isNotEmpty && i._ignorableUsers.contains(uid)) return true;
    return false;
  }

  static bool isPremiumFeature(
    String feature, [
    int? ignoreIndex,
    String? uid,
  ]) {
    if (iOrNull == null) return false;
    if (isPremiumUser(uid ?? i.uid)) return false;
    if ((i._ignorableIndexes[feature] ?? []).contains(ignoreIndex)) {
      return false;
    }
    return i._features.contains(feature);
  }

  static Future<bool> check([InAppPurchaseProfile? data]) async {
    if (iOrNull == null) return false;
    data ??= i.profile ??= await i._delegate.profile(null);
    final id = data.accessLevels.keys.firstOrNull;
    if (id == null || id.isEmpty) return false;
    final info = data.accessLevels[id];
    if (info == null) return false;
    return info.isActive;
  }

  static void enabled(bool value, {bool notifiable = true}) {
    if (iOrNull == null) return;
    i._enabled = value;
    if (notifiable) i.notify();
  }

  static void setUid(String? uid, {bool notifiable = true}) {
    if (iOrNull == null) return;
    i.uid = uid;
    if (notifiable) i.notify();
  }

  static void setFeatures(List<String> features, {bool notifiable = true}) {
    if (iOrNull == null) return;
    i._features = features;
    if (notifiable) i.notify();
  }

  static void setIgnorableUsers(List<String> uids, {bool notifiable = true}) {
    if (iOrNull == null) return;
    i._ignorableUsers = uids;
    if (notifiable) i.notify();
  }

  static void setIgnorableFeatureIndexes(
    String feature,
    List<int> indexes, {
    bool notifiable = true,
  }) {
    if (iOrNull == null) return;
    if (indexes.isEmpty) {
      i._ignorableIndexes.remove(feature);
    } else {
      i._ignorableIndexes[feature] = indexes;
    }
    if (notifiable) i.notify();
  }

  static void setIgnorableMappedFeatureIndexes(
    Map<String, List<int>> indexes, {
    bool notifiable = true,
  }) {
    if (iOrNull == null) return;
    i._ignorableIndexes = indexes;
    if (notifiable) i.notify();
  }

  static void setDefaultPremiumStatus(bool status, {bool notifiable = true}) {
    if (iOrNull == null) return;
    i._premiumDefault = status;
    if (notifiable) i.notify();
  }

  static final loginState = ValueNotifier(InAppPurchaseState.none);

  static Future<void> login(String uid, {bool isDefaultPremium = false}) async {
    if (iOrNull == null) return;
    try {
      i._log("logging...");
      loginState.value = InAppPurchaseState.running;
      await i._delegate.login(uid);
      i._premiumDefault = isDefaultPremium;
      premiumStatus.value = await check();
      i.uid = uid;
      i._log("loggedIn");
      loginState.value = InAppPurchaseState.done;
    } catch (e) {
      loginState.value = InAppPurchaseState.failed;
      if (i.logThrowEnabled) throw "logging_failed [$e]";
      i._log("logging_failed");
    }
    i.notify();
  }

  static final logoutState = ValueNotifier(InAppPurchaseState.none);

  static Future<void> logout() async {
    if (iOrNull == null) return;
    try {
      i._log("logging_out...");
      logoutState.value = InAppPurchaseState.running;
      await i._delegate.logout();
      i.profile = null;
      i._premiumDefault = false;
      premiumStatus.value = false;
      i.uid = null;
      i._log("loggedOut");
      logoutState.value = InAppPurchaseState.done;
    } catch (e) {
      logoutState.value = InAppPurchaseState.failed;
      if (i.logThrowEnabled) throw "logged_out_failed [$e]";
      i._log("logged_out_failed");
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
  Map<String, Paywall> _paywalls = {};
  final Map<String, ValueNotifier<InAppPurchaseState>> _fetchingStates = {};

  Future<void> _fetch(
    String key,
    String placement, [
    bool loader = false,
  ]) async {
    final state = fetchingState(placement);
    try {
      _log("offering fetching...");
      state.value = InAppPurchaseState.running;
      if (loader) loadingState.value = InAppPurchaseState.running;
      final result = await _delegate.offering(placement);
      if (result.isEmpty) {
        _log("Not found!", "offering error");
        state.value = InAppPurchaseState.failed;
        if (loader) loadingState.value = InAppPurchaseState.failed;
        return;
      }
      _offerings[placement] = result;
      _paywalls[placement] = Paywall.fromOffering(result, dark: dark);
      _emitters[key] = 10;
      _log("offering fetched");
      state.value = InAppPurchaseState.done;
      if (loader) loadingState.value = InAppPurchaseState.done;
    } catch (e) {
      state.value = InAppPurchaseState.failed;
      if (loader) loadingState.value = InAppPurchaseState.failed;
      if (logThrowEnabled) throw "offering error [$e]";
      _log(e, "offering error");
    }
  }

  static Future<void> fetch(
    String placement, {
    bool notifiable = true,
    bool loader = false,
  }) async {
    if (iOrNull == null) return;
    final key = "_fetch:$placement";
    await i._emit(key, () => i._fetch(key, placement, loader));
    if (notifiable) i.notify();
  }

  static final loadingState = ValueNotifier(InAppPurchaseState.none);

  static Future<void> fetchAll({bool notifiable = true}) async {
    if (iOrNull == null) return;
    loadingState.value = InAppPurchaseState.running;
    await Future.wait(i._delegate.placements.map((e) {
      return fetch(e, notifiable: false);
    }));
    loadingState.value = InAppPurchaseState.done;
    if (notifiable) i.notify();
  }

  String? _placement;
  String? _previousPlacement;

  String get placement {
    return _placement ?? defaultPlacement ?? _delegate.placements.first;
  }

  static String? get placementId => iOrNull?.placement;

  static InAppPurchaseOffering? offering([String? placement]) {
    if (iOrNull == null) return null;
    return i._offerings[placement ?? i.placement];
  }

  static T parseConfig<T extends Object?>(Object? value, T defaultValue) {
    if (iOrNull == null) return defaultValue;
    return i._delegate.parseConfig(value, defaultValue);
  }

  static Paywall? paywall([String? placement]) {
    if (iOrNull == null) return null;
    return i._paywalls[placement ?? i.placement];
  }

  static InAppPurchaseProduct? productAt(int index, [String? placement]) {
    if (iOrNull == null) return null;
    return products(placement).elementAtOrNull(index);
  }

  static List<InAppPurchaseProduct> products([String? placement]) {
    if (iOrNull == null) return [];
    return offering(placement)?.products ?? [];
  }

  static ValueNotifier<InAppPurchaseState> get fetchingDefaultState {
    if (iOrNull == null) return ValueNotifier(InAppPurchaseState.none);
    return fetchingState(i.placement);
  }

  static ValueNotifier<InAppPurchaseState> fetchingState([String? placement]) {
    if (iOrNull == null) return ValueNotifier(InAppPurchaseState.none);
    return i._fetchingStates[placement ?? i.placement] ??= ValueNotifier(
      InAppPurchaseState.none,
    );
  }

  static void changePlacement(String? placement, {bool notifiable = true}) {
    if (iOrNull == null) return;
    i._previousPlacement = i._placement;
    i._placement = placement;
    if (placement != null && !i._offerings.containsKey(placement)) {
      fetch(placement, notifiable: notifiable, loader: true);
    }
    if (notifiable) i.notify();
  }

  static void switchPreviousPlacement({bool notifiable = true}) {
    if (iOrNull == null) return;
    changePlacement(i._previousPlacement, notifiable: notifiable);
  }

  static void switchDefaultPlacement({bool notifiable = true}) {
    changePlacement(null, notifiable: notifiable);
  }

  void _disposeOffering() {
    loadingState.dispose();
    for (var state in _fetchingStates.values) {
      state.dispose();
    }
  }

  /// --------------------------------------------------------------------------
  /// OFFERING END
  /// --------------------------------------------------------------------------

  /// --------------------------------------------------------------------------
  /// PURCHASE AND RESTORE START
  /// --------------------------------------------------------------------------

  static final purchasingState = ValueNotifier(InAppPurchaseState.none);

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
      if (product.raw == null) {
        i._log("purchasing_failed: nullable product");
        purchasingState.value = InAppPurchaseState.invalid;
        return InAppPurchaseResultInvalid();
      }
      purchasingState.value = InAppPurchaseState.running;
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
      purchasingState.value = InAppPurchaseState.failed;
      if (i.logThrowEnabled) throw "purchasing error [$e]";
      i._log(e, "purchasing error");
      return InAppPurchaseResultFailed();
    }
  }

  static Future<InAppPurchaseResult> purchaseAt(
    int index, {
    String? placement,
  }) async {
    i._log("purchasing_at[$index]");
    placement ??= i.placement;
    if (placement.isEmpty) {
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

  static final restoringState = ValueNotifier(InAppPurchaseState.none);

  static Future<InAppPurchaseProfile?> restore([bool silent = false]) async {
    try {
      i._log("restoring...");
      if (!silent) restoringState.value = InAppPurchaseState.running;
      final data = await i._delegate.restore();
      if (data != null) await i._check(data);
      i._log(isPremium, "restored");
      if (!silent) {
        if (isPremium) {
          restoringState.value = InAppPurchaseState.exist;
        } else {
          restoringState.value = InAppPurchaseState.empty;
        }
      }
      i.notify();
      return data;
    } catch (e) {
      if (!silent) restoringState.value = InAppPurchaseState.failed;
      if (i.logThrowEnabled) throw "restoring error [$e]";
      i._log(e, "restoring error");
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
