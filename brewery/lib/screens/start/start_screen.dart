import 'package:brewery/components/press_double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:brewery/screens/start/components/body.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new PressDoubleBackToClose(
      message:"Naciśnij ponownie, aby zamknąć",
      child: Scaffold(
        body: Body(),
      ),
    );
  }
}
