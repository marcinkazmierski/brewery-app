import 'dart:async';
import 'package:brewery/exceptions/exception.dart';
import 'package:brewery/models/user.dart';

abstract class UserRepository {
  Future<User> login(String email, String password);

  bool register(String email, String nick, String password);

  bool logout();
}

class FakeUserRepository extends UserRepository {
  Future<User> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw new ValidateException("Invalid login or password. Try again!");
    }
    await Future.delayed(Duration(seconds: 1));
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
