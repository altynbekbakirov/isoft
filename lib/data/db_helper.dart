import 'package:isoft/models/account_model.dart';
import 'package:isoft/models/company_model.dart';
import 'package:isoft/models/currency_model.dart';
import 'package:isoft/models/period_model.dart';
import 'package:isoft/models/product_model.dart';
import 'package:isoft/models/warehouse_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  String dbName = 'isoft.db';
  int dbVersion = 1;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB(dbName);
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, dbName);
    return await openDatabase(path, version: dbVersion, onCreate: _create);
  }

  Future _create(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER';
    final doubleType = 'REAL';

    final company = 'CREATE TABLE $companyTable('
        '${CompanyFields.id} $integerType, '
        '${CompanyFields.perNr} $integerType, '
        '${CompanyFields.nr} $integerType,'
        '${CompanyFields.currency} $integerType, '
        '${CompanyFields.title} $textType, '
        '${CompanyFields.name} $textType)';

    final period = 'CREATE TABLE $periodTable('
        '${PeriodFields.nr} $integerType, '
        '${PeriodFields.firmNr} $integerType, '
        '${PeriodFields.begDate} $textType, '
        '${PeriodFields.endDate} $textType, '
        '${PeriodFields.active} $integerType)';

    final ware = 'CREATE TABLE $wareTable('
        '${WareFields.id} $integerType, '
        '${WareFields.name} $textType, '
        '${WareFields.nr} $integerType, '
        '${WareFields.firmNr} $integerType)';

    db.execute(company);
    db.execute(period);
    db.execute(ware);
  }

  Future createTables(int companyID) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER';
    final doubleType = 'REAL';

    final db = await instance.database;

    final currency_table =
        'CREATE TABLE ${currencyTable}_${intFixed(companyID, 3)}('
        '${CurrencyFields.id} $integerType, '
        '${CurrencyFields.firmNr} $integerType, '
        '${CurrencyFields.curType} $integerType, '
        '${CurrencyFields.curCode} $textType, '
        '${CurrencyFields.curName} $textType, '
        '${CurrencyFields.curSymbol} $textType)';

    final account_table =
        'CREATE TABLE ${accountTable}_${intFixed(companyID, 3)}('
        '${AccountFields.id} $integerType,'
        '${AccountFields.code} $textType,'
        '${AccountFields.name} $textType,'
        '${AccountFields.address} $textType,'
        '${AccountFields.phone} $textType,'
        '${AccountFields.debit} $doubleType,'
        '${AccountFields.credit} $doubleType,'
        '${AccountFields.balance} $doubleType)';

    final product_table =
        'CREATE TABLE ${productTable}_${intFixed(companyID, 3)}('
        '${ProductFields.id} $integerType,'
        '${ProductFields.code} $textType,'
        '${ProductFields.name} $textType,'
        '${ProductFields.group} $textType,'
        '${ProductFields.unit} $textType,'
        '${ProductFields.onHand} $doubleType,'
        '${ProductFields.purchasePrice} $doubleType,'
        '${ProductFields.salePrice} $doubleType)';

    if (await checkIfTableExists(
        '${currencyTable}_${intFixed(companyID, 3)}')) {
      truncateCurrency(companyID);
    } else {
      db.execute(currency_table);
    }

    if (await checkIfTableExists('${accountTable}_${intFixed(companyID, 3)}')) {
      truncateAccount(companyID);
    } else {
      db.execute(account_table);
    }

    if (await checkIfTableExists('${productTable}_${intFixed(companyID, 3)}')) {
      truncateProduct(companyID);
    } else {
      db.execute(product_table);
    }
  }

  Future<List<Company>> getCompanies() async {
    final db = await instance.database;
    final result = await db.query(companyTable);
    return result.map((e) => Company.fromJson(e)).toList();
  }

  Future<int> insertCompany(Company company) async {
    final db = await instance.database;
    return await db.insert(companyTable, company.toJson());
  }

  Future<int> updateCompany(Company company) async {
    final db = await instance.database;
    return await db.update(companyTable, company.toJson(),
        where: '${CompanyFields.id} = ?', whereArgs: [company.id]);
  }

  Future<int> deleteCompany(int id) async {
    final db = await instance.database;
    return await db
        .delete(companyTable, where: '${CompanyFields.id}', whereArgs: [id]);
  }

  Future<int> getActiveCompany(int id) async {
    final db = await instance.database;
    final result =
        await db.query(companyTable, where: 'id = ?', whereArgs: [id]);
    return await Company.fromJson(result.first).id;
  }

  Future truncateCompany() async {
    final db = await instance.database;
    await db.delete(companyTable);
  }

  Future<List<Period>> getPeriods() async {
    final db = await instance.database;
    final result = await db.query(periodTable);
    return result.map((e) => Period.fromJson(e)).toList();
  }

  Future<int> insertPeriod(Period period) async {
    final db = await instance.database;
    return db.insert(periodTable, period.toJson());
  }

  Future truncatePeriod() async {
    final db = await instance.database;
    return db.delete(periodTable);
  }

  Future<List<Ware>> getWares(int companyID) async {
    final db = await instance.database;
    final result = await db.query(wareTable, where: 'firmnr = ?', whereArgs: [companyID]);
    return result.map((e) => Ware.fromJson(e)).toList();
  }

  Future<int> insertWare(Ware ware) async {
    final db = await instance.database;
    return db.insert(wareTable, ware.toJson());
  }

  Future truncateWare() async {
    final db = await instance.database;
    await db.delete(wareTable);
  }

  Future<int> insertCurrency(Currency model, int companyID) async {
    final db = await instance.database;
    return await db.insert(
        '${currencyTable}_${intFixed(companyID, 3)}', model.toJson());
  }

  Future truncateCurrency(int companyID) async {
    final db = await instance.database;
    return await db.delete('${currencyTable}_${intFixed(companyID, 3)}');
  }

  Future<int> insertAccount(Account model, int companyID) async {
    final db = await instance.database;
    return await db.insert(
        '${accountTable}_${intFixed(companyID, 3)}', model.toJson());
  }

  Future truncateAccount(int companyID) async {
    final db = await instance.database;
    return await db.delete('${accountTable}_${intFixed(companyID, 3)}');
  }

  Future<List<Account>> getAllAccounts(int companyID) async {
    final db = await instance.database;
    final results = await db.query('${accountTable}_${intFixed(companyID, 3)}');
    return results.map((product) => Account.fromJson(product)).toList();
  }

  Future<int> insertProduct(Product model, int companyID) async {
    final db = await instance.database;
    return await db.insert(
        '${productTable}_${intFixed(companyID, 3)}', model.toJson());
  }

  Future<int> updateProduct(Product model, int companyID) async {
    final db = await instance.database;
    return await db.update(
        '${productTable}_${intFixed(companyID, 3)}', model.toJson(),
        where: '${ProductFields.id} = ?', whereArgs: [model.id]);
  }

  Future<int> deleteProduct(int id, int companyID) async {
    final db = await instance.database;
    return await db.delete('${productTable}_${intFixed(companyID, 3)}',
        where: '${ProductFields.id} = ?', whereArgs: [id]);
  }

  Future<List<Product>> getAllProducts(int companyID) async {
    final db = await instance.database;
    final results = await db.query('${productTable}_${intFixed(companyID, 3)}');
    return results.map((product) => Product.fromJson(product)).toList();
  }

  Future<List<Currency>> getAllCurrencies(int companyID) async {
    final db = await instance.database;
    final results =
        await db.query('${currencyTable}_${intFixed(companyID, 3)}');
    return results.map((currency) => Currency.fromJson(currency)).toList();
  }

  Future<Currency> getCurrencyByID(int companyID, int currencyID) async {
    final db = await instance.database;
    final results = await db.query('${currencyTable}_${intFixed(companyID, 3)}',
        where: 'id = ?', whereArgs: [currencyID]);
    return results
        .map((currency) => Currency.fromJson(currency))
        .toList()
        .first;
  }

  Future<int> truncateProduct(int companyID) async {
    final db = await instance.database;
    return await db.delete('${productTable}_${intFixed(companyID, 3)}');
  }

  Future<bool> checkIfTableExists(String table) async {
    final db = await instance.database;
    String checkExistTable =
        "SELECT * FROM sqlite_master WHERE name ='$table' and type='table'";
    final checkExist = await db.rawQuery(checkExistTable);
    if (checkExist.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  String intFixed(int n, int count) => n.toString().padLeft(count, "0");
}
