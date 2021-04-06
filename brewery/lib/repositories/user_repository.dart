import 'package:brewery/models/user.dart';

abstract class UserRepository {
  User login(String email, String password);

  bool register(String email, String nick, String password);

  bool logout();
}

class FakeUserRepository extends UserRepository {
  @override
  User login(String email, String password) {
    return new User(id: 1, email: email, nick: "TestowyNick");
  }

  @override
  bool logout() {
    return true;
  }

  @override
  bool register(String email, String nick, String password) {
    return true;
  }
}
