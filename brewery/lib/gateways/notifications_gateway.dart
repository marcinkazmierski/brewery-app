import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsGateway {
  Future<void> init() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    log("Current fcmToken: $fcmToken");
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      // TODO: If necessary send token to application server.
      log(fcmToken.toString());
      log("New fcmToken: $fcmToken");
      // Note: This callback is fired at each app startup and whenever a new
      // token is generated.
    }).onError((err) {
      log(err.toString());
      // Error getting token.
    });
  }
}
