import 'dart:async';
import 'package:brewery/components/simple_bloc_observer.dart';
import 'package:brewery/gateways/local_storage_gateway.dart';
import 'package:brewery/gateways/notifications_gateway.dart';
import 'package:brewery/models/beer.dart';
import 'package:brewery/repositories/beer_repository.dart';
import 'package:brewery/repositories/user_repository.dart';
import 'package:brewery/screens/about/about_screen.dart';
import 'package:brewery/screens/details/details_screen.dart';
import 'package:brewery/screens/home/bloc/home_bloc.dart';
import 'package:brewery/screens/details/bloc/details_bloc.dart';
import 'package:brewery/screens/login/bloc/login_bloc.dart';
import 'package:brewery/screens/login/login_screen.dart';
import 'package:brewery/screens/registration/bloc/registration_bloc.dart';
import 'package:brewery/screens/registration/registration_screen.dart';
import 'package:brewery/screens/reset-password/bloc/reset_password_bloc.dart';
import 'package:brewery/screens/reset-password/reset_password_screen.dart';
import 'package:brewery/screens/start/bloc/start_bloc.dart';
import 'package:brewery/screens/start/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:brewery/screens/home/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  LocalStorageGateway localStorageGateway = new LocalStorageGateway();

  BlocOverrides.runZoned(
    () async {
      // Initialize Firebase.
      await Firebase.initializeApp();
      NotificationsGateway()..init();
      runApp(MyApp(
          beerRepository: new ApiBeerRepository(
              apiUrl: dotenv.env['API_URL'].toString(),
              localStorageGateway: localStorageGateway),
          userRepository: new ApiUserRepository(
              apiUrl: dotenv.env['API_URL'].toString(),
              localStorageGateway: localStorageGateway)));
    },
    blocObserver: SimpleBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  BeerRepository beerRepository;
  UserRepository userRepository;

  MyApp({
    required this.beerRepository,
    required this.userRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Zdalny Browar',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/start',
        routes: {
          '/': (context) => Start(context),
          '/start': (context) => Start(context),
          '/login': (context) => Login(context),
          '/logout': (context) => Logout(context),
          '/registration': (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<RegistrationBloc>(
                  create: (context) =>
                      RegistrationBloc(userRepository: this.userRepository)
                        ..add(DisplayRegistrationPageEvent()),
                ),
              ],
              child: RegistrationScreen(),
            );
          },
          '/reset-password': (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<ResetPasswordBloc>(
                  create: (context) =>
                      ResetPasswordBloc(userRepository: this.userRepository),
                ),
              ],
              child: ResetPasswordScreen(),
            );
          },
          '/home': (context) => Home(context),
          '/details': (context) {
            final Beer beer =
                ModalRoute.of(context)?.settings.arguments as Beer;
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
          },
          '/about': (context) => AboutScreen(),
        });
  }

  MultiBlocProvider Start(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<StartBloc>(
          create: (context) => StartBloc(userRepository: this.userRepository)
            ..add(ApplicationStarted()),
        ),
      ],
      child: StartScreen(),
    );
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
    final Beer? beer = ModalRoute.of(context)?.settings.arguments as Beer?;

    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(beerRepository: this.beerRepository)
            ..add(DisplayHomeEvent(activeBeer: beer)),
        ),
      ],
      child: HomeScreen(),
    );
  }
}
