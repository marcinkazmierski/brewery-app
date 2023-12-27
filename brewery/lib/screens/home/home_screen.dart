import 'package:brewery/common/constants.dart';
import 'package:brewery/components/press_double_back_to_close.dart';
import 'package:brewery/screens/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:brewery/screens/home/components/body.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/application.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PressDoubleBackToClose(
      message: "Naciśnij ponownie, aby zamknąć",
      child: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.darken),
                fit: BoxFit.cover,
                image: AssetImage("assets/images/bg3.jpg"))),
        child: Body(),
      ),
    );
  }
}
