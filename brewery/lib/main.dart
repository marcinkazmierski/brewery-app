import 'package:brewery/components/simple_bloc_observer.dart';
import 'package:brewery/screens/home/bloc/home_bloc.dart';
import 'package:brewery/screens/login/bloc/login_bloc.dart';
import 'package:brewery/screens/login/login_screen.dart';
import 'package:brewery/screens/registration/bloc/registration_bloc.dart';
import 'package:brewery/screens/registration/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:brewery/screens/home/home_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// void main() {
//   runApp(MyApp());
// }

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(
    BlocProvider<LoginBloc>(
      create: (context) {
        LoginBloc loginBloc = LoginBloc();
        return loginBloc;
      },
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Beer App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: 'login',
        routes: {
          //todo: ogarnąć to z dokumentacji BLoC!
          'login': (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<LoginBloc>(
                  create: (context) => LoginBloc(),
                ),
              ],
              child: LoginScreen(),
            );
          },
          'registration': (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<RegistrationBloc>(
                  create: (context) => RegistrationBloc(),
                ),
              ],
              child: RegistrationScreen(),
            );
          },
          'home': (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<HomeBloc>(
                  create: (context) => HomeBloc(),
                ),
              ],
              child: HomeScreen(),
            );
          }
        });
  }
}

class MyApp2 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beer App',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
