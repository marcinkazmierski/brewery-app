import 'package:brewery/models/user.dart';

abstract class UserRepository {
  User login(String login, String password);
}
