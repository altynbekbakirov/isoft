import 'package:flutter/cupertino.dart';
import 'package:isoft/models/currency_model.dart';

class CurrencyProvider extends ChangeNotifier {
  Currency? _activeCurrency;

  Currency get activeCurrency =>
      _activeCurrency ??
      Currency(id: 0, firmNr: 0, curType: 0, curCode: '000', curName: 'name');

  void setActiveCurrency(Currency currency) {
    _activeCurrency = currency;
    notifyListeners();
  }
}
