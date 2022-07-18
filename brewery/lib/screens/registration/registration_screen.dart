import 'package:flutter/material.dart';
import 'package:brewery/screens/registration/components/body.dart';

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
          image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.darken),
              fit: BoxFit.cover,
              image: AssetImage("assets/images/bg3.jpg"))),
      child: Body(),
    );
  }
}
