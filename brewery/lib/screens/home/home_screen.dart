import 'package:flutter/material.dart';
import 'package:brewery/screens/home/components/body.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: buildAppBar(context),
        body: Body(),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.redAccent,
      elevation: 0,
      title: Text("Zdalny browar"),
      automaticallyImplyLeading: false,
      actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: (String value) {
            print(value);
            if (value == "Wyloguj") {
              Navigator.pushNamed(context, '/logout');
            }
            if (value == "Zamknij") {
              SystemNavigator.pop();
            }
          },
          icon: Icon(Icons.menu),
          itemBuilder: (BuildContext context) {
            return {'Ustawienia', 'Wyloguj', 'Zamknij'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
    );
  }
}
