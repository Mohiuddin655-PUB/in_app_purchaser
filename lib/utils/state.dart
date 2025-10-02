import 'package:collection/collection.dart';

const _equality = DeepCollectionEquality();

class PaywallState<T extends Object?> {
  final T? primary;
  final T? _secondary;

  T? get secondary => _secondary ?? primary;

  T? of(bool? selected) => selected ?? false ? secondary : primary;

  const PaywallState({
    this.primary,
    T? secondary,
  }) : _secondary = secondary;

  const PaywallState.all(T? value) : this(primary: value);

  static PaywallState<T>? parse<T>(
    Object? source,
    T? Function(Object? source) callback, {
    T? Function(T? value)? resolveWith,
  }) {
    T? resolve(T? value) {
      if (value == null || resolveWith == null) return value;
      return resolveWith(value);
    }

    if (source is Map &&
        source.keys.any((e) => ['primary', 'secondary'].contains(e))) {
      final x = PaywallState(
        primary: resolve(callback(source['primary'])),
        secondary: resolve(callback(source['secondary'])),
      );
      return x.primary == null && x._secondary == null ? null : x;
    }
    final x = resolve(callback(source));
    if (x == null) return null;
    return PaywallState.all(x);
  }

  PaywallState<T> resolveWith(T Function(T value) callback) {
    return PaywallState(
      primary: primary == null ? null : callback(primary as T),
      secondary: _secondary == null ? null : callback(_secondary as T),
    );
  }

  Object? toJson(Object? Function(T? value) callback) {
    if (_secondary == null) return callback(primary);
    final entries = {
      "primary": callback(primary),
      "secondary": callback(_secondary),
    }.entries.where((e) => e.value != null);
    if (entries.isEmpty) return null;
    return Map.fromEntries(entries);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is PaywallState &&
        _equality.equals(primary, other.primary) &&
        _equality.equals(_secondary, other._secondary);
  }

  @override
  int get hashCode {
    return Object.hash(_equality.hash(primary), _equality.hash(_secondary));
  }

  @override
  String toString() => "$PaywallState#$hashCode";
}
