import 'package:brewery/models/user.dart';

class Review {
  final int id;
  final User owner;
  final String text;
  final double rating;
  final String createdAt;

  Review(
      {required this.id,
      required this.owner,
      required this.text,
      required this.rating,
        required this.createdAt});

  factory Review.fromJson(Map<String, dynamic> json) {
    User owner = User.fromJson(json['reviewOwner']);
    return Review(
      id: json['reviewId'],
      text: json['reviewText'],
      owner: owner,
      rating: double.parse(json['reviewRating'].toString()),
      createdAt: json['reviewCreatedAt'],
    );
  }
}
