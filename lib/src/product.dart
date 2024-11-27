enum PurchaseStatus {
  none,
  purchasing,
  purchased,
  purchasingFailed,
  restoring,
  restored,
  restoringFailed,
}

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
}
