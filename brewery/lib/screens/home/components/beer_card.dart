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
        closedElevation: 0,
        openElevation: 0,
        closedBuilder: (context, action) => buildBeerCard(context),
        openBuilder: (context, action) => DetailsScreen(beer: beer),
      ),
    );
  }

  Column buildBeerCard(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              boxShadow: [kDefaultShadow],
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(beer.poster),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
          child: Text(
            beer.title,
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontWeight: FontWeight.w600),
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
              style: Theme.of(context).textTheme.bodyText2,
            )
          ],
        )
      ],
    );
  }
}
