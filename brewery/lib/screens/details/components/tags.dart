import 'package:flutter/material.dart';
import 'package:brewery/screens/details/components/tag_card.dart';
import 'package:brewery/models/beer.dart';

import '../../../constants.dart';

class Tags extends StatelessWidget {
  const Tags({
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
          itemCount: beer.tags.length,
          itemBuilder: (context, index) => TagsCard(
            tag: beer.tags[index],
          ),
        ),
      ),
    );
  }
}
