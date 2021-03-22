import 'package:flutter/material.dart';
import 'package:brewery/screens/home/components/body.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(),
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
            Navigator.pushNamed(context, 'login'); //todo, use BLoC
          },
          icon: Icon(Icons.menu),
          itemBuilder: (BuildContext context) {
            return {'Ustawienia', 'Wyloguj'}.map((String choice) {
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
