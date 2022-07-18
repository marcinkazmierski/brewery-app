import 'package:brewery/components/press_double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:brewery/screens/login/components/body.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new PressDoubleBackToClose(
      message: "Naciśnij ponownie, aby zamknąć",
      child: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.darken),
                fit: BoxFit.cover,
                image: AssetImage("assets/images/bg3.jpg"))),
        child: Body(),
      ),
    );
  }
}
