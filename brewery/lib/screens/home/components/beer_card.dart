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
          print("Container clicked");
          Navigator.pushNamed(context, 'details', arguments: this.beer);
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
                AnimatedOpacity(
                  duration: Duration(milliseconds: 350),
                  opacity: (this.isActive && !beer.active) ? 0.5 : 1,
                  child: Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [kDefaultShadow],
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(beer.icon),
                      ),
                    ),
                  ),
                ),
                (this.isActive && !beer.active)
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
                style: TextStyle(color: Colors.white, fontSize: 26),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
              child: Text(
                beer.title,
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
