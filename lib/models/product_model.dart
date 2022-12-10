class Product {
  final int id;
  final String code;
  final String name;
  final String group;
  final String? unit;
  final double? onHand;
  final double? purchasePrice;
  final double? salePrice;

  Product(
      {required this.id,
      required this.code,
      required this.name,
      required this.group,
      this.unit,
      this.onHand,
      this.purchasePrice,
      this.salePrice});

  Map<String, dynamic> toJson() => {
        ProductFields.id: id,
        ProductFields.code: code,
        ProductFields.name: name,
        ProductFields.group: group,
        ProductFields.unit: unit,
        ProductFields.onHand: onHand,
        ProductFields.purchasePrice: purchasePrice,
        ProductFields.salePrice: salePrice,
      };

  static Product fromJson(Map<String, dynamic> json) => Product(
      id: json[ProductFields.id],
      code: json[ProductFields.code],
      name: json[ProductFields.name],
      group: json[ProductFields.group] ?? '',
      unit: json[ProductFields.unit],
      onHand: json[ProductFields.onHand],
      purchasePrice: json[ProductFields.purchasePrice],
      salePrice: json[ProductFields.salePrice]);
}

final String productTable = 'products';

class ProductFields {
  static final String id = 'id';
  static final String code = 'code';
  static final String name = 'name';
  static final String group = 'group_code';
  static final String unit = 'unit';
  static final String onHand = 'on_hand';
  static final String purchasePrice = 'purchase_price';
  static final String salePrice = 'sale_price';
}
