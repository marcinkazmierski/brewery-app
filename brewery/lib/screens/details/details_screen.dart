import 'package:flutter/material.dart';
import 'package:brewery/models/beer.dart';
import 'package:brewery/screens/details/components/body.dart';

class DetailsScreen extends StatelessWidget {
  final Beer beer;

  const DetailsScreen({Key key, this.beer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(beer: beer),
    );
  }
}
