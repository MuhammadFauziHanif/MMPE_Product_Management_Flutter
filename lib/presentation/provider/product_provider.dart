import 'package:flutter/cupertino.dart';
import 'package:mitsubishi_motors_parts_e_commerce/domain/entities/category.dart';
import 'package:mitsubishi_motors_parts_e_commerce/domain/use_cases/add_product.dart';
import 'package:mitsubishi_motors_parts_e_commerce/domain/use_cases/edit_product.dart';
import 'package:mitsubishi_motors_parts_e_commerce/domain/use_cases/get_categories.dart';
import 'package:mitsubishi_motors_parts_e_commerce/domain/use_cases/get_products.dart';
import 'package:mitsubishi_motors_parts_e_commerce/domain/use_cases/delete_product.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/product.dart';
import '../../domain/entities/user.dart';

class ProductProvider extends ChangeNotifier {
  var listProduct = <Product>[];
  var listCategory = <Category>[];
  SharedPreferences? prefs = null;

  Future<void> getProducts() async {
    prefs = await SharedPreferences.getInstance();
    var username = await prefs?.getString('username') ?? '';
    var token = await prefs?.getString('token') ?? '';

    listProduct =
        await GetProducts().execute(User(username: username, token: token));
    notifyListeners();
  }

  Future<void> deleteProduct(int id) async {
    prefs = await SharedPreferences.getInstance();
    var username = await prefs?.getString('username') ?? '';
    var token = await prefs?.getString('token') ?? '';

    await DeleteProduct().execute(User(username: username, token: token), id);
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    prefs = await SharedPreferences.getInstance();
    var username = await prefs?.getString('username') ?? '';
    var token = await prefs?.getString('token') ?? '';

    await AddProduct().execute(User(username: username, token: token), product);
    notifyListeners();
  }

  Future<void> editProduct(Product product) async {
    prefs = await SharedPreferences.getInstance();
    var username = await prefs?.getString('username') ?? '';
    var token = await prefs?.getString('token') ?? '';

    await EditProduct()
        .execute(User(username: username, token: token), product);
    notifyListeners();
  }

  Future<void> getCategories() async {
    prefs = await SharedPreferences.getInstance();
    var username = await prefs?.getString('username') ?? '';
    var token = await prefs?.getString('token') ?? '';

    listCategory =
        await GetCategories().execute(User(username: username, token: token));
    notifyListeners();
  }
}
