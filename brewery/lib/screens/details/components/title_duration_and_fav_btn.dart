import 'package:flutter/material.dart';
import 'package:brewery/models/beer.dart';

import '../../../constants.dart';

class TitleDurationAndFabBtn extends StatelessWidget {
  const TitleDurationAndFabBtn({
    Key? key,
    required this.beer,
  }) : super(key: key);

  final Beer beer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(kDefaultPadding),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  beer.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: kDefaultPadding / 2),
                Text(
                  beer.title,
                  style: TextStyle(color: kTextLightColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
