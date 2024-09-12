import 'package:brewery/models/user.dart';

class Application {
  static final Application _singleton = Application._internal();
  static User? currentUser;

  factory Application() {
    return _singleton;
  }

  Application._internal();
}
