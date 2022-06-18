import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:brewery/models/beer.dart';
import '../../../constants.dart';
import 'beer_card.dart';

class BeerCarousel extends StatefulWidget {
  final List<Beer> beers;
  final Beer? activeBeer;

  BeerCarousel({required this.beers, this.activeBeer});

  @override
  _BeerCarouselState createState() => _BeerCarouselState();
}

class _BeerCarouselState extends State<BeerCarousel> {
  late PageController _pageController;
  int initialPage = 0;

  @override
  void initState() {
    super.initState();
    if (widget.activeBeer != null) {
      var index = 0;
      for (var i = 0; i < widget.beers.length; i++) {
        if (widget.activeBeer!.id == widget.beers[i].id) {
          break;
        }
        index++;
      }
      initialPage = index;
    }
    _pageController = PageController(
      // so that we can have small portion shown on left and right side
      viewportFraction: 0.8,
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
          itemCount: widget.beers.length,
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
            value = index - _pageController.page!;
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
                  beer: widget.beers[index], isActive: index == initialPage),
            ),
          );
        },
      );
}
