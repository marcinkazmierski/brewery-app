import 'dart:async';
import 'package:brewery/exceptions/exception.dart';
import 'package:brewery/models/user.dart';

abstract class UserRepository {
  User getCurrentUser();

  Future<User> login(String email, String password);

  Future<bool> register(String email, String nick, String password);

  Future<bool> logout();
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
  Future<bool> logout() async {
    return true;
  }

  @override
  Future<bool> register(String email, String nick, String password) async {
    return email.isNotEmpty && nick.isNotEmpty && password.isNotEmpty;
  }

  @override
  User getCurrentUser() {
    return new User(id: 1, email: "email@test.com", nick: "TestowyNick");
  }
}
