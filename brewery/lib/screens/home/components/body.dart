import 'package:brewery/components/fade_animation.dart';
import 'package:brewery/screens/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:brewery/constants.dart';
import 'package:uni_links/uni_links.dart';
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

    final uri = await Uri.parse(barcodeScanRes);
    bool closeModal = false;

    if (uri != null && uri.queryParameters.containsKey('code')) {
      print("BEER CODE: " + uri.queryParameters['code']);

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
          code: uri.queryParameters['code'],
        ),
      );
    }
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
          BlocProvider.of<HomeBloc>(context).add(DisplayHomeEvent());
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
                    child: state is HomeLoadedState
                        ? Column(
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
                              FadeAnimation(
                                  2, BeerCarousel(beers: state.beers)),
                            ],
                          )
                        : CircularProgressIndicator(),
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
