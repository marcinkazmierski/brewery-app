import 'dart:async';
import 'package:brewery/exceptions/exception.dart';
import 'package:brewery/gateways/local_storage_gateway.dart';
import 'package:brewery/models/user.dart';
import 'package:brewery/repositories/api_repository.dart';
import 'package:meta/meta.dart';

abstract class UserRepository {
  Future<User> login(String email, String password);

  Future<bool> register(String email, String nick, String password);

  Future<bool> resetPassword(String email);

  Future<bool> logout();

  Future<User> profile();
}

class ApiUserRepository extends ApiRepository implements UserRepository {
  final String apiUrl;
  LocalStorageGateway localStorageGateway;

  ApiUserRepository(
      {@required this.apiUrl, @required this.localStorageGateway});

  @override
  Future<bool> logout() async {
    this.localStorageGateway.setCurrentUserAuthToken("");
    this.localStorageGateway.setCurrentUserId(-1);
    return true;
  }

  @override
  Future<bool> register(String email, String nick, String password) async {
    if (email.isEmpty || nick.isEmpty || password.isEmpty) {
      throw new ValidateException(
          "Invalid login, nick or password. Try again!");
    }

    Map data = {'email': email, 'nick': nick, 'password': password};
    Map decoded = await requestPost(data, 'register');
    return true;
  }

  @override
  Future<User> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw new ValidateException("Invalid login or password. Try again!");
    }
    Map data = {'email': email, 'password': password};
    Map decoded = await requestPost(data, 'auth/authenticate');
    this.localStorageGateway.setCurrentUserAuthToken(decoded['token']);
    this.localStorageGateway.setCurrentUserId(decoded['userId']);
    return new User(
        id: decoded['userId'],
        email: decoded['email'],
        nick: decoded['userNick']);
  }

  @override
  Future<bool> resetPassword(String email) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<User> profile() async {
    String authToken = await this.localStorageGateway.getCurrentUserAuthToken();
    Map decoded = await requestGet('user', authToken);
    return new User(
        id: decoded['userId'],
        email: decoded['email'],
        nick: decoded['userNick']);
  }
}
