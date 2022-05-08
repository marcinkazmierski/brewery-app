import 'dart:async';
import 'package:brewery/exceptions/exception.dart';
import 'package:brewery/gateways/local_storage_gateway.dart';
import 'package:brewery/models/user.dart';
import 'package:brewery/repositories/api_repository.dart';
import 'package:meta/meta.dart';

abstract class UserRepository {
  Future<User> loginGuest(String nick);

  Future<User> login(String email, String password);

  Future<bool> registerGuest(String email, String password);

  Future<bool> register(String email, String nick, String password);

  Future<bool> resetPassword(String email);

  Future<bool> resetPasswordConfirm(
      String email, String code, String newPassword);

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
  Future<bool> registerGuest(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw new ValidateException(
          "Invalid login, nick or password. Try again!");
    }
    String authToken = await this.localStorageGateway.getCurrentUserAuthToken();
    Map data = {'email': email, 'password': password};
    Map decoded = await requestPost(data, 'register/guest', authToken);
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
  Future<User> loginGuest(String nick) async {
    if (nick.isEmpty) {
      throw new ValidateException("Invalid nick!");
    }
    Map data = {'nick': nick};
    Map decoded = await requestPost(data, 'auth/authenticate/guest');
    this.localStorageGateway.setCurrentUserAuthToken(decoded['token']);
    this.localStorageGateway.setCurrentUserId(decoded['userId']);
    return new User(
        id: decoded['userId'],
        email: decoded['email'],
        nick: decoded['userNick']);
  }

  @override
  Future<bool> resetPassword(String email) async {
    if (email.isEmpty) {
      throw new ValidateException("Empty email.");
    }
    Map data = {'email': email};
    await requestPost(data, 'auth/reset-password');
    return true;
  }

  @override
  Future<bool> resetPasswordConfirm(
      String email, String code, String newPassword) async {
    if (email.isEmpty || code.isEmpty || newPassword.isEmpty) {
      throw new ValidateException("Empty email or code or password.");
    }
    Map data = {'email': email, 'code': code, 'newPassword': newPassword};
    await requestPost(data, 'auth/reset-password-confirm');
    return true;
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
