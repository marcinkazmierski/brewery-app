import 'package:brewery/screens/details/components/body.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; //todo
      },
      child: Container(
        decoration: new BoxDecoration(
            color: Colors.white,
            image: new DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.white.withOpacity(0.1), BlendMode.dstATop),
                fit: BoxFit.cover,
                image: AssetImage("assets/images/bg3.jpg"))),
        child: Body(),
      ),
    );
  }
}
