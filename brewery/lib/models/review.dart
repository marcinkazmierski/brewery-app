import 'package:brewery/models/beer.dart';
import 'package:brewery/models/user.dart';
import 'package:flutter/cupertino.dart';

class Review {
  final User owner;
  final Beer beer;
  final String text;
  final double rating;

  Review(
      {@required this.owner,
      @required this.beer,
      @required this.text,
      @required this.rating});
}
