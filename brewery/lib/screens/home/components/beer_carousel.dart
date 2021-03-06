import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:brewery/models/beer.dart';
import '../../../constants.dart';
import 'beer_card.dart';

class BeerCarousel extends StatefulWidget {
  final List<Beer> beers;

  BeerCarousel({this.beers});

  @override
  _BeerCarouselState createState() => _BeerCarouselState(beers: this.beers);
}

class _BeerCarouselState extends State<BeerCarousel> {
  final List<Beer> beers;
  PageController _pageController;
  int initialPage = 0;

  _BeerCarouselState({this.beers});

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      // so that we can have small portion shown on left and right side
      viewportFraction: 0.8,
      // by default our beer poster
      initialPage: initialPage,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: AspectRatio(
        aspectRatio: 0.85,
        child: PageView.builder(
          onPageChanged: (value) {
            setState(() {
              initialPage = value;
            });
          },
          controller: _pageController,
          physics: ClampingScrollPhysics(),
          itemCount: this.beers.length,
          // we have 3 demo beers
          itemBuilder: (context, index) => buildBeerSlider(index),
        ),
      ),
    );
  }

  Widget buildBeerSlider(int index) => AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          double value = 0;
          value = index - initialPage.toDouble();
          if (_pageController.position.haveDimensions) {
            value = index - _pageController.page;
          }

          // We use 0.038 because 180*0.038 = 7 almost and we need to rotate our poster 7 degree
          // we use clamp so that our value vary from -1 to 1
          value = (value * 0.038).clamp(-1, 1);

          return AnimatedOpacity(
            duration: Duration(milliseconds: 350),
            opacity: initialPage == index ? 1 : 0.4,
            child: Transform.rotate(
              angle: math.pi * value,
              child: BeerCard(
                  beer: this.beers[index], isActive: index == initialPage),
            ),
          );
        },
      );
}
