import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isoft/components/navigation_drawer.dart';
import 'package:isoft/l10n/language_constants.dart';
import 'package:isoft/main.dart';
import 'package:isoft/routes/router_generator.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translation(context).settings),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            buildSettingsSwitch(
                icon: Icons.dark_mode_outlined,
                title: translation(context).dark_mode),
            buildSettingsItem(
                icon: Icons.language_outlined,
                title: translation(context).language,
                route: Routers.languageSettings),
            buildSettingsItem(
                icon: Icons.notifications_outlined,
                title: translation(context).notifications),
            buildSettingsItem(
                icon: Icons.info_outline_rounded,
                title: translation(context).about_app),
          ],
        ),
      ),
    );
  }

  Widget buildSettingsItem(
      {required IconData icon, required String title, String? route}) {
    return GestureDetector(
      onTap: route == null
          ? null
          : () {
              Navigator.of(context).pushNamed(route);
            },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: Colors.black12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(0.0),
                          bottomRight: Radius.circular(12.0),
                          topLeft: Radius.circular(12.0),
                          bottomLeft: Radius.circular(0.0)),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      icon,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  Text(
                    title,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: Theme.of(context).focusColor,
              size: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget buildSettingsSwitch({required IconData icon, required String title}) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: Colors.black12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(0.0),
                          bottomRight: Radius.circular(12.0),
                          topLeft: Radius.circular(12.0),
                          bottomLeft: Radius.circular(0.0)),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      icon,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  Text(
                    title,
                  ),
                ],
              ),
            ),
            Switch(
                value: isDarkTheme,
                onChanged: (value) {
                  setState(() {
                    isDarkTheme = value;
                  });
                })
          ],
        ),
      ),
      onTap: () {
        print('Hello world');
      },
    );
  }
}

class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({Key? key}) : super(key: key);

  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  Language? currentLanguage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getLocale().then((value) {
      setState(() {
        currentLanguage = Language.languageList()
            .where((element) => element.languageCode == value.languageCode)
            .first;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translation(context).choose_language),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFBBDEFB),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: Language.languageList()
              .map<RadioListTile<Language>>((lang) => RadioListTile<Language>(
              value: lang,
              title: Text(lang.name),
            onChanged: (Language? language) async {
              if (language != null) {
                setState(() {
                  currentLanguage = language;
                });
                Locale locale = await setLocale(language.languageCode);
                MyApp.setLocale(context, locale);
              }
            },
              groupValue: currentLanguage,

          ))
              .toList(),
          /*RadioListTile(
              title: Text("Hello world"),
              value: 1,
              groupValue: 1,
              onChanged: (value) {}),*/
        ),
      ),
    );
  }
}
