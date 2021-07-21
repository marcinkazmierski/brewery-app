import 'package:brewery/models/user.dart';
import 'package:flutter/cupertino.dart';

class Review {
  final User owner;
  final String text;
  final double rating;
  final String createdAt;

  Review({@required this.owner, @required this.text, @required this.rating, this.createdAt});

  factory Review.fromJson(Map<String, dynamic> json) {
    User owner = User.fromJson(json['reviewOwner']);
    return Review(
      text: json['reviewText'],
      owner: owner,
      rating: json['reviewRating'],
      createdAt: json['reviewCreatedAt'],
    );
  }
}
