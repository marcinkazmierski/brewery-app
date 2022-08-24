import 'dart:developer';

import 'package:brewery/common/application.dart';
import 'package:brewery/common/constants.dart';
import 'package:brewery/components/fade_animation.dart';
import 'package:brewery/screens/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:brewery/constants.dart';
import 'package:flutter/services.dart';
import 'beer_carousel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BeerListFormState();
}

class _BeerListFormState extends State<Body> {
  Future scanBarcodeNormal() async {
    String barcodeScanRes;

    // Either the permission was already granted before or the user just granted it.
    if (!await Permission.camera.request().isGranted) {
      log("Camera permission is denied.");
      return;
    }

    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Anuluj", true, ScanMode.QR);

    final uri = await Uri.parse(barcodeScanRes);
    bool closeModal = false;

    if (uri != null && uri.queryParameters.containsKey('code')) {
      log("BEER CODE: " + uri.queryParameters['code']!);

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new WillPopScope(
                onWillPop: () async {
                  return closeModal;
                },
                child: AlertDialog(
                  title: Text('Czekaj...'),
                  content: SingleChildScrollView(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ));
          });
      closeModal = true;
      Navigator.pop(context); // close showDialog

      BlocProvider.of<HomeBloc>(context).add(
        AddNewBeerEvent(
          code: uri.queryParameters['code']!,
        ),
      );
    }
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        PopupMenuButton<int>(
          onSelected: (int value) {
            if (value == 1) {
              //todo: use constatnts or enum: https://api.flutter.dev/flutter/material/PopupMenuButton-class.html
              Navigator.pushNamed(context, '/logout');
            }
            if (value == 3) {
              Navigator.pushNamed(context, '/registration');
            }
            if (value == 4) {
              Navigator.pushNamed(context, '/about');
            }
            if (value == 99) {
              SystemNavigator.pop();
            }
            if (value == 0) {
              BlocProvider.of<HomeBloc>(context).add(DisplayHomeEvent());
            }
          },
          icon: Icon(Icons.menu),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              child: Text('Odśwież listę piw'),
              value: 0,
            ),
            Application.currentUser?.status == UserStatusConstants.ACTIVE
                ? PopupMenuItem(
                    child: Text('Profil'),
                    value: 2,
                  )
                : PopupMenuItem(
                    child: Text('Zarejestruj konto'),
                    value: 3,
                  ),
            PopupMenuItem(
              child: Text('O Zdalnym Browarze'),
              value: 4,
            ),
            PopupMenuItem(
              child: Text('Wyloguj'),
              value: 1,
            ),
            PopupMenuItem(
              child: Text('Zamknij'),
              value: 99,
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) async {
        if (state is HomeFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${state.error}'),
            backgroundColor: Colors.redAccent,
          ));
        } else if (state is AddedBeerSuccessfulState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Dodano pomyślnie nowe piwo do Twojego zbioru'),
            backgroundColor: Colors.green,
          ));
          BlocProvider.of<HomeBloc>(context).add(DisplayHomeEvent());
        } else if (state is HomeInitialState) {
          BlocProvider.of<HomeBloc>(context).add(DisplayHomeEvent());
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: buildAppBar(context),
            body: Center(
              child: SingleChildScrollView(
                child: state is HomeLoadedState
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          FadeAnimation(
                              2,
                              Center(
                                child: Text(
                                  'Wybierz piwo:',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 40),
                                ),
                              )),
                          SizedBox(height: kDefaultPadding),
                          FadeAnimation(
                              2,
                              BeerCarousel(
                                beers: state.beers,
                                activeBeer: state.activeBeer,
                              )),
                        ],
                      )
                    : CircularProgressIndicator(),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: scanBarcodeNormal,
              tooltip: 'Add new',
              child: Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
