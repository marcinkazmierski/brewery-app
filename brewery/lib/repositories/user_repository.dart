import 'package:brewery/models/user.dart';

abstract class UserRepository {
  User login(String login, String password);
}

class FakeUserRepository extends UserRepository {
  @override
  User login(String login, String password) {
    return new User(id: 1, email: login, nick: "TestowyNick");
  }
}
