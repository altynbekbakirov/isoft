import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const String langCode = 'languageCode';

const String english = 'en';
const String russian = 'ru';
const String turkish = 'tr';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(langCode, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String languageCode = prefs.getString(langCode) ?? english;
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