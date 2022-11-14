import 'package:flutter/cupertino.dart';
import 'package:isoft/models/navigation_item.dart';

class NavigationProvider extends ChangeNotifier {
  NavigationItem _navigationItem = NavigationItem.home;

  NavigationItem get navigationItem => _navigationItem;

  void setNavigationItem(NavigationItem value) {
    _navigationItem = value;
    notifyListeners();
  }
}