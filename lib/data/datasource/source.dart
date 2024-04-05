import 'package:mitsubishi_motors_parts_e_commerce/domain/entities/add_product_dto.dart';

abstract class Source {
  Future<String> login(Map<String, dynamic> user);
  Future<String> getProducts(Map<String, dynamic> user);
  Future<String> deleteProduct(Map<String, dynamic> user, int id);
  Future<String> addProduct(Map<String, dynamic> user, AddProductDto product);
  Future<String> updateProduct(
      Map<String, dynamic> user, Map<String, dynamic> product);
  Future<String> getCategories(Map<String, dynamic> user);
}
