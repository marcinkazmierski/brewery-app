import 'package:flutter/material.dart';
import 'package:brewery/constants.dart';
import 'package:brewery/models/beer.dart';
import 'package:flutter_svg/svg.dart';

class ReviewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: ListTile.divideTiles(
        context: context,
        tiles: [
          ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  "assets/icons/star_fill.svg",
                  height: 16,
                ),
                SizedBox(height: kDefaultPadding / 4),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "5.0/",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: "5\n"),
                    ],
                  ),
                ),
              ],
            ),
            title: Text('Adam'),
            subtitle: Text('Wszystko fajnie! Polecam!'),
          ),
          ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  "assets/icons/star_fill.svg",
                  height: 16,
                ),
                SizedBox(height: kDefaultPadding / 4),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "4.5/",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: "5\n"),
                    ],
                  ),
                ),
              ],
            ),
            title: Text('Janusz'),
            subtitle: Text('Wszystko fajnie! Polecam!'),
          ),
          ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  "assets/icons/star_fill.svg",
                  height: 16,
                ),
                SizedBox(height: kDefaultPadding / 4),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "4.0/",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: "5\n"),
                    ],
                  ),
                ),
              ],
            ),
            title: Text('Staś'),
            subtitle: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'),
          ),
        ],
      ).toList(),
    );
  }
}
