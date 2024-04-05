import 'dart:convert';
import 'dart:io';

import 'package:mitsubishi_motors_parts_e_commerce/data/datasource/source.dart';
import 'package:http/http.dart' as http;
import 'package:mitsubishi_motors_parts_e_commerce/domain/entities/add_product_dto.dart';
import 'package:mitsubishi_motors_parts_e_commerce/domain/use_cases/add_product.dart';

class ProductionSource extends Source {
  static const URL =
      "https://app.actualsolusi.com/bsi/MitsubishiMotorsPartsECommerce/api";

  @override
  Future<String> login(Map<String, dynamic> user) async {
    var response = await http.post(Uri.parse('$URL/Admins/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          'Username': user['username'],
          'Password': user['password']
        }));
    return response.body;
  }

  Future<String> getProducts(Map<String, dynamic> user) async {
    var response =
        await http.get(Uri.parse('$URL/Products'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${user['token']}'
    });
    return response.body;
  }

  Future<String> deleteProduct(Map<String, dynamic> user, int id) async {
    var response = await http
        .delete(Uri.parse('$URL/Products/$id'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${user['token']}'
    });
    return response.statusCode.toString();
  }

  Future<String> addProduct(
      Map<String, dynamic> user, AddProductDto product) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$URL/Products/upload'));
    request.headers['Authorization'] = 'Bearer ${user['token']}';

    request.fields['ProductName'] = product.productName;
    request.fields['CategoryID'] = product.categoryId.toString();
    request.fields['Description'] = product.description;
    request.fields['Price'] = product.price.toString();
    request.fields['StockQuantity'] = product.stockQuantity.toString();

    // Add file to the request
    if (product.imageUrl != null) {
      request.files.add(
        await http.MultipartFile.fromPath('file', product.imageUrl!.path),
      );
    }

    var response = await request.send();

    return response.statusCode.toString();
  }

  Future<String> updateProduct(
      Map<String, dynamic> user, Map<String, dynamic> product) async {
    var response =
        await http.put(Uri.parse('$URL/Products/${product['ProductID']}'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${user['token']}'
            },
            body: jsonEncode(product));
    print('response status code: ${response.statusCode}');
    return response.statusCode.toString();
  }

  @override
  Future<String> getCategories(Map<String, dynamic> user) async {
    var response =
        await http.get(Uri.parse('$URL/Categories'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${user['token']}'
    });
    return response.body;
  }
}
