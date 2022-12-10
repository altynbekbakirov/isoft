import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isoft/data/account_provider.dart';
import 'package:isoft/data/company_provider.dart';
import 'package:isoft/data/currency_provider.dart';
import 'package:isoft/data/shared_prefs.dart';
import 'package:isoft/data/navigation_provider.dart';
import 'package:isoft/data/ware_provider.dart';
import 'package:isoft/routes/router_generator.dart';
import 'package:provider/provider.dart';

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
    getSharedLocale().then((value) => setLocale(value));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        ChangeNotifierProvider(create: (context) => CompanyProvider()),
        ChangeNotifierProvider(create: (context) => CurrencyProvider()),
        ChangeNotifierProvider(create: (context) => WareProvider()),
        ChangeNotifierProvider(create: (context) => AccountProvider()),
      ],
      child: MaterialApp(
          title: 'isoft',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: _locale,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme:
                GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
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
