import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:brewery/models/beer.dart';
import '../../../constants.dart';

class BeerCard extends StatelessWidget {
  final Beer beer;
  final bool isActive;

  const BeerCard({super.key, required this.beer, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/details', arguments: beer);
        },
        child: buildBeerCard(context),
      ),
    );
  }

  Container buildBeerCard(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(5),
                  child: CachedNetworkImage(
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    imageUrl: beer.icon,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [kDefaultShadow],
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
                            const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                              "Tego piwa nie masz jeszcze w swoim zbiorze :(",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white)),
                        ),
                      ))
                    : Container(),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: kDefaultPadding / 2),
              child: Text(
                beer.name,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 26),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              child: Text(
                beer.title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
            (beer.reviews.isNotEmpty)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(
                        "assets/icons/star_fill.svg",
                        height: 20,
                      ),
                      const SizedBox(width: kDefaultPadding / 2),
                      Text(
                        "${beer.rating}",
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  )
                : const Row(
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
