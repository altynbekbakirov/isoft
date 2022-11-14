import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String rememberMe = 'rememberMe';

Future<bool> setRememberMe(bool remember) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setBool(rememberMe, remember);
  return remember;
}

Future<bool> getRememberMe() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool remember = prefs.getBool(rememberMe) ?? false;
  return remember;
}