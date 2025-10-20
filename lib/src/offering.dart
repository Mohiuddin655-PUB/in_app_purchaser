class InAppPurchaseProduct {
  final String? id;
  final String? plan;
  final String? description;
  final double? price;
  final double? usdPrice;
  final String? priceString;
  final String? currencyCode;
  final String? currencySymbol;

  final Object? raw;

  const InAppPurchaseProduct({
    this.id,
    this.plan,
    this.description,
    this.price,
    this.usdPrice,
    this.priceString,
    this.currencyCode,
    this.currencySymbol,
    this.raw,
  });

  InAppPurchaseProduct copyWith({
    String? id,
    String? plan,
    String? description,
    double? price,
    double? usdPrice,
    String? priceString,
    String? currencyCode,
    String? currencySymbol,
    Object? raw,
  }) {
    return InAppPurchaseProduct(
      id: id ?? this.id,
      plan: plan ?? this.plan,
      description: description ?? this.description,
      price: price ?? this.price,
      usdPrice: usdPrice ?? this.usdPrice,
      priceString: priceString ?? this.priceString,
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      raw: raw ?? this.raw,
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      plan.hashCode ^
      description.hashCode ^
      price.hashCode ^
      usdPrice.hashCode ^
      priceString.hashCode ^
      currencyCode.hashCode ^
      currencySymbol.hashCode ^
      raw.hashCode;

  @override
  bool operator ==(Object other) {
    return other is InAppPurchaseProduct &&
        other.id == id &&
        other.plan == plan &&
        other.description == description &&
        other.price == price &&
        other.usdPrice == usdPrice &&
        other.priceString == priceString &&
        other.currencyCode == currencyCode &&
        other.currencySymbol == currencySymbol &&
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
    this.id = '',
    this.products = const [],
    this.configs = const {},
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
