import 'dart:convert';

import 'package:mitsubishi_motors_parts_e_commerce/domain/entities/category.dart';

import '../../domain/entities/product.dart';
import '../../domain/entities/user.dart';
import 'package:get_it/get_it.dart';

import '../datasource/source.dart';

final getIt = GetIt.instance;

class UserRepository {
  Future<User> login(User user) async {
    final source = getIt<Source>();
    var json = jsonDecode(await source.login(user.toJson()));
    return User.fromJson(json);
  }

  Future<List<Product>> getProducts(User user) async {
    final source = getIt<Source>();
    var jsonArray = jsonDecode(await source.getProducts(user.toJson()));
    print(jsonArray.toString());
    var listProduct = <Product>[];
    for (var i = 0; i < jsonArray.length; i++) {
      var product = Product.fromJson(jsonArray[i]);
      if (!product.imageUrl.startsWith('http')) {
        product.imageUrl =
            'https://app.actualsolusi.com/bsi/MitsubishiMotorsPartsECommerce/${product.imageUrl}';
      }
      listProduct.add(product);
    }
    return listProduct;
  }

  Future<bool> deleteProduct(User user, int id) async {
    final source = getIt<Source>();
    var response = jsonDecode(await source.deleteProduct(user.toJson(), id));
    return response == '200';
  }

  Future<Product> addProduct(User user, Product product) async {
    final source = getIt<Source>();
    var json = jsonDecode(await source.addProduct(user.toJson(), {
      'ProductName': product.productName,
      'CategoryID': product.categoryId,
      'Description': product.description,
      'Price': product.price,
      'StockQuantity': product.stockQuantity,
      'ImageUrl': product.imageUrl,
    }));
    return Product.fromJson(json);
  }

  Future<Product> editProduct(User user, Product product) async {
    final source = getIt<Source>();
    var json =
        jsonDecode(await source.updateProduct(user.toJson(), product.toJson()));
    return Product.fromJson(json);
  }

  Future<List<Category>> getCategories(User user) async {
    final source = getIt<Source>();
    var jsonArray = jsonDecode(await source.getCategories(user.toJson()));
    var listCategory = <Category>[];
    for (var i = 0; i < jsonArray.length; i++) {
      listCategory.add(Category.fromJson(jsonArray[i]));
    }
    return listCategory;
  }
}
