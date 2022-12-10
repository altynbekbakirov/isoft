class Cart {
  final int id;
  final String code;
  final String name;
  double price;
  int count;
  double newPrice;

  Cart(
      {required this.id,
      required this.code,
      required this.name,
      this.price = 0,
      this.count = 0,
      this.newPrice = 0});

  @override
  String toString() {
    return 'ProductModel{id: $id, code: $code, name: $name, price: $price, count: $count, newPrice: $newPrice}';
  }

}

final String cartTable = 'carts';

class CartFields {
  static final String id = 'id';
  static final String code = 'code';
  static final String name = 'name';
  static final String price = 'price';
  static final String count = 'count';
  static final String newPrice = 'newPrice';
}
