import 'package:flutter/material.dart';
import 'package:brewery/constants.dart';
import 'beer_carousel.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // it enable scroll on small device
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: kDefaultPadding),
          BeerCarousel(),
        ],
      ),
    );
  }
}
