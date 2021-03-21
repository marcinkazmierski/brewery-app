import 'package:flutter/material.dart';
import 'package:brewery/models/beer.dart';

import '../../../constants.dart';

class TitleDurationAndFabBtn extends StatelessWidget {
  const TitleDurationAndFabBtn({
    Key key,
    @required this.beer,
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
                  beer.title,
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(height: kDefaultPadding / 2),
                Text(
                  beer.name,
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
