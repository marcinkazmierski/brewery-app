import 'package:flutter/material.dart';
import 'package:brewery/screens/registration/components/body.dart';

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Body(),
      ),
    );
  }
}
