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
