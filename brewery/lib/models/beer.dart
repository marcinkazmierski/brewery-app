// Our beer model
import 'package:brewery/models/review.dart';

class Beer {
  final int id;
  final double rating;
  final List<String> tags;
  final String description, title, name, poster, backdrop, hops, malts;
  final bool active;
  final List<Review> reviews;

  Beer(
      {this.poster,
      this.backdrop,
      this.title,
      this.name,
      this.id,
      this.rating,
      this.tags,
      this.description,
      this.hops,
      this.malts,
      this.active,
      this.reviews});

  factory Beer.fromJson(Map<String, dynamic> item) {
    List<Review> reviews = [];
    item["beerReviews"].forEach((r) {
      reviews.add(Review.fromJson(r));
    });

    return Beer(
      id: item['beerId'],
      title: item['beerTitle'],
      name: item['beerName'],
      poster: item['beerIcon'],
      backdrop: item['beerBackgroundImage'],
      rating: item['beerRating'],
      tags: new List<String>.from(item['beerTags']),
      description: item['beerDescription'],
      hops: item['beerHops'],
      malts: item['beerMalts'],
      active: item['beerStatus'] == "unlocked",
      reviews: reviews,
    );
  }
}
