import 'dart:developer';
import 'package:brewery/repositories/user_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsGateway {
  UserRepository userRepository;

  NotificationsGateway({required this.userRepository});

  Future<void> init() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    log("Current fcmToken: $fcmToken");
    if (fcmToken != null) {
      userRepository.storeNotificationToken(fcmToken);
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      log("New fcmToken: $fcmToken");
      // userRepository.storeNotificationToken(fcmToken);
      // Note: This callback is fired at each app startup and whenever a new
      // token is generated.
    }).onError((err) {
      log(err.toString());
      // Error getting token.
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      print('Message ID: ${message.messageId}');
      print('Message messageType: ${message.messageType}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        print('Message notification title: ${message.notification!.title}');
        print('Message notification body: ${message.notification!.body}');
      }
    });
  }
}
