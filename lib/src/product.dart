class PurchasableProduct<T> {
  final String id;
  final String title;
  final String description;
  final double price;
  final String priceString;
  final String currency;

  final T product;

  const PurchasableProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.priceString,
    required this.currency,
    required this.product,
  });

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      price.hashCode ^
      priceString.hashCode ^
      currency.hashCode ^
      product.hashCode;

  @override
  bool operator ==(Object other) {
    return other is PurchasableProduct<T> &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.price == price &&
        other.priceString == priceString &&
        other.currency == currency &&
        other.product == product;
  }

  @override
  String toString() {
    return "$PurchasableProduct#$hashCode(id: $id, title: $title, description: $description, price: $price, priceString: $priceString, currency: $currency, product: $product)";
  }
}

class PurchasableOffering<T> {
  final String id;
  final List<T> products;

  bool get isEmpty => products.isEmpty;

  const PurchasableOffering.empty()
      : id = '',
        products = const [];

  const PurchasableOffering({
    required this.id,
    required this.products,
  });

  @override
  int get hashCode => id.hashCode ^ products.hashCode;

  @override
  bool operator ==(Object other) {
    return other is PurchasableOffering<T> &&
        other.id == id &&
        other.products == products;
  }

  @override
  String toString() {
    return "$PurchasableOffering#$hashCode(id: $id, products: $products)";
  }
}
