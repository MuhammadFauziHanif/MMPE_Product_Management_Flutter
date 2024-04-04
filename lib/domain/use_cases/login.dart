import 'package:mitsubishi_motors_parts_e_commerce/data/repository/user_repository.dart';

import '../entities/user.dart';

class Login {
  var repository = UserRepository();

  Future<User> execute(User user) {
    return repository.login(user);
  }
}
