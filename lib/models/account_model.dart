class AccountModel {
  final int id;
  final String code;
  final String name;
  final String address;
  final String phone;
  final String email;
  final double netSales;
  final double netCollection;
  final double balance;

  AccountModel(
      {required this.id,
      required this.code,
      required this.name,
      this.address = '',
      this.phone = '',
      this.email = '',
      this.netSales = 0,
      this.netCollection = 0,
      this.balance = 0});
}
