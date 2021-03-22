// Our beer model
class Beer {
  final int id, year, numOfRatings, criticsReview, metascoreRating;
  final double rating;
  final List<String> genra;
  final String plot, title, name, poster, backdrop, hops, malts;
  final bool active;

  Beer(
      {this.poster,
      this.backdrop,
      this.title,
      this.name,
      this.id,
      this.year,
      this.numOfRatings,
      this.criticsReview,
      this.metascoreRating,
      this.rating,
      this.genra,
      this.plot,
      this.hops,
      this.malts,
      this.active});
}

// our demo data beer data
List<Beer> beers = [
  Beer(
    id: 1,
    title: "Czerwony Kasztan",
    name: "Polskie Jasne 12°BLG",
    year: 2020,
    poster: "assets/images/poster_1.jpg",
    backdrop: "assets/images/bg1.png",
    numOfRatings: 150212,
    rating: 7.3,
    criticsReview: 50,
    metascoreRating: 76,
    genra: ["Jasne", "Wysoka goryczka"],
    plot: plotText,
    hops: hopsText,
    malts: maltsText,
    active: true,
  ),
  Beer(
    id: 2,
    title: "Fajrant",
    name: "Kölsch 11°BLG",
    year: 2019,
    poster: "assets/images/poster_1.jpg",
    backdrop: "assets/images/bg2.jpg",
    numOfRatings: 150212,
    rating: 8.2,
    criticsReview: 50,
    metascoreRating: 76,
    genra: ["Jasne", "Wysoka goryczka"],
    plot: plotText,
    hops: hopsText,
    malts: maltsText,
    active: true,
  ),
  Beer(
    id: 1,
    title: "Kapitan Bomba",
    name: "Gazdowa German Lager",
    year: 2020,
    poster: "assets/images/poster_1.jpg",
    backdrop: "assets/images/bg2.jpg",
    numOfRatings: 150212,
    rating: 7.6,
    criticsReview: 50,
    metascoreRating: 79,
    genra: ["Jasne", "Brewkit"],
    plot: plotText,
    hops: hopsText,
    malts: maltsText,
    active: true,
  ),
  Beer(
    id: 4,
    title: "Jasny Kruk",
    name: "Summer Ale 12°BLG",
    year: 2020,
    poster: "assets/images/poster_1.jpg",
    backdrop: "assets/images/bg2.jpg",
    numOfRatings: 150212,
    rating: 7.6,
    criticsReview: 50,
    metascoreRating: 79,
    genra: ["Jasne", "Brewkit"],
    plot: plotText,
    hops: hopsText,
    malts: maltsText,
    active: false,
  ),
];

String plotText =
    "Obecnie jeden z najbardziej rozpoznawalnych stylów piwa górnej fermentacji. Jeden z najczęściej warzonych przez rzemieślnicze browary. APA czyli American Pale Ale. Lekkie, rześkie o owocowym aromacie, który zawdzięcza mieszance najpopularniejszych, amerykańskich odmian chmielu. Specjalny sposób chmielenia pozwala na użycie dużej ilości chmielu, bez podnoszenia goryczki.";
String maltsText =
    "Pale Ale - 3,4kg \nMonachijski - 0,4kg \nMelanoidynowy 40 - 0,2kg \nAbbey - 0,4kg";
String hopsText = "Chmiel Saaz - 45g \nChmiel Styrian Goldings - 30g";
