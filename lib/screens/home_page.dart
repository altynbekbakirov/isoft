import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isoft/components/navigation_drawer.dart';
import 'package:isoft/data/company_provider.dart';
import 'package:isoft/data/shared_prefs.dart';
import 'package:isoft/services/data_services.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime timeBackPressed = DateTime.now();

  @override
  void initState() {
    super.initState();
    getCompaniesFromDB(context);
    getActiveCompany().then((value) => getCurrenciesFromDB(context, value));
    getActiveCompany().then((value) => getWaresFromDB(context, value));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= const Duration(seconds: 2);
        timeBackPressed = DateTime.now();
        if (isExitWarning) {
          Fluttertoast.showToast(
              msg: translation(context).press_back_again_to_exit, fontSize: 14);
          return false;
        } else {
          Fluttertoast.cancel();
          return true;
        }
      },
      child: Scaffold(
        drawer: NavigationDraw(),
        appBar: AppBar(
          title: Text(translation(context).home),
        ),
        body: Center(
            child: Text(
                'Current company: ${context.watch<CompanyProvider>().activeCompany.id}')),
      ),
    );
  }
}
