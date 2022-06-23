import 'package:brewery/constants.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    colorFilter: new ColorFilter.mode(
                        Colors.white.withOpacity(0.2), BlendMode.dstATop),
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/bg3.jpg"))),
          ),
          Center(
            child: Text("//todo"),
          ),
          SafeArea(
              child: Container(
            margin:
                EdgeInsets.only(left: kDefaultPadding, top: kDefaultPadding),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(30),
            ),
            child: BackButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                color: Colors.white),
          )),
        ],
      ),
    );
  }
}
