import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isoft/data/company_provider.dart';
import 'package:isoft/data/currency_provider.dart';
import 'package:isoft/data/db_helper.dart';
import 'package:isoft/data/shared_prefs.dart';
import 'package:isoft/data/ware_provider.dart';
import 'package:isoft/models/company_model.dart';
import 'package:isoft/models/currency_model.dart';
import 'package:isoft/models/warehouse_model.dart';
import 'package:provider/provider.dart';

Future<bool> onWillPop(BuildContext context, DateTime timeBackPressed) async {
  final difference = DateTime.now().difference(timeBackPressed);
  final isExitWarning = difference >= Duration(seconds: 2);

  timeBackPressed = DateTime.now();

  if (isExitWarning) {
    Fluttertoast.showToast(
        msg: translation(context).press_back_again_to_exit, fontSize: 14);
    return false;
  } else {
    Fluttertoast.cancel();
    return true;
  }
}

List<Company> companies = [];
List<Currency> currencies = [];
List<Ware> wares = [];
int currentCompany = 0;
int currentCurrency = 0;
int currentWare = 0;

Future getCompanyIDFromShared() async {
  await getActiveCompany().then((value) {
    currentCompany = value;
  });
}

Future getCompaniesFromDB(BuildContext context) async {
  DatabaseHelper.instance.getCompanies().then((value) async {
    companies = value;
    await getCompanyIDFromShared();
    if (companies.length > 0) {
      if (currentCompany == 0) {
        await setActiveCompany(companies[0].id);
        Provider.of<CompanyProvider>(context, listen: false)
            .setActiveCompany(companies[0]);
      } else {
        int selectedCompany =
            companies.where((element) => element.id == currentCompany).first.id;
        if (selectedCompany == 0) {
          await setActiveCompany(companies[0].id);
          Provider.of<CompanyProvider>(context, listen: false)
              .setActiveCompany(companies[0]);
        } else {
          Company company =
              companies.where((element) => element.id == currentCompany).first;
          await setActiveCompany(company.id);
          Provider.of<CompanyProvider>(context, listen: false)
              .setActiveCompany(company);
        }
      }
    }
  });
}

Future getCurrencyIDFromShared() async {
  await getActiveCurrency().then((value) {
    currentCurrency = value;
  });
}

Future getCurrenciesFromDB(BuildContext context, int companyID) async {
  DatabaseHelper.instance.getAllCurrencies(companyID).then((value) async {
    currencies = value;
    await getCurrencyIDFromShared();
    if (currencies.length > 0) {
      if (currentCurrency == 0) {
        await setActiveCurrency(currencies[0].id);
        Provider.of<CurrencyProvider>(context, listen: false)
            .setActiveCurrency(currencies[0]);
      } else {
        int selectedCurrency = currencies
            .where((element) => element.id == currentCurrency)
            .first
            .id;
        if (selectedCurrency == 0) {
          await setActiveCurrency(currencies[0].id);
          Provider.of<CurrencyProvider>(context, listen: false)
              .setActiveCurrency(currencies[0]);
        } else {
          Currency currency = currencies
              .where((element) => element.id == currentCurrency)
              .first;
          await setActiveCurrency(currency.id);
          Provider.of<CurrencyProvider>(context, listen: false)
              .setActiveCurrency(currency);
        }
      }
    }
  });
}

Future getWareIDFromShared() async {
  await getActiveWare().then((value) {
    currentWare = value;
  });
}

Future getWaresFromDB(BuildContext context, int companyID) async {
  DatabaseHelper.instance.getWares(companyID).then((value) async {
    wares = value;
    await getWareIDFromShared();
    if (wares.length > 0) {
      if (currentWare == 0) {
        await setActiveWare(wares[0].id);
        Provider.of<WareProvider>(context, listen: false)
            .setActiveWare(wares[0]);
      } else {
        int selectedWare =
            wares.where((element) => element.id == currentWare).first.id;
        if (selectedWare == 0) {
          await setActiveWare(wares[0].id);
          Provider.of<WareProvider>(context, listen: false)
              .setActiveWare(wares[0]);
        } else {
          Ware ware = wares.where((element) => element.id == currentWare).first;
          await setActiveWare(ware.id);
          Provider.of<WareProvider>(context, listen: false).setActiveWare(ware);
        }
      }
    }
  });
}
