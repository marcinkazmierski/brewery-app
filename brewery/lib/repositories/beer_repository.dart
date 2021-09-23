import 'package:brewery/exceptions/exception.dart';
import 'package:brewery/gateways/local_storage_gateway.dart';
import 'package:brewery/models/beer.dart';
import 'package:brewery/repositories/api_repository.dart';
import 'package:meta/meta.dart';

abstract class BeerRepository {
  Future<List<Beer>> getBeers();

  Future<Beer> getBeerById(int id);

  Future<void> addBeerByCode(String code);

  Future<Beer> addReview(Beer beer, String comment, double rate);
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
      beers.add(Beer.fromJson(item));
    });

    return beers;
  }

  @override
  Future<Beer> getBeerById(int id) async {
    String authToken = await this.localStorageGateway.getCurrentUserAuthToken();
    Map decoded = await requestGet('beer', authToken);
    return Beer.fromJson(decoded["beer"]);
  }

  @override
  Future<Beer> addReview(Beer beer, String comment, double rate) async {
    if (!beer.active) {
      throw new InvalidBeerStatusException("Beer must by active for you!");
    }
    String authToken = await this.localStorageGateway.getCurrentUserAuthToken();
    Map data = {'reviewRating': rate, 'reviewText': comment, 'beerId': beer.id};
    Map decoded = await requestPost(data, 'review/add', authToken);

    return Beer.fromJson(decoded["beer"]);
  }

  @override
  Future<void> addBeerByCode(String code) async {
    String authToken = await this.localStorageGateway.getCurrentUserAuthToken();
    Map data = {'beerCode': code};
    await requestPost(data, 'beers', authToken);
  }
}
