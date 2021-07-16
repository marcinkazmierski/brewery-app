import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:brewery/exceptions/exception.dart';
import 'package:brewery/gateways/local_storage_gateway.dart';
import 'package:brewery/models/user.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

abstract class UserRepository {
  User getCurrentUser();

  Future<User> login(String email, String password);

  Future<bool> register(String email, String nick, String password);

  Future<bool> resetPassword(String email); //todo

  Future<bool> logout();
}

class ApiUserRepository extends UserRepository {
  final String apiUrl;
  LocalStorageGateway localStorageGateway;

  ApiUserRepository(
      {@required this.apiUrl, @required this.localStorageGateway});

  @override
  Future<bool> logout() async {
    return true;
  }

  @override
  Future<bool> register(String email, String nick, String password) async {
    if (email.isEmpty || nick.isEmpty || password.isEmpty) {
      throw new ValidateException(
          "Invalid login, nick or password. Try again!");
    }

    Map data = {'email': email, 'nick': nick, 'password': password};
    Map decoded = await _request(data, 'register');
    return true;
  }

  @override
  @deprecated
  User getCurrentUser() {
    return new User(id: 1, email: "email@test.com", nick: "TestowyNick");
  }

  @override
  Future<User> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw new ValidateException("Invalid login or password. Try again!");
    }
    Map data = {'email': email, 'password': password};

    Map decoded = await _request(data, 'auth/authenticate');
    this.localStorageGateway.setCurrentUserAuthToken(decoded['token']);
    return new User(
        id: decoded['userId'],
        email: decoded['email'],
        nick: decoded['userNick']);
  }

  Future<Map> _request(Map input, String uri) async {
    var body = json.encode(input);
    print(body);
    final response = await http.post(Uri.parse(this.apiUrl + uri),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
        },
        body: body);

    if (response.statusCode == 200) {
      Map decoded = jsonDecode(response.body);
      return decoded;
    } else if (response.statusCode == 204) {
      return null;
    } else {
      Map decoded = jsonDecode(response.body);
      throw Exception(decoded['error']['userMessage']);
    }
  }

  @override
  Future<bool> resetPassword(String email) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }
}
