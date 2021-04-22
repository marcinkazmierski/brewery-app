import 'package:brewery/models/user.dart';
import 'package:flutter/cupertino.dart';

class Review {
  final User owner;
  final String text;
  final double rating;

  Review({@required this.owner, @required this.text, @required this.rating});
}
