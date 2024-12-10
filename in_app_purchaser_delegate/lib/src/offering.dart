class InAppOffering<T> {
  final String id;
  final List<T> products;

  bool get isEmpty => products.isEmpty;

  const InAppOffering.empty()
      : id = '',
        products = const [];

  const InAppOffering({
    required this.id,
    required this.products,
  });

  @override
  int get hashCode => id.hashCode ^ products.hashCode;

  @override
  bool operator ==(Object other) {
    return other is InAppOffering<T> &&
        other.id == id &&
        other.products == products;
  }

  @override
  String toString() {
    return "$InAppOffering#$hashCode(id: $id, products: $products)";
  }
}
