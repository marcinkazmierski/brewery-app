// Our beer model
import 'package:brewery/models/review.dart';

class Beer {
  final int id;
  final double rating;
  final List<String> tags;
  final String description, title, name, icon, backgroundImage, hops, malts;
  final bool active;
  final List<Review> reviews;
  final Review? userBeerReview;

  Beer(
      {required this.icon,
      required this.backgroundImage,
      required this.title,
      required this.name,
      required this.id,
      required this.rating,
      required this.tags,
      required this.description,
      required this.hops,
      required this.malts,
      required this.active,
      required this.reviews,
      required this.userBeerReview});

  factory Beer.fromJson(Map<String, dynamic> item) {
    List<Review> reviews = [];
    item["beerReviews"].forEach((r) {
      reviews.add(Review.fromJson(r));
    });

    return Beer(
      id: item['beerId'],
      title: item['beerTitle'],
      name: item['beerName'],
      icon: item['beerIcon'],
      backgroundImage: item['beerBackgroundImage'],
      rating: double.parse(item['beerRating'].toString()),
      tags: new List<String>.from(item['beerTags']),
      description: item['beerDescription'],
      hops: item['beerHops'],
      malts: item['beerMalts'],
      active: item['beerStatus'] == "unlocked",
      reviews: reviews,
      userBeerReview: (item["userBeerReview"] != null)
          ? Review.fromJson(item["userBeerReview"])
          : null,
    );
  }

  @override
  String toString() {
    return "$id, $name";
  }
}
