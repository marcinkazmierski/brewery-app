import 'dart:async';
import 'package:brewery/exceptions/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageGateway {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool> setCurrentUserAuthToken(String token) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString("X-AUTH-TOKEN", token).then((bool success) {
      return success;
    });
  }

  Future<bool> setCurrentUserId(int userId) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setInt("userId", userId).then((bool success) {
      return success;
    });
  }

  Future<String> getCurrentUserAuthToken() async {
    final SharedPreferences prefs = await _prefs;
    String token = prefs.getString("X-AUTH-TOKEN") ?? "";
    if (token.isEmpty) {
      throw UnauthorizedException("Current user auth token not exists.");
    }
    return token;
  }

  Future<int> getCurrentUserId() async {
    final SharedPreferences prefs = await _prefs;
    int id = prefs.getInt("userId") ?? -1;
    if (id < 0) {
      throw UnauthorizedException("Current user id not exists.");
    }
    return id;
  }
}
