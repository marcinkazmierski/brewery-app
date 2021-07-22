import 'package:brewery/exceptions/exception.dart';
import 'package:brewery/gateways/local_storage_gateway.dart';
import 'package:brewery/models/beer.dart';
import 'package:brewery/models/review.dart';
import 'package:brewery/models/user.dart';
import 'package:brewery/repositories/api_repository.dart';
import 'package:meta/meta.dart';

abstract class BeerRepository {
  Future<List<Beer>> getBeers();

  Future<void> addBeerByCode(String code);

  bool addReview(Beer beer, String comment, double rate);
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
  bool addReview(Beer beer, String comment, double rate) {
    if (!beer.active) {
      throw new InvalidBeerStatusException("Beer must by active for you!");
    }
    return true;
  }


  @override
  Future<void> addBeerByCode(String code) async {
    String authToken = await this.localStorageGateway.getCurrentUserAuthToken();
    Map data = {'beerCode': code};
    await requestPost(data, 'beers', authToken);
  }
}
