import 'package:flutter/material.dart';
import 'package:brewery/components/genre_card.dart';
import 'package:brewery/models/beer.dart';

import '../../../constants.dart';

class Genres extends StatelessWidget {
  const Genres({
    Key key,
    @required this.beer,
  }) : super(key: key);

  final Beer beer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      child: SizedBox(
        height: 36,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: beer.genra.length,
          itemBuilder: (context, index) => GenreCard(
            genre: beer.genra[index],
          ),
        ),
      ),
    );
  }
}
