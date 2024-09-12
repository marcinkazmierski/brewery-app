import 'dart:async';
import 'dart:developer';
import 'package:brewery/exceptions/exception.dart';
import 'package:brewery/models/user.dart';
import 'package:brewery/repositories/api_repository.dart';

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

  Future<bool> storeNotificationToken(String token);
}

class ApiUserRepository extends ApiRepository implements UserRepository {
  ApiUserRepository(
      {required super.apiUrl, required super.localStorageGateway});

  @override
  Future<bool> logout() async {
    localStorageGateway.setCurrentUserAuthToken("");
    localStorageGateway.setCurrentUserId(-1);
    return true;
  }

  @override
  Future<bool> register(String email, String nick, String password) async {
    if (email.isEmpty || nick.isEmpty || password.isEmpty) {
      throw const ValidateException("Hasło lub email lub nick jest puste!");
    }

    Map data = {'email': email, 'nick': nick, 'password': password};
    Map decoded = await requestPost(data, 'register');
    return true;
  }

  @override
  Future<bool> registerGuest(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw const ValidateException("Hasło lub login jest puste!");
    }
    String authToken = await localStorageGateway.getCurrentUserAuthToken();
    Map data = {'email': email, 'password': password};
    Map decoded = await requestPost(data, 'register/guest', authToken);
    return true;
  }

  @override
  Future<User> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw const ValidateException("Hasło lub login jest puste!");
    }
    Map data = {'email': email, 'password': password};
    Map decoded = await requestPost(data, 'auth/authenticate');
    localStorageGateway.setCurrentUserAuthToken(decoded['token']);
    localStorageGateway.setCurrentUserId(decoded['userId']);
    return User(
        id: decoded['userId'],
        email: decoded['email'],
        nick: decoded['userNick']);
  }

  @override
  Future<User> loginGuest(String nick) async {
    if (nick.isEmpty) {
      throw const ValidateException("Podaj nick!");
    }
    Map data = {'nick': nick};
    Map decoded = await requestPost(data, 'auth/authenticate/guest');
    localStorageGateway.setCurrentUserAuthToken(decoded['token']);
    localStorageGateway.setCurrentUserId(decoded['userId']);
    return User.fromJson(decoded);
  }

  @override
  Future<bool> resetPassword(String email) async {
    if (email.isEmpty) {
      throw const ValidateException("Podaj email.");
    }
    Map data = {'email': email};
    await requestPost(data, 'auth/reset-password');
    return true;
  }

  @override
  Future<bool> resetPasswordConfirm(
      String email, String code, String newPassword) async {
    if (email.isEmpty || code.isEmpty || newPassword.isEmpty) {
      throw const ValidateException("Hasło lub kod lub login jest puste!");
    }
    Map data = {'email': email, 'code': code, 'newPassword': newPassword};
    await requestPost(data, 'auth/reset-password-confirm');
    return true;
  }

  @override
  Future<User> profile() async {
    String authToken = await localStorageGateway.getCurrentUserAuthToken();
    Map decoded = await requestGet('user', authToken);
    return User.fromJson(decoded);
  }

  @override
  Future<bool> storeNotificationToken(String token) async {
    if (token.isEmpty) {
      throw const ValidateException("Empty token.");
    }
    String authToken = await localStorageGateway.getCurrentUserAuthToken();
    Map data = {'notificationToken': token};
    Map decoded =
        await requestPost(data, 'user/store-notification-token', authToken);
    log(decoded.toString());
    return true;
  }
}
