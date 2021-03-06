import 'package:brewery/models/beer.dart';
import 'package:meta/meta.dart';

class User {
  final int id;
  final String email;
  String nick;
  int status = 0;

  List<Beer> beers = [];

  User(
      {@required this.id,
      @required this.email,
      @required this.nick,
      this.status,
      this.beers});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userId'],
      email: json['email'] ?? '',
      nick: json['userNick'],
    );
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, nick: $nick, status: $status, beers: $beers}';
  }
}
