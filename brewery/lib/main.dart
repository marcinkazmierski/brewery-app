import 'dart:async';

import 'package:brewery/components/simple_bloc_observer.dart';
import 'package:brewery/gateways/local_storage_gateway.dart';
import 'package:brewery/models/beer.dart';
import 'package:brewery/repositories/beer_repository.dart';
import 'package:brewery/repositories/user_repository.dart';
import 'package:brewery/screens/details/details_screen.dart';
import 'package:brewery/screens/home/bloc/home_bloc.dart';
import 'package:brewery/screens/details/bloc/details_bloc.dart';
import 'package:brewery/screens/login/bloc/login_bloc.dart';
import 'package:brewery/screens/login/login_screen.dart';
import 'package:brewery/screens/registration/bloc/registration_bloc.dart';
import 'package:brewery/screens/registration/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:brewery/screens/home/home_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  Bloc.observer = SimpleBlocObserver();
  await dotenv.load(fileName: ".env");
  LocalStorageGateway localStorageGateway = new LocalStorageGateway();

  // Initialize Firebase.
  await Firebase.initializeApp();

  runApp(MyApp(
      beerRepository: new ApiBeerRepository(
          apiUrl: dotenv.env['API_URL'].toString(),
          localStorageGateway: localStorageGateway),
      userRepository: new ApiUserRepository(
          apiUrl: dotenv.env['API_URL'].toString(),
          localStorageGateway: localStorageGateway)));
}

class MyApp extends StatelessWidget {
  BeerRepository beerRepository;
  UserRepository userRepository;

  MyApp(
      {@required
          this.beerRepository,
      @required
          this.userRepository}); // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Zdalny Browar',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/login',
        routes: {
          '/': (context) => Login(context),
          '/login': (context) => Login(context),
          '/logout': (context) => Logout(context),
          '/registration': (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<RegistrationBloc>(
                  create: (context) =>
                      RegistrationBloc(userRepository: this.userRepository),
                ),
              ],
              child: RegistrationScreen(),
            );
          },
          '/home': (context) => Home(context),
          '/details': (context) {
            final Beer beer = ModalRoute.of(context).settings.arguments as Beer;
            return MultiBlocProvider(
              providers: [
                BlocProvider<DetailsBloc>(
                  create: (context) =>
                      DetailsBloc(beerRepository: this.beerRepository)
                        ..add(DisplayDetailsEvent(beer: beer)),
                ),
              ],
              child: DetailsScreen(),
            );
          }
        });
  }

  MultiBlocProvider Login(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) =>
              LoginBloc(userRepository: this.userRepository)..add(AppStarted()),
        ),
      ],
      child: LoginScreen(),
    );
  }

  MultiBlocProvider Logout(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(userRepository: this.userRepository)
            ..add(LogoutEvent()),
        ),
      ],
      child: LoginScreen(),
    );
  }

  MultiBlocProvider Home(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(beerRepository: this.beerRepository)
            ..add(InitHomeEvent()),
        ),
      ],
      child: HomeScreen(),
    );
  }
}
