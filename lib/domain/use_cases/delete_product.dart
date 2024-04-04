import 'package:mitsubishi_motors_parts_e_commerce/domain/entities/product.dart';

import '../../data/repository/user_repository.dart';
import '../entities/user.dart';

class DeleteProduct {
  var repository = UserRepository();

  Future<bool> execute(User user, int id) {
    return repository.deleteProduct(user, id);
  }
}
