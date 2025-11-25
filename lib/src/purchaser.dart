import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  bool _adEnabled = false;
  bool _connection = false;
  bool _enabled = true;
  String? _defaultPlacement;
  String? uid;
  Locale? _locale;
  bool? _dark;
  bool _premiumDefault = false;
  List<String> _features = [];
  Map<String, List<int>> _ignorableIndexes = {};
  List<String> _ignorableUsers = [];

  set adEnabled(bool value) => _adEnabled = value;

  set connection(bool value) => _connection = value;

  set dark(bool value) => _dark = value;

  set locale(Locale? value) => _locale = value;

  set placement(String? value) => _defaultPlacement = value;

  set premium(bool value) => _premiumDefault = value;

  InAppPurchaser._({
    required InAppPurchaseDelegate delegate,
    required this.logEnabled,
    bool connection = false,
    this.logThrowEnabled = false,
    this.rtlSupported = true,
    this.configDelegate,
    String? defaultPlacement,
    String? uid,
    bool enabled = true,
    bool premium = false,
    bool adEnabled = false,
    Locale? locale,
    bool? dark,
    List<String>? features,
    Map<String, List<int>>? ignorableIndexes,
    List<String>? ignorableUsers,
    List<String>? rtlLanguages,
  })  : _defaultPlacement = defaultPlacement,
        _connection = connection,
        _delegate = delegate,
        uid = (uid ?? '').isEmpty ? null : uid,
        _locale = locale,
        _dark = dark,
        _enabled = enabled,
        _premiumDefault = premium,
        _adEnabled = adEnabled,
        _rltLanguages = rtlLanguages ?? kPurchaserRtlLocales,
        _features = configDelegate != null && features != null
            ? features.map(configDelegate.formatFeature).toList()
            : features ?? [],
        _ignorableIndexes = configDelegate != null && ignorableIndexes != null
            ? ignorableIndexes.map((k, v) {
                return MapEntry(configDelegate.formatFeature(k), v);
              })
            : ignorableIndexes ?? {},
        _ignorableUsers = ignorableUsers ?? [];

  static InAppPurchaser? iOrNull;

  static InAppPurchaser get i => iOrNull!;

  static Future<void> init({
    required InAppPurchaseDelegate delegate,
    InAppPurchaseConfigDelegate? configDelegate,
    bool connection = false,
    bool logEnabled = true,
    bool logThrowEnabled = false,
    bool rtlSupported = true,
    String? uid,
    String? defaultPlacement,
    bool enabled = true,
    bool premium = false,
    bool adEnabled = false,
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
      connection: connection,
      logEnabled: logEnabled,
      logThrowEnabled: logThrowEnabled,
      rtlSupported: rtlSupported,
      rtlLanguages: rtlLanguages,
      defaultPlacement: defaultPlacement,
      uid: uid,
      adEnabled: adEnabled,
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
      if (_connection) _load();
    } catch (e) {
      initState.value = InAppPurchaseState.failed;
      if (logThrowEnabled) throw "initialization error [$e]";
      _log(e, "initialization error");
    }
  }

  void _load() {
    _sub?.cancel();
    _sub = _delegate.stream.listen(_listen);
    _emit("initProfile", initProfile);
    if (!kIsWeb && Platform.isIOS) {
      _emit("initAdjust", initAdjust);
      _emit("initFacebookSdk", initFacebookSdk);
    }
    fetchAll();
  }

  static void changeConnection(bool connection) {
    if (iOrNull == null) return;
    if (i._connection == connection) return;
    i._connection = connection;
    if (i._connection) {
      i._load();
    } else {
      i._sub?.cancel();
      i.notify();
    }
  }

  static final profileState = ValueNotifier(InAppPurchaseState.none);

  Future<void> initProfile() async {
    try {
      if (!i._connection) throw "No internet";
      _log("profile initializing...");
      profileState.value = InAppPurchaseState.running;
      profile = await _delegate.profile(null);
      await _check(profile);
      configDelegate?.statusChanged(isPremium);
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
      if (!i._connection) throw "No internet";
      _log("adjust sdk initializing...");
      adjustSdkState.value = InAppPurchaseState.running;
      await _delegate.initAdjustSdk();
      i.configDelegate?.sdkLoaded('adjust');
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
      if (!i._connection) throw "No internet";
      _log("facebook sdk initializing...");
      facebookSdkState.value = InAppPurchaseState.running;
      await _delegate.initFacebookSdk();
      i.configDelegate?.sdkLoaded('facebook');
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
    i.configDelegate?.localeChanged(i.locale);
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
    i.configDelegate?.themeChanged(i.dark);
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
      _log("checking_premium...");
      final status = data == null ? false : await check(data);
      configDelegate?.saveStoreStatus(status);
      premiumStatus.value = status;
      _log(status, "hasPremium");
    } catch (e) {
      if (logThrowEnabled) throw "checking_premium_error [$e]";
      _log(e, "checking_premium_error");
    }
  }

  Future<void> _listen(InAppPurchaseProfile? data) async {
    await _check(data);
    configDelegate?.statusChanged(isPremium);
    notify();
  }

  bool get premium => isPremium;

  static bool get isPremium => isPremiumUser();

  static bool get isPremiumWithoutAd => isPremiumUser(withAd: false);

  static bool isPremiumUser({String? uid, bool? withAd}) {
    if (iOrNull == null) return false;
    if (!i._enabled) return true;
    if ((withAd ?? true) && i._adEnabled) return true;
    if (i._premiumDefault) return true;
    if (premiumStatus.value) return true;
    if ((uid ?? i.uid ?? '').isNotEmpty &&
        i._ignorableUsers.contains(uid ?? i.uid)) {
      return true;
    }
    if (!i._connection) return i.configDelegate?.offlineStatus ?? false;
    return i.configDelegate?.cachedStatus ?? false;
  }

  static bool isPremiumFeature(
    String feature, [
    int? ignoreIndex,
    String? uid,
    bool? withAd,
  ]) {
    if (iOrNull == null) return false;
    final f = i.configDelegate?.formatFeature(feature) ?? feature;
    if (isPremiumUser(uid: uid ?? i.uid, withAd: withAd)) return false;
    if (i._features.isEmpty || !i._features.contains(f)) return false;
    if ((i._ignorableIndexes[f] ?? []).contains(ignoreIndex)) {
      return false;
    }
    return true;
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
    i.configDelegate?.statusChanged(isPremium);
    if (notifiable) i.notify();
  }

  static void setUid(String? uid, {bool notifiable = true}) {
    if (iOrNull == null) return;
    if ((uid ?? '').isEmpty) return;
    i.uid = uid;
    i.configDelegate?.statusChanged(isPremium);
    if (notifiable) i.notify();
  }

  static void setFeatures(List<String> features, {bool notifiable = true}) {
    if (iOrNull == null) return;
    if (i.configDelegate == null) {
      i._features = features;
    } else {
      i._features = features.map(i.configDelegate!.formatFeature).toList();
    }
    if (notifiable) i.notify();
  }

  static void setIgnorableUsers(List<String> uids, {bool notifiable = true}) {
    if (iOrNull == null) return;
    i._ignorableUsers = uids;
    i.configDelegate?.statusChanged(isPremium);
    if (notifiable) i.notify();
  }

  static void setIgnorableFeatureIndexes(
    String feature,
    List<int> indexes, {
    bool notifiable = true,
  }) {
    if (iOrNull == null) return;
    final f = i.configDelegate?.formatFeature(feature) ?? feature;
    if (indexes.isEmpty) {
      i._ignorableIndexes.remove(f);
    } else {
      i._ignorableIndexes[f] = indexes;
    }
    if (notifiable) i.notify();
  }

  static void setIgnorableMappedFeatureIndexes(
    Map<String, List<int>> indexes, {
    bool notifiable = true,
  }) {
    if (iOrNull == null) return;
    if (i.configDelegate != null) {
      i._ignorableIndexes = indexes.map((k, v) {
        return MapEntry(i.configDelegate!.formatFeature(k), v);
      });
    } else {
      i._ignorableIndexes = indexes;
    }
    if (notifiable) i.notify();
  }

  static void setPremiumStatus(bool status, {bool notifiable = true}) {
    if (iOrNull == null) return;
    i._premiumDefault = status;
    i.configDelegate?.statusChanged(isPremium);
    if (notifiable) i.notify();
  }

  static void open(
    BuildContext context,
    VoidCallback onApproved, {
    ValueChanged<bool>? onLoading,
    ValueChanged<String>? onError,
    bool force = false,
    String? uid,
    String? feature,
    int? index,
  }) {
    if (iOrNull?.configDelegate == null) return;
    if (!force) {
      if (isPremiumWithoutAd) {
        return onApproved();
      }
      if (feature != null && !isPremiumFeature(feature, index, uid, false)) {
        return onApproved();
      }
    }
    if (i._adEnabled) {
      return i.configDelegate!.showAd(
        context,
        onApproved,
        onLoading: onLoading,
        onError: onError,
      );
    }
    i.configDelegate!.openPaywall(context, onApproved);
  }

  static final loginState = ValueNotifier(InAppPurchaseState.none);

  static Future<void> login(String uid, {bool isDefaultPremium = false}) async {
    if (iOrNull == null || uid.isEmpty) return;
    try {
      if (!i._connection) throw "No internet";
      i._log("logging...");
      loginState.value = InAppPurchaseState.running;
      await i._delegate.login(uid);
      i._premiumDefault = isDefaultPremium;
      i.uid = uid;
      premiumStatus.value = await check();
      i.configDelegate?.statusChanged(isPremium);
      i.configDelegate?.loggedIn();
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
      if (!i._connection) throw "No internet";
      i._log("logging_out...");
      logoutState.value = InAppPurchaseState.running;
      await i._delegate.logout();
      i.profile = null;
      i._premiumDefault = false;
      premiumStatus.value = false;
      i.uid = null;
      i.configDelegate?.loggedOut();
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

  Map<String, Paywall> get paywalls => _paywalls;

  Future<void> _fetch(
    String key,
    String placement, [
    bool loader = false,
  ]) async {
    if (!i._connection) return;
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
        i.configDelegate?.paywallLoaded(placement);
        return;
      }
      _offerings[placement] = result;
      _paywalls[placement] = Paywall.fromOffering(result, dark: dark);
      i.configDelegate?.paywallLoaded(placement);
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
    if (!i._connection) return;
    final key = "_fetch:$placement";
    await i._emit(key, () => i._fetch(key, placement, loader));
    if (notifiable) i.notify();
  }

  static final loadingState = ValueNotifier(InAppPurchaseState.none);

  static Future<void> fetchAll({bool notifiable = true}) async {
    if (iOrNull == null) return;
    if (!i._connection) return;
    loadingState.value = InAppPurchaseState.running;
    await Future.wait(i._delegate.placements.map((e) {
      return fetch(e, notifiable: false);
    }));
    loadingState.value = InAppPurchaseState.done;
    i.configDelegate?.paywallsLoaded(i._delegate.placements.toList());
    if (notifiable) i.notify();
  }

  String? _placement;
  String? _previousPlacement;

  String get placement {
    return _placement ?? _defaultPlacement ?? _delegate.placements.first;
  }

  static String? get placementId => iOrNull?.placement;

  static InAppPurchaseOffering? offering([String? placement]) {
    if (iOrNull == null) return null;
    return i._offerings[placement ?? i.placement];
  }

  static T parseConfig<T extends Object?>(Object? value, T defaultValue) {
    if (iOrNull == null) return defaultValue;
    return i.configDelegate?.parse(value, defaultValue) ?? defaultValue;
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
    if (!i._connection) return;
    i._previousPlacement = i._placement;
    i._placement = placement;
    if (placement != null && !i._offerings.containsKey(placement)) {
      fetch(placement, notifiable: notifiable, loader: true);
    }
    i.configDelegate?.paywallChanged(i.placement);
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
    InAppPurchaseProduct product, {
    bool repurchaseMode = false,
  }) async {
    try {
      if (!repurchaseMode && isPremium) {
        i._log("purchasing_failed: already purchased");
        purchasingState.value = InAppPurchaseState.exist;
        i.configDelegate?.statusChanged(isPremium);
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
        i.configDelegate?.statusChanged(isPremium);
        i.configDelegate?.purchased(data);
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
    bool repurchaseMode = false,
  }) async {
    i._log("purchasing_at[$index]");
    placement ??= i.placement;
    if (placement.isEmpty) {
      i._log("purchasing_failed: invalid placement");
      purchasingState.value = InAppPurchaseState.invalid;
      return InAppPurchaseResultInvalid();
    }
    final products = i.paywalls[placement]?.products;
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
    return purchase(
      product.product.copyWith(usdPrice: product.usdPrice),
      repurchaseMode: repurchaseMode,
    );
  }

  static final restoringState = ValueNotifier(InAppPurchaseState.none);

  static Future<InAppPurchaseProfile?> restore([bool silent = false]) async {
    try {
      i._log("restoring...");
      if (!silent) restoringState.value = InAppPurchaseState.running;
      final data = await i._delegate.restore();
      await i._check(data);
      i.configDelegate?.statusChanged(isPremium);
      if (data != null) i.configDelegate?.restored(data);
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
