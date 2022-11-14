import 'package:isoft/models/product_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  String dbName = 'isoft.db';
  int dbVersion = 1;
  String productTable = 'products';

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
    final products =
        'CREATE TABLE $productTable(id INTEGER PRIMARY KEY AUTOINCREMENT, code TEXT NOT NULL, name TEXT NOT NULL, groupCode TEXT, markCode TEXT, remain INTEGER, price REAL);';
    db.execute(products);
  }

  Future<int> insertProduct(ProductModel model) async {
    var db = await instance.database;
    return await db.insert(productTable, model.toJson());
  }

  Future<int> updateProduct(ProductModel model) async {
    var db = await instance.database;
    return await db.update(productTable, model.toJson(),
        where: 'id = ?', whereArgs: [model.id]);
  }

  Future<int> deleteProduct(ProductModel model) async {
    var db = await instance.database;
    return await db
        .delete(productTable, where: 'id = ?', whereArgs: [model.id]);
  }

  Future<List<ProductModel>> getAllProducts() async {
    var db = await instance.database;
    var results = await db.query(productTable);
    return results.map((product) => ProductModel.fromJson(product)).toList();
  }
}
