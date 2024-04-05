import 'package:mitsubishi_motors_parts_e_commerce/domain/entities/product.dart';
import 'package:mitsubishi_motors_parts_e_commerce/domain/entities/update_product_dto.dart';

import '../../data/repository/user_repository.dart';
import '../entities/user.dart';

class EditProduct {
  var repository = UserRepository();

  Future<bool> execute(User user, UpdateProductDto product) {
    return repository.editProduct(user, product);
  }
}
