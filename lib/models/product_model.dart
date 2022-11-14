class ProductModel {
  final int id;
  final String code;
  final String name;
  String? groupCode;
  String? markCode;
  final double remain;
  double price;
  int count;
  double newPrice;

  ProductModel(
      {required this.id,
      required this.code,
      required this.name,
      this.groupCode,
      this.markCode,
      required this.remain,
      this.price = 0,
      this.count = 0,
      this.newPrice = 0});

  @override
  String toString() {
    return 'ProductModel{id: $id, code: $code, name: $name, groupCode: $groupCode, markCode: $markCode, remain: $remain, price: $price, count: $count, newPrice: $newPrice}';
  }

  Map<String, Object?> toJson() {
    Map<String, dynamic> map = {
      'id': id,
      'code': code,
      'name': name,
      'groupCode': groupCode,
      'markCode': markCode,
      'remain': remain,
      'price': price
    };
    return map;
  }

  static ProductModel fromJson(Map<String, dynamic> json) {
    return ProductModel(
        id: json['id'],
        code: json['code'],
        name: json['name'],
        groupCode: json['groupCode'],
        markCode: json['markCode'],
        remain: json['remain'],
        price: json['price']);
  }
}
