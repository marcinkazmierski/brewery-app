import 'package:brewery/exceptions/exception.dart';
import 'package:brewery/gateways/local_storage_gateway.dart';
import 'package:brewery/models/beer.dart';
import 'package:brewery/models/review.dart';
import 'package:brewery/models/user.dart';
import 'package:brewery/repositories/api_repository.dart';
import 'package:meta/meta.dart';

abstract class BeerRepository {
  Future<List<Beer>> getBeers();

  Beer addBeerByCode(String code);

  bool addRate(Beer beer, double rate);

  bool addReview(Beer beer, String comment);
}

class ApiBeerRepository extends ApiRepository implements BeerRepository {
  final String apiUrl;
  LocalStorageGateway localStorageGateway;

  ApiBeerRepository(
      {@required this.apiUrl, @required this.localStorageGateway});

  @override
  Future<List<Beer>> getBeers() async {
    String authToken = await this.localStorageGateway.getCurrentUserAuthToken();
    Map decoded = await requestGet('beers', authToken);

    List<Beer> beers = [];
    decoded["beers"].forEach((item) {
      List<Review> reviews = [];
      item["beerReviews"].forEach((r) {
        reviews.add(Review.fromJson(r));
      });

      Beer beer = new Beer(
        id: item['beerId'],
        title: item['beerTitle'],
        name: item['beerName'],
        poster: item['beerIcon'],
        backdrop: item['beerBackgroundImage'],
        rating: item['beerRating'],
        //todo
        tags: new List<String>.from(item['beerTags']),
        description: item['beerDescription'],
        hops: item['beerHops'],
        malts: item['beerMalts'],
        active: item['beerStatus'] == "unlocked",
        reviews: reviews,
      );

      beers.add(beer);
    });

    return beers;
  }

  @override
  bool addReview(Beer beer, String comment) {
    if (!beer.active) {
      throw new InvalidBeerStatusException("Beer must by active for you!");
    }
    return true;
  }

  @override
  bool addRate(Beer beer, double rate) {
    if (!beer.active) {
      throw new InvalidBeerStatusException("Beer must by active for you!");
    }
    return true;
  }

  @override
  Beer addBeerByCode(String code) {
    return Beer(
      id: 99,
      title: "Nowe Piwo",
      name: "Pale Ale 12°BLG",
      poster: "assets/images/poster_1.jpg",
      backdrop: "assets/images/bg2.jpg",
      rating: 2.6,
      tags: ["Jasne", "Pełne"],
      description: "Opis....",
      hops: "Chmiele...",
      malts: "Słody...",
      active: true,
      reviews: [],
    );
  }
}
