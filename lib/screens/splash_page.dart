import 'package:flutter/material.dart';
import 'package:isoft/data/db_helper.dart';
import 'package:isoft/data/shared_prefs.dart';
import 'package:isoft/models/account_model.dart';
import 'package:isoft/models/company_model.dart';
import 'package:isoft/models/currency_model.dart';
import 'package:isoft/models/period_model.dart';
import 'package:isoft/models/product_model.dart';
import 'package:isoft/models/warehouse_model.dart';
import 'package:isoft/routes/router_generator.dart';
import 'package:isoft/services/api_services.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late List<Company> companies;
  late List<Period> periods;
  late List<Ware> wares;
  late List<Account> accounts;
  late List<Product> products;
  late List<Currency> currencies;
  late int lastPeriodNr;

  Future getData() async {
    companies = await ApiServices.getCompany();
    if (companies.isNotEmpty) {
      await DatabaseHelper.instance.truncateCompany();
      await DatabaseHelper.instance.truncatePeriod();
      await DatabaseHelper.instance.truncateWare();

      for (Company company in companies) {
        await DatabaseHelper.instance.insertCompany(company);
        await DatabaseHelper.instance.createTables(company.id);

        periods = await ApiServices.getPeriod(company.id);
        for (Period period in periods) {
          await DatabaseHelper.instance.insertPeriod(period);
          lastPeriodNr = period.nr;
        }

        wares = await ApiServices.getWare(company.id);
        if (wares.isNotEmpty) {
          for (Ware ware in wares) {
            await DatabaseHelper.instance.insertWare(ware);
          }
        }

        currencies = await ApiServices.getCurrency(company.id);
        if (currencies.isNotEmpty) {
          for (Currency currency in currencies) {
            await DatabaseHelper.instance.insertCurrency(currency, company.id);
          }
        }

        accounts = await ApiServices.getAccounts(company.id, lastPeriodNr);
        if (accounts.isNotEmpty) {
          for (Account account in accounts) {
            await DatabaseHelper.instance.insertAccount(account, company.id);
          }
        }

        products = await ApiServices.getProducts(company.id, lastPeriodNr);
        if (products.isNotEmpty) {
          for (Product product in products) {
            await DatabaseHelper.instance.insertProduct(product, company.id);
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    _navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(
              height: 24,
            ),
            Text(translation(context).splash_data_loading),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              child: LinearProgressIndicator(),
              width: 200,
            ),
            const SizedBox(
              height: 12,
            ),
            // Text('Product list downloading'),
          ],
        ),
      ),
    );
  }

  Future _navigateToHome() async {
    await Future.delayed(
      Duration(seconds: 10),
    );
    await Navigator.of(context).pushReplacementNamed(Routers.home);
  }
}
