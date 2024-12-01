import 'package:flutter/material.dart';
import 'package:brewery/screens/registration/components/body.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
          image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.darken),
              fit: BoxFit.cover,
              image: const AssetImage("assets/images/bg3.jpg"))),
      child: const Body(),
    );
  }
}
