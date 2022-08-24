import 'dart:developer';
import 'package:brewery/repositories/user_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsGateway {
  UserRepository userRepository;

  NotificationsGateway({required this.userRepository});

  Future<void> init() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    // log("Current fcmToken: $fcmToken");
    if (fcmToken != null) {
      userRepository.storeNotificationToken(fcmToken);
    }

    // FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
    //   // log("New fcmToken: $fcmToken");
    //   userRepository.storeNotificationToken(fcmToken);
    //   // Note: This callback is fired at each app startup and whenever a new
    //   // token is generated.
    // }).onError((err) {
    //   log(err.toString());
    //   // Error getting token.
    // });
  }
}
