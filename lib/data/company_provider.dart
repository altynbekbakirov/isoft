import 'package:flutter/cupertino.dart';
import 'package:isoft/models/company_model.dart';

class CompanyProvider extends ChangeNotifier {
  Company? _activeCompany;

  Company get activeCompany =>
      _activeCompany ??
      Company(
          id: 0,
          perNr: 0,
          nr: 0,
          title: 'OcOO Firma',
          currency: 1,
          name: 'OcOO Firma');

  void setActiveCompany(Company company) {
    _activeCompany = company;
    notifyListeners();
  }
}
