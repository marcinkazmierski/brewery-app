import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:brewery/models/beer.dart';
import '../../../constants.dart';

class BeerCard extends StatelessWidget {
  final Beer beer;
  final bool isActive;

  const BeerCard({Key key, this.beer, this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/details', arguments: this.beer);
        },
        child: buildBeerCard(context),
      ),
    );
  }

  Container buildBeerCard(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.transparent),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(children: <Widget>[
                Container(
                  margin: EdgeInsets.all(5),
                  child: CachedNetworkImage(
                    placeholder: (context, url) =>
                        Center(child: const CircularProgressIndicator()),
                    imageUrl: beer.icon,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [kDefaultShadow],
                        image: DecorationImage(
                          opacity: (!beer.active) ? 0.5 : 1,
                          image: imageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
                (!beer.active)
                    ? Center(
                        child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: kDefaultPadding),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                              "Tego piwa nie masz jeszcze w swoim zbiorze :(",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white)),
                        ),
                      ))
                    : Container(),
              ]),
            ),
            Padding(
              padding: EdgeInsets.only(top: kDefaultPadding / 2),
              child: Text(
                beer.name,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 26),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              child: Text(
                beer.title,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
            (beer.reviews.length > 0)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(
                        "assets/icons/star_fill.svg",
                        height: 20,
                      ),
                      SizedBox(width: kDefaultPadding / 2),
                      Text(
                        "${beer.rating}",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: kDefaultPadding / 2),
                      Text(
                        "brak ocen",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
          ],
        ));
  }
}
