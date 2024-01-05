import 'package:brewery/screens/details/components/body.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        // @todo:     Navigator.pushNamed(context, '/home', arguments: widget.beer);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.1), BlendMode.dstATop),
                fit: BoxFit.cover,
                image: const AssetImage("assets/images/bg3.jpg"))),
        child: Body(),
      ),
    );
  }
}
