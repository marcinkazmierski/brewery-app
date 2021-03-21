import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:brewery/models/beer.dart';
import 'package:brewery/screens/details/details_screen.dart';
import '../../../constants.dart';

class BeerCard extends StatelessWidget {
  final Beer beer;

  const BeerCard({Key key, this.beer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: OpenContainer(
        closedColor: Colors.transparent,
        closedElevation: 0,
        openElevation: 0,
        closedBuilder: (context, action) => buildBeerCard(context),
        openBuilder: (context, action) => DetailsScreen(beer: beer),
      ),
    );
  }

  Container buildBeerCard(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.transparent),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [kDefaultShadow],
                  image: DecorationImage(
                    colorFilter: beer.active
                        ? null
                        : ColorFilter.mode(
                            Colors.black.withOpacity(0.7), BlendMode.darken),
                    fit: BoxFit.fill,
                    image: AssetImage(beer.poster),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: kDefaultPadding / 2),
              child: Text(
                beer.title,
                style: TextStyle(color: Colors.white, fontSize: 26),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              child: Text(
                beer.name,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
            Row(
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
          ],
        ));
  }
}
