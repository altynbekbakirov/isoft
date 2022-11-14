import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isoft/models/navigation_provider.dart';
import 'package:isoft/routes/router_generator.dart';
import 'package:provider/provider.dart';
import 'l10n/language_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void didChangeDependencies() {
    getLocale().then((value) => setLocale(value));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: NavigationProvider()),
      ],
      child: MaterialApp(
          title: 'isoft',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: _locale,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.openSansTextTheme(
                Theme.of(context).textTheme),
          ),
          initialRoute: Routers.splash,
          routes: Routers.routers),
    );
  }

  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }
}
