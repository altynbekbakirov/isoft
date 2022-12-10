import 'dart:convert';
import 'package:http/http.dart';
import 'package:isoft/data/db_helper.dart';
import 'package:isoft/models/account_model.dart';
import 'package:isoft/models/company_model.dart';
import 'package:isoft/models/currency_model.dart';
import 'package:isoft/models/period_model.dart';
import 'package:isoft/models/product_model.dart';
import 'package:isoft/models/warehouse_model.dart';

final String endPoint = 'http://192.168.1.104:8080';

class ApiServices {
  static Future<List<Company>> getCompany() async {
    Response response = await get(Uri.parse(endPoint),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final List result = await jsonDecode(utf8.decode(response.bodyBytes));
      List<Company> companies = result.map((e) => Company.fromJson(e)).toList();
      return companies;
    } else {
      throw Exception(response.statusCode);
    }
  }

  static Future<List<Period>> getPeriod(int id) async {
    Response response = await get(Uri.parse('$endPoint/$id'),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final List result = await jsonDecode(utf8.decode(response.bodyBytes));
      return result.map((e) => Period.fromJson(e)).toList();
    } else {
      throw Exception(response.statusCode);
    }
  }

  static Future<List<Ware>> getWare(int id) async {
    Response response = await get(Uri.parse('$endPoint/$id/wares'),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final List result = await jsonDecode(utf8.decode(response.bodyBytes));
      return result.map((e) => Ware.fromJson(e)).toList();
    } else {
      throw Exception(response.statusCode);
    }
  }

  static Future<List<Currency>> getCurrency(int id) async {
    Response response = await get(Uri.parse('$endPoint/$id/currency'),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final List result = await jsonDecode(utf8.decode(response.bodyBytes));
      return result.map((e) => Currency.fromJson(e)).toList();
    } else {
      throw Exception(response.statusCode);
    }
  }

  static Future<List<Account>> getAccounts(int companyNo, int periodNo) async {
    final body = jsonEncode({"firmNo": companyNo, "periodNo": periodNo});
    Response response = await post(Uri.parse('$endPoint/accounts'),
        headers: {'Content-Type': 'application/json'}, body: body);
    if (response.statusCode == 200) {
      final List result = await jsonDecode(utf8.decode(response.bodyBytes));
      return result.map((e) => Account.fromJson(e)).toList();
    } else {
      throw Exception(response.statusCode);
    }
  }

  static Future<List<Product>> getProducts(int companyNo, int periodNo) async {
    final body = jsonEncode({"firmNo": companyNo, "periodNo": periodNo});
    Response response = await post(Uri.parse('$endPoint/products'),
        headers: {'Content-Type': 'application/json'}, body: body);
    if (response.statusCode == 200) {
      final List result = await jsonDecode(utf8.decode(response.bodyBytes));
      return result.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception(response.statusCode);
    }
  }
}
