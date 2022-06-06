import 'package:brewery/models/beer.dart';
import 'package:brewery/models/user.dart';

class Application {
  static final Application _singleton = Application._internal();
  static User? currentUser;
  static List<Beer> beers = [];

  factory Application() {
    return _singleton;
  }

  Application._internal();
}
