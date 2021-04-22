import 'package:brewery/screens/details/components/reviews_list.dart';
import 'package:flutter/material.dart';
import 'package:brewery/constants.dart';
import 'package:brewery/models/beer.dart';
import 'backdrop_rating.dart';
import 'genres.dart';
import 'title_duration_and_fav_btn.dart';

class Body extends StatelessWidget {
  final Beer beer;

  const Body({Key key, this.beer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // it will provide us total height and width
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BackdropAndRating(size: size, beer: beer),
          SizedBox(height: kDefaultPadding / 2),
          TitleDurationAndFabBtn(beer: beer),
          Genres(beer: beer),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: kDefaultPadding / 2,
              horizontal: kDefaultPadding,
            ),
            child: Text(
              "Opis stylu",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Text(
              beer.description,
              style: TextStyle(
                color: Color(0xFF737599),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: kDefaultPadding / 2,
              horizontal: kDefaultPadding,
            ),
            child: Text(
              "Chmiele",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Text(
              beer.hops,
              style: TextStyle(
                color: Color(0xFF737599),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: kDefaultPadding / 2,
              horizontal: kDefaultPadding,
            ),
            child: Text(
              "Słody",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Text(
              beer.malts,
              style: TextStyle(
                color: Color(0xFF737599),
              ),
            ),
          ),
          SizedBox(height: kDefaultPadding),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: kDefaultPadding / 2,
              horizontal: kDefaultPadding,
            ),
            child: Text(
              "Recenzje",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
            ),
            child: ReviewsList(reviews: beer.reviews),
          ),
        ],
      ),
    );
  }
}
