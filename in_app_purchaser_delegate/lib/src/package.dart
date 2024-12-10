import 'dart:convert';

class InAppPackage {
  final String? id;
  final String? abTestingId;
  final String? plan;
  final String? body;
  final String? details;
  final double? price;
  final String? priceString;
  final double? discount;
  final String? currency;
  final String? currencySign;

  final Object? raw;

  const InAppPackage({
    this.id,
    this.abTestingId,
    this.plan,
    this.body,
    this.details,
    this.price,
    this.priceString,
    this.discount,
    this.currency,
    this.currencySign,
    this.raw,
  });

  factory InAppPackage.from(Object? source) {
    if (source is! Map) return InAppPackage();
    final id = source["id"];
    final abTestingId = source["ab_testing_id"] ?? source["abTestingId"];
    final plan = source["plan"];
    final body = source["body"];
    final details = source["details"];
    final price = source["price"];
    final priceString = source["price_string"] ?? source["priceString"];
    final discount = source["discount"];
    final currency = source["currency"];
    final currencySign = source["currency_sign"] ?? source["currencySign"];
    return InAppPackage(
      id: id is String ? id : id.toString(),
      abTestingId: abTestingId is String ? abTestingId : null,
      plan: plan is String ? plan : null,
      body: body is String ? body : null,
      details: details is String ? details : null,
      price: price is num ? price.toDouble() : null,
      priceString: priceString is String ? priceString : null,
      discount: discount is num ? discount.toDouble() : null,
      currency: currency is String ? currency : null,
      currencySign: currencySign is String ? currencySign : null,
    );
  }

  Map<String, dynamic> get source {
    return {
      "id": id,
      "ab_testing_id": abTestingId,
      "plan": plan,
      "body": body,
      "details": details,
      "price": price,
      "price_string": priceString,
      "discount": discount,
      "currency": currency,
      "currency_sign": currencySign,
    };
  }

  String get json => jsonEncode(source);

  @override
  int get hashCode => json.hashCode;

  @override
  bool operator ==(Object other) {
    return other is InAppPackage && other.json == json;
  }

  @override
  String toString() => "$InAppPackage#$hashCode($json)";
}
