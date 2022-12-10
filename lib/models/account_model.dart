class Account {
  final int id;
  final String code;
  final String name;
  final String? address;
  final String? phone;
  final double debit;
  final double credit;
  final double balance;

  Account(
      {required this.id,
      required this.code,
      required this.name,
      this.address,
      this.phone,
      this.debit = 0,
      this.credit = 0,
      this.balance = 0});

  Map<String, dynamic> toJson() => {
        AccountFields.id: id,
        AccountFields.code: code,
        AccountFields.name: name,
        AccountFields.address: address,
        AccountFields.phone: phone,
        AccountFields.debit: debit,
        AccountFields.credit: credit,
        AccountFields.balance: balance
      };

  static Account fromJson(Map<String, dynamic> json) => Account(
      id: json[AccountFields.id] as int,
      code: json[AccountFields.code] as String,
      name: json[AccountFields.name] as String,
      address: json[AccountFields.address] as String,
      phone: json[AccountFields.phone] as String,
      debit: json[AccountFields.debit] as double,
      credit: json[AccountFields.credit] as double,
      balance: json[AccountFields.balance] as double);
}

final String accountTable = 'accounts';

class AccountFields {
  static final String id = 'id';
  static final String code = 'code';
  static final String name = 'name';
  static final String address = 'address';
  static final String phone = 'phone';
  static final String debit = 'debit';
  static final String credit = 'credit';
  static final String balance = 'balance';
}
