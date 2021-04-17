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
}
