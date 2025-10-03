import 'dart:ui';

import 'localized_content.dart';

class PaywallTextButtonContent {
  final String id;
  final PaywallLocalizedContent<String> label;
  final String? url;

  const PaywallTextButtonContent(this.id, this.label, [this.url]);

  String get localizedLabel => label.value ?? '';

  Map<String, dynamic> get dictionary {
    if (id.isEmpty) return {};
    final x = label.toJson((e) => e);
    if (x == null) return {};
    return {
      "id": id,
      "label": x,
      if (url != null) "url": url,
    };
  }

  static PaywallTextButtonContent? parse(Object? source) {
    if (source is! Map) return null;
    final id = source['id'];
    if (id is! String || id.isEmpty) return null;
    final label = PaywallLocalizedContent.parse<String>(source['label']);
    if (label == null || label.isEmpty) return null;
    final url = source['url'];
    return PaywallTextButtonContent(
      id,
      label,
      url is! String || url.isEmpty || !url.startsWith("https://") ? null : url,
    );
  }

  PaywallTextButtonContent localized(Locale locale) {
    return copyWith(label: label.localized(locale));
  }

  PaywallTextButtonContent copyWith({
    String? id,
    PaywallLocalizedContent<String>? label,
    String? url,
  }) {
    return PaywallTextButtonContent(
      id ?? this.id,
      label ?? this.label,
      url ?? this.url,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is PaywallTextButtonContent &&
        id == other.id &&
        label == other.label &&
        url == other.url;
  }

  @override
  int get hashCode => Object.hash(id, label, url);

  @override
  String toString() => "$PaywallTextButtonContent#$hashCode($id)";
}
