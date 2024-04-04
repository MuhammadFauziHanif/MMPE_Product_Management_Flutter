import 'package:mitsubishi_motors_parts_e_commerce/domain/entities/category.dart';
import 'package:mitsubishi_motors_parts_e_commerce/domain/entities/product.dart';

import '../../data/repository/user_repository.dart';
import '../entities/user.dart';

class GetCategories {
  var repository = UserRepository();

  Future<List<Category>> execute(User user) {
    return repository.getCategories(user);
  }
}
