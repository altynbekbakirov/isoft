import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const String rememberMe = 'rememberMe';
const String langCode = 'languageCode';
const String activeCompany = 'activeCompany';
const String activeCurrency = 'activeCurrency';
const String activeWare = 'activeWare';
const String activeAccount = 'activeAccount';

const String english = 'en';
const String russian = 'ru';
const String turkish = 'tr';

Future setActiveAccount(int account) async {
  final _prefs = await SharedPreferences.getInstance();
  _prefs.setInt(activeAccount, account);
}

Future<int> getActiveAccount() async {
  final _prefs = await SharedPreferences.getInstance();
  return await _prefs.getInt(activeAccount) ?? 0;
}

Future setActiveWare(int ware) async {
  final _prefs = await SharedPreferences.getInstance();
  await _prefs.setInt(activeWare, ware);
}

Future<int> getActiveWare() async {
  final _prefs = await SharedPreferences.getInstance();
  return await _prefs.getInt(activeWare) ?? 0;
}

Future setActiveCurrency(int currency) async {
  final _prefs = await SharedPreferences.getInstance();
  await _prefs.setInt(activeCurrency, currency);
}

Future<int> getActiveCurrency() async {
  final _prefs = await SharedPreferences.getInstance();
  return await _prefs.getInt(activeCurrency) ?? 0;
}

Future setActiveCompany(int company) async {
  final _prefs = await SharedPreferences.getInstance();
  await _prefs.setInt(activeCompany, company);
}

Future<int> getActiveCompany() async {
  final _prefs = await SharedPreferences.getInstance();
  return await _prefs.getInt(activeCompany) ?? 0;
}

Future deleteActiveCompany() async {
  final _prefs = await SharedPreferences.getInstance();
  await _prefs.remove(activeCompany);
}

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

Future<Locale> setSharedLocale(String languageCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(langCode, languageCode);
  return _locale(languageCode);
}

Future<Locale> getSharedLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String languageCode = prefs.getString(langCode) ?? getDeviceLocale();
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case english:
      return const Locale(english, '');
    case russian:
      return const Locale(russian, '');
    case turkish:
      return const Locale(turkish, '');
    default:
      return const Locale(english, '');
  }
}

AppLocalizations translation(BuildContext context) {
  return AppLocalizations.of(context)!;
}

String getDeviceLocale() {
  final String deviceLocale = Platform.localeName;
  final String locale = deviceLocale.substring(0, 2);

  if (locale == 'en' || locale == 'ru' || locale == 'tr') {
    return locale;
  } else {
    return 'en';
  }
}

class Language extends Equatable {
  final int id;
  final String name;
  final String flag;
  final String languageCode;

  const Language(this.id, this.name, this.flag, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      const Language(1, "English", '🇺🇸', "en"),
      const Language(2, "Русский", '🇷🇺', "ru"),
      const Language(3, "Türkçe", '🇹🇷', "tr")
    ];
  }

  @override
  List<Object?> get props => [id, name, flag, languageCode];
}
