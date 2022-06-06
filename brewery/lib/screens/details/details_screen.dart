import 'package:brewery/screens/details/components/body.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; //todo
      },
      child: Scaffold(
        body: Body(),
      ),
    );
  }
}
