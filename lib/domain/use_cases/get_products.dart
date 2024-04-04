import 'package:mitsubishi_motors_parts_e_commerce/domain/entities/product.dart';

import '../../data/repository/user_repository.dart';
import '../entities/user.dart';

class GetProducts {
  var repository = UserRepository();

  Future<List<Product>> execute(User user) {
    return repository.getProducts(user);
  }
}
