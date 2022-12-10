import 'package:flutter/cupertino.dart';
import 'package:isoft/models/account_model.dart';

class AccountProvider extends ChangeNotifier {
  Account? _account;

  Account get activeAccount => _account ?? Account(id: 0, code: 'code', name: 'name');

  void setActiveAccount(Account account) {
    _account = account;
    notifyListeners();
  }
}