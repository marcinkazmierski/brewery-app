import 'dart:async';
import 'package:brewery/components/simple_bloc_observer.dart';
import 'package:brewery/gateways/local_storage_gateway.dart';
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
import 'package:sentry_flutter/sentry_flutter.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  LocalStorageGateway localStorageGateway = LocalStorageGateway();

  Bloc.observer = SimpleBlocObserver();
  // Initialize Firebase.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on UnsupportedError catch (_) {}

  // Initialize Sentry.
  await SentryFlutter.init(
    (options) {
      options.dsn = dotenv.env['SENTRY_DSN'].toString();
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(MyApp(
        beerRepository: ApiBeerRepository(
            apiUrl: dotenv.env['API_URL'].toString(),
            localStorageGateway: localStorageGateway),
        userRepository: ApiUserRepository(
            apiUrl: dotenv.env['API_URL'].toString(),
            localStorageGateway: localStorageGateway))),
  );
}

class MyApp extends StatelessWidget {
  BeerRepository beerRepository;
  UserRepository userRepository;

  MyApp({
    super.key,
    required this.beerRepository,
    required this.userRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Zdalny Browar',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.red,
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
                      RegistrationBloc(userRepository: userRepository)
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
                      ResetPasswordBloc(userRepository: userRepository),
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
                      DetailsBloc(beerRepository: beerRepository)
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
          create: (context) => StartBloc(userRepository: userRepository)
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
              LoginBloc(userRepository: userRepository)..add(AppStarted()),
        ),
      ],
      child: LoginScreen(),
    );
  }

  MultiBlocProvider Logout(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) =>
              LoginBloc(userRepository: userRepository)..add(LogoutEvent()),
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
          create: (context) => HomeBloc(beerRepository: beerRepository)
            ..add(DisplayHomeEvent(activeBeer: beer)),
        ),
      ],
      child: HomeScreen(),
    );
  }
}
