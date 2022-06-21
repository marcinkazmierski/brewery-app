import 'package:brewery/components/press_double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:brewery/screens/home/components/body.dart';
import 'package:flutter/services.dart';

import '../../common/application.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new PressDoubleBackToClose(
      message: "Naciśnij ponownie, aby zamknąć",
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: buildAppBar(context),
        body: Body(),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        PopupMenuButton<int>(
          onSelected: (int value) {
            if (value == 1) {
              //todo: use constatnts or enum: https://api.flutter.dev/flutter/material/PopupMenuButton-class.html
              Navigator.pushNamed(context, '/logout');
            }
            if (value == 3) {
              Navigator.pushNamed(context, '/registration');
            }
            if (value == 99) {
              SystemNavigator.pop();
            }
          },
          icon: Icon(Icons.menu),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              child: Text('Wyloguj'),
              value: 1,
            ),
            Application.currentUser?.status == 1
                ? PopupMenuItem(
                    child: Text('Profil'),
                    value: 2,
                  )
                : PopupMenuItem(
                    child: Text('Zarejestruj konto'),
                    value: 3,
                  ),
            PopupMenuItem(
              child: Text('O Zdalnym Browarze'),
              value: 4,
            ),
            PopupMenuItem(
              child: Text('Zamknij'),
              value: 99,
            )
          ],
        ),
      ],
    );
  }
}
