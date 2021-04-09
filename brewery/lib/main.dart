import 'package:brewery/components/simple_bloc_observer.dart';
import 'package:brewery/models/user.dart';
import 'package:brewery/repositories/beer_repository.dart';
import 'package:brewery/repositories/user_repository.dart';
import 'package:brewery/screens/home/bloc/home_bloc.dart';
import 'package:brewery/screens/login/bloc/login_bloc.dart';
import 'package:brewery/screens/login/login_screen.dart';
import 'package:brewery/screens/registration/bloc/registration_bloc.dart';
import 'package:brewery/screens/registration/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:brewery/screens/home/home_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp(
      beerRepository: new FakeBeerRepository(),
      userRepository: new FakeUserRepository()));
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
        initialRoute: 'login',
        routes: {
          //todo: ogarnąć to z dokumentacji BLoC!
          'login': (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<LoginBloc>(
                  create: (context) =>
                      LoginBloc(userRepository: this.userRepository),
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
            final User user = ModalRoute.of(context).settings.arguments as User;
            //todo
            print("USER: " + user.email);
            return MultiBlocProvider(
              providers: [
                BlocProvider<HomeBloc>(
                  create: (context) =>
                      HomeBloc(beerRepository: this.beerRepository),
                ),
              ],
              child: HomeScreen(),
            );
          }
        });
  }
}
