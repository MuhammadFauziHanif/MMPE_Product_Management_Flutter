import 'package:mitsubishi_motors_parts_e_commerce/domain/entities/product.dart';

import '../../data/repository/user_repository.dart';
import '../entities/user.dart';

class AddProduct {
  var repository = UserRepository();

  Future<Product> execute(User user, Product product) {
    return repository.addProduct(user, product);
  }
}
