class ProductPriceModel {
  final int id;
  final int productId;
  final double price;
  final int priceType;
  final String begDate;
  final String endDate;
  final String currency;

  ProductPriceModel(
      {required this.id,
      required this.productId,
      required this.price,
      required this.priceType,
      required this.begDate,
      required this.endDate,
      required this.currency});
}
