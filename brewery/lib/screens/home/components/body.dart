import 'dart:developer';
import 'package:brewery/common/application.dart';
import 'package:brewery/common/constants.dart';
import 'package:brewery/components/fade_animation.dart';
import 'package:brewery/screens/home/bloc/home_bloc.dart';
import 'package:brewery/screens/home/components/beer_card_shimmer.dart';
import 'package:brewery/screens/home/popup_menu_options.dart';
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
  void scanBarcodeNormal(BuildContext context) {
    // Either the permission was already granted before or the user just granted it.
    Permission.camera.request().isGranted.then((value) {
      if (value) {
        FlutterBarcodeScanner.scanBarcode(
                "#ff6666", "Anuluj", true, ScanMode.QR)
            .then((barcodeScanRes) {
          final uri = Uri.parse(barcodeScanRes);

          if (uri.queryParameters.containsKey('code')) {
            log("BEER CODE: ${uri.queryParameters['code']!}");

            BlocProvider.of<HomeBloc>(context).add(
              AddNewBeerEvent(
                code: uri.queryParameters['code']!,
              ),
            );
          }
        });
      } else {
        log("Camera permission is denied.");
      }
    });
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        PopupMenuButton<PopupMenuOptions>(
          onSelected: (PopupMenuOptions value) {
            if (value == PopupMenuOptions.logout) {
              Navigator.pushNamed(context, '/logout');
            }
            if (value == PopupMenuOptions.registration) {
              Navigator.pushNamed(context, '/registration');
            }
            if (value == PopupMenuOptions.about) {
              Navigator.pushNamed(context, '/about');
            }
            if (value == PopupMenuOptions.exit) {
              SystemNavigator.pop();
            }
            if (value == PopupMenuOptions.reloadHome) {
              BlocProvider.of<HomeBloc>(context).add(const DisplayHomeEvent());
            }
          },
          icon: const Icon(Icons.menu),
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: PopupMenuOptions.reloadHome,
              child: Text('Odśwież listę piw'),
            ),
            Application.currentUser?.status == UserStatusConstants.active
                ? const PopupMenuItem(
                    value: PopupMenuOptions.profile,
                    child: Text('Profil'),
                  )
                : const PopupMenuItem(
                    value: PopupMenuOptions.registration,
                    child: Text('Zarejestruj konto'),
                  ),
            const PopupMenuItem(
              value: PopupMenuOptions.about,
              child: Text('O Zdalnym Browarze'),
            ),
            const PopupMenuItem(
              value: PopupMenuOptions.logout,
              child: Text('Wyloguj'),
            ),
            const PopupMenuItem(
              value: PopupMenuOptions.exit,
              child: Text('Zamknij'),
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
            content: Text(state.error),
            backgroundColor: Colors.redAccent,
          ));
        } else if (state is AddedBeerSuccessfulState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Dodano pomyślnie nowe piwo do Twojego zbioru'),
            backgroundColor: Colors.green,
          ));
          BlocProvider.of<HomeBloc>(context).add(const DisplayHomeEvent());
        } else if (state is HomeInitialState) {
          BlocProvider.of<HomeBloc>(context).add(const DisplayHomeEvent());
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
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const FadeAnimation(
                      2,
                      Center(
                        child: Text(
                          'Wybierz piwo:',
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        ),
                      )),
                  const SizedBox(height: kDefaultPadding),
                  state is HomeLoadedState
                      ? BeerCarousel(
                          beers: state.beers,
                          activeBeer: state.activeBeer,
                        )
                      : const BeerCardShimmer(),
                ],
              )),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () => scanBarcodeNormal(context),
              tooltip: 'Add new',
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
