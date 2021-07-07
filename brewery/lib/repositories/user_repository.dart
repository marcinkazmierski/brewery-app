import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:brewery/exceptions/exception.dart';
import 'package:brewery/models/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class UserRepository {
  User getCurrentUser();

  Future<User> login(String email, String password);

  Future<bool> register(String email, String nick, String password);

  Future<bool> logout();
}

class ApiUserRepository extends UserRepository {
  @override
  User getCurrentUser() {}

  @override
  Future<bool> logout() {}

  @override
  Future<bool> register(String email, String nick, String password) {}

  @override
  Future<User> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw new ValidateException("Invalid login or password. Try again!");
    }
    Map data = {'email': email, 'password': password};
    var body = json.encode(data);

    final response = await http.post(
        Uri.parse(dotenv.env['API_URL'].toString() + 'auth/authenticate'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
        },
        body: body);
    Map decoded = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return new User(
          id: decoded['userId'],
          email: decoded['email'],
          nick: decoded['userNick']);
    } else {
      throw Exception(decoded['error']['userMessage']);
    }
  }
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
