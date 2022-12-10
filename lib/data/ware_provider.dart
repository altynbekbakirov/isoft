import 'package:flutter/cupertino.dart';
import 'package:isoft/models/warehouse_model.dart';

class WareProvider extends ChangeNotifier {
  Ware? _ware;

  Ware get getActiveWare => _ware ?? Ware(id: 0, name: 'name', nr: 0, firmNr: 0);

  void setActiveWare(Ware ware) {
    _ware = ware;
    notifyListeners();
  }
}
