import 'package:mitsubishi_motors_parts_e_commerce/data/datasource/source.dart';

class TestSource extends Source {
  @override
  Future<String> deleteProduct(Map<String, dynamic> user, int id) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  @override
  Future<String> addProduct(
      Map<String, dynamic> user, Map<String, dynamic> product) {
    // TODO: implement addProduct
    throw UnimplementedError();
  }

  @override
  Future<String> updateProduct(
      Map<String, dynamic> user, Map<String, dynamic> product) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }

  @override
  Future<String> getCategories(Map<String, dynamic> user) {
    // TODO: implement getCategories
    throw UnimplementedError();
  }

  @override
  Future<String> getProducts(Map<String, dynamic> user) {
    // TODO: implement getProducts
    throw UnimplementedError();
  }

  @override
  Future<String> login(Map<String, dynamic> user) {
    // TODO: implement login
    throw UnimplementedError();
  }
}
