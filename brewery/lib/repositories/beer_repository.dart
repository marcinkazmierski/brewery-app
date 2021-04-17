import 'package:brewery/exceptions/exception.dart';
import 'package:brewery/models/beer.dart';

abstract class BeerRepository {
  List<Beer> getBeers();

  Beer addBeerByCode(String code);

  bool addRate(Beer beer, double rate);

  bool addReview(Beer beer, String comment);
}

// class ApiRepository implements Repository {}

class FakeBeerRepository implements BeerRepository {
  @override
  List<Beer> getBeers() {
    String plotText =
        "Obecnie jeden z najbardziej rozpoznawalnych stylów piwa górnej fermentacji. Jeden z najczęściej warzonych przez rzemieślnicze browary. APA czyli American Pale Ale. Lekkie, rześkie o owocowym aromacie, który zawdzięcza mieszance najpopularniejszych, amerykańskich odmian chmielu. Specjalny sposób chmielenia pozwala na użycie dużej ilości chmielu, bez podnoszenia goryczki.";
    String maltsText =
        "Pale Ale - 3,4kg \nMonachijski - 0,4kg \nMelanoidynowy 40 - 0,2kg \nAbbey - 0,4kg";
    String hopsText = "Chmiel Saaz - 45g \nChmiel Styrian Goldings - 30g";

    List<Beer> beers = [
      Beer(
        id: 1,
        title: "Czerwony Kasztan",
        name: "Polskie Jasne 12°BLG",
        poster: "assets/images/poster_1.jpg",
        backdrop: "assets/images/bg1.png",
        rating: 3.8,
        tags: ["Jasne", "Wysoka goryczka"],
        description: plotText,
        hops: hopsText,
        malts: maltsText,
        active: true,
        reviews: [],
      ),
      Beer(
        id: 2,
        title: "Fajrant",
        name: "Kölsch 11°BLG",
        poster: "assets/images/poster_1.jpg",
        backdrop: "assets/images/bg2.jpg",
        rating: 4.2,
        tags: ["Jasne", "Wysoka goryczka"],
        description: plotText,
        hops: hopsText,
        malts: maltsText,
        active: true,
        reviews: [],
      ),
      Beer(
        id: 1,
        title: "Kapitan Bomba",
        name: "Gazdowa German Lager",
        poster: "assets/images/poster_1.jpg",
        backdrop: "assets/images/bg2.jpg",
        rating: 4.6,
        tags: ["Jasne", "Brewkit"],
        description: plotText,
        hops: hopsText,
        malts: maltsText,
        active: true,
        reviews: [],
      ),
      Beer(
        id: 4,
        title: "Jasny Kruk",
        name: "Summer Ale 12°BLG",
        poster: "assets/images/poster_1.jpg",
        backdrop: "assets/images/bg2.jpg",
        rating: 4.9,
        tags: ["Jasne", "Brewkit"],
        description: plotText,
        hops: hopsText,
        malts: maltsText,
        active: false,
        reviews: [],
      ),
    ];

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
