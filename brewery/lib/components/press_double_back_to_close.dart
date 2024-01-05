import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PressDoubleBackToClose extends StatefulWidget {
  final Widget child;
  final String message;
  final int waitForSecondBackPress;

  const PressDoubleBackToClose({
    Key? key,
    required this.child,
    this.message = "Press back again to exit",
    this.waitForSecondBackPress = 2,
  }) : super(key: key);

  @override
  _DoubleBackState createState() => _DoubleBackState();
}

class _DoubleBackState extends State<PressDoubleBackToClose> {
  bool tapped = false;
  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) >
                Duration(seconds: widget.waitForSecondBackPress)) {
          currentBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(widget.message),
            backgroundColor: Colors.blueGrey,
            duration: Duration(seconds: widget.waitForSecondBackPress),
          ));
          return;
        }
        SystemNavigator.pop();
      },
      child: widget.child,
    );
  }

  void resetBackTimeout() {
    tapped = false;
  }
}
