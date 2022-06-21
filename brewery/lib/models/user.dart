import 'package:brewery/models/beer.dart';
import 'package:meta/meta.dart';

class User {
  final int id;
  final String email;
  String nick;
  int? status = 0;

  List<Beer> beers;

  User(
      {required this.id,
      required this.email,
      required this.nick,
      this.status,
      this.beers = const []});

  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
      id: json['userId'],
      email: json['email'] ?? '',
      nick: json['userNick'],
      status: json['email'] != null ? 1 : 0,
    );
  }

  bool isGuest() {
    return email.isEmpty;
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, nick: $nick, status: $status, beers: $beers}';
  }
}
