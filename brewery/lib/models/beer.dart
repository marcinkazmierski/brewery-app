// Our beer model
class Beer {
  final int id;
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
      this.rating,
      this.genra,
      this.plot,
      this.hops,
      this.malts,
      this.active});
}
