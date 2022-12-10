class Currency {
  final int id;
  final int firmNr;
  final int curType;
  final String curCode;
  final String curName;
  final String? curSymbol;

  Currency(
      {required this.id,
      required this.firmNr,
      required this.curType,
      required this.curCode,
      required this.curName,
      this.curSymbol});

  Map<String, dynamic> toJson() => {
        CurrencyFields.id: id,
        CurrencyFields.firmNr: firmNr,
        CurrencyFields.curType: curType,
        CurrencyFields.curCode: curCode,
        CurrencyFields.curName: curName,
        CurrencyFields.curSymbol: curSymbol,
      };

  static Currency fromJson(Map<String, dynamic> json) => Currency(
        id: json['id'],
        firmNr: json['firmNr'],
        curType: json['curType'],
        curCode: json['curCode'],
        curName: json['curName'],
        curSymbol: json['curSymbol'],
      );
}

final String currencyTable = 'currencies';

class CurrencyFields {
  static final String id = 'id';
  static final String firmNr = 'firmNr';
  static final String curType = 'curType';
  static final String curCode = 'curCode';
  static final String curName = 'curName';
  static final String curSymbol = 'curSymbol';
}
