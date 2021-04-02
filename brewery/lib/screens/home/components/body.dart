import 'package:brewery/components/fade_animation.dart';
import 'package:brewery/screens/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:brewery/constants.dart';
import 'beer_carousel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BeerListFormState();
}

class _BeerListFormState extends State<Body> {
  Future scanBarcodeNormal() async {
    String barcodeScanRes;

    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Anuluj", true, ScanMode.QR);
    print(barcodeScanRes);
    bool closeModal = false;
    if (barcodeScanRes != "-1") {
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

      await new Future.delayed(const Duration(seconds: 2));
      closeModal = true;
      Navigator.pop(context); // close showDialog

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Dodano pomyślnie kod: "$barcodeScanRes"'),
        backgroundColor: Colors.green,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        // todo ?
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            bottomSheet: Container(
                child: Text(" version 1.0.1 ",
                    style: TextStyle(color: Colors.grey, fontSize: 8)),
                decoration: BoxDecoration(color: Colors.black)),
            body: Stack(
              children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                          colorFilter: new ColorFilter.mode(
                              Colors.black.withOpacity(0.5), BlendMode.darken),
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/bg3.jpg"))),
                ),
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: kDefaultPadding),
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
                        FadeAnimation(2, BeerCarousel()),
                      ],
                    ),
                  ),
                ),
              ],
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