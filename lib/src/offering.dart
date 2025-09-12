class InAppPurchaseProduct {
  final String? id;
  final String? plan;
  final String? description;
  final double? price;
  final String? priceString;
  final String? currency;
  final String? currencySign;

  final Object? raw;

  const InAppPurchaseProduct({
    this.id,
    this.plan,
    this.description,
    this.price,
    this.priceString,
    this.currency,
    this.currencySign,
    this.raw,
  });

  @override
  int get hashCode =>
      id.hashCode ^
      plan.hashCode ^
      description.hashCode ^
      price.hashCode ^
      priceString.hashCode ^
      currency.hashCode ^
      currencySign.hashCode ^
      raw.hashCode;

  @override
  bool operator ==(Object other) {
    return other is InAppPurchaseProduct &&
        other.id == id &&
        other.plan == plan &&
        other.description == description &&
        other.price == price &&
        other.priceString == priceString &&
        other.currency == currency &&
        other.currencySign == currencySign &&
        other.raw == raw;
  }

  @override
  String toString() => "$InAppPurchaseProduct#$hashCode($id)";
}

class InAppPurchaseOffering {
  final String id;
  final List<InAppPurchaseProduct> products;
  final Map<String, dynamic> configs;

  bool get isEmpty => products.isEmpty;

  const InAppPurchaseOffering.empty()
      : id = '',
        products = const [],
        configs = const {};

  const InAppPurchaseOffering({
    required this.id,
    required this.products,
    required this.configs,
  });

  @override
  int get hashCode => id.hashCode ^ products.hashCode ^ configs.hashCode;

  @override
  bool operator ==(Object other) {
    return other is InAppPurchaseOffering &&
        other.id == id &&
        other.products == products &&
        other.configs == configs;
  }

  @override
  String toString() {
    return "$InAppPurchaseOffering#$hashCode(id: $id, packages: $products, configs: $configs)";
  }
}
