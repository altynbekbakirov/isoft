import 'package:isoft/screens/accounts_page.dart';
import 'package:isoft/screens/home_page.dart';
import 'package:isoft/screens/login_page.dart';
import 'package:isoft/screens/product_transactions_page.dart';
import 'package:isoft/screens/products_open_scraps_page.dart';
import 'package:isoft/screens/products_open_slips_page.dart';
import 'package:isoft/screens/products_page.dart';
import 'package:isoft/screens/purchases_invoices_page.dart';
import 'package:isoft/screens/purchases_orders_page.dart';
import 'package:isoft/screens/safe_transactions_page.dart';
import 'package:isoft/screens/sales_invoices_page.dart';
import 'package:isoft/screens/sales_orders_page.dart';
import 'package:isoft/screens/sales_returns_page.dart';
import 'package:isoft/screens/settings_page.dart';
import 'package:isoft/screens/splash_page.dart';

class Routers {
  static const home = '/';
  static const splash = '/splash';
  static const login = '/login';
  static const settings = '/settings';
  static const languageSettings = '/language_settings';
  static const products = '/products';
  static const accounts = '/accounts';
  static const salesOrders = '/sales_orders';
  static const salesInvoices = '/sales_invoices';
  static const salesReturns = '/sales_returns';
  static const purchasesOrders = '/purchases_orders';
  static const purchasesInvoices = '/purchases_invoices';
  static const productTransactions = '/product_transactions';
  static const openSlips = '/open_slips';
  static const scrapSlips = '/scrap_slips';
  static const safeTransactions = '/safe_transactions';

  static dynamic routers = {
    home: (context) => HomePage(),
    splash: (context) => SplashPage(),
    login: (context) => LoginPage(),
    settings: (context) => SettingsPage(),
    languageSettings: (context) => LanguageSettingsPage(),
    products: (context) => ProductsPage(),
    accounts: (context) => AccountsPage(),
    salesOrders: (context) => SalesOrdersPage(),
    salesInvoices: (context) => SalesInvoicesPage(),
    salesReturns: (context) => SalesReturnsPage(),
    purchasesOrders: (context) => PurchasesOrdersPage(),
    purchasesInvoices: (context) => PurchasesInvoicesPage(),
    productTransactions: (context) => ProductsTransactionsPage(),
    openSlips: (context) => ProductsOpenSlipsPage(),
    scrapSlips: (context) => ProductsOpenScrapsPage(),
    safeTransactions: (context) => SafeTransactionsPage(),
  };
}
