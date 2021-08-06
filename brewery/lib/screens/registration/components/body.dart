import 'package:brewery/components/fade_animation.dart';
import 'package:brewery/screens/registration/bloc/registration_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _CreateLoginFormState();
}

class _CreateLoginFormState extends State<Body> {
  final _loginController = TextEditingController();
  final _nickController = TextEditingController();
  final _passwordController = TextEditingController();

  _onLoginButtonPressed() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    //Navigator.pushNamed(context, '/login');
    BlocProvider.of<RegistrationBloc>(context).add(
      RegistrationButtonPressedEvent(
        email: _loginController.text,
        nick: _nickController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state is RegistrationCreateFailureState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.redAccent,
              ))
              .closed
              .then((value) => BlocProvider.of<RegistrationBloc>(context)
                  .add(DisplayedRegistrationErrorEvent()));
        }
        if (state is RegisteredState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Zarejestrowano pomyślnie. Sprawdź mail w celu dokończenia procesu!'),
            backgroundColor: Colors.lightGreen,
          ));
          Navigator.pushNamed(context, '/login');
        }
      },
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          colorFilter: new ColorFilter.mode(
                              Colors.black.withOpacity(0.5), BlendMode.darken),
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/bg3.jpg"))),
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        FadeAnimation(
                            2,
                            CircleAvatar(
                              radius: 100.0,
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              child: Icon(Icons.wifi, size: 220),
                            )),
                        SizedBox(
                          height: 30.0,
                        ),
                        FadeAnimation(
                            2,
                            Center(
                              child: Text(
                                'Zdalny browar',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 46),
                              ),
                            )),
                        SizedBox(
                          height: 45.0,
                        ),
                        FadeAnimation(
                            2,
                            TextFormField(
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              controller: _loginController,
                              key: Key('loginInput'),
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.alternate_email,
                                    color: Colors.black,
                                  ),
                                  hintStyle: TextStyle(color: Colors.black54),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.5),
                                  hintText: 'Twój e-mail'),
                            )),
                        SizedBox(
                          height: 15.0,
                        ),
                        FadeAnimation(
                            2,
                            TextFormField(
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              controller: _nickController,
                              key: Key('nickInput'),
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.account_circle,
                                    color: Colors.black,
                                  ),
                                  hintStyle: TextStyle(color: Colors.black54),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.5),
                                  hintText: 'Twój nick'),
                            )),
                        SizedBox(
                          height: 15.0,
                        ),
                        FadeAnimation(
                            2,
                            TextFormField(
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              controller: _passwordController,
                              key: Key('passwordInput'),
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.vpn_key,
                                    color: Colors.black,
                                  ),
                                  hintStyle: TextStyle(color: Colors.black54),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.5),
                                  hintText: 'Twoje hasło'),
                            )),
                        SizedBox(
                          height: 45.0,
                        ),
                        FadeAnimation(
                            2,
                            state is RegistrationLoading
                                ? ElevatedButton(
                                    onPressed: () {},
                                    child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: CircularProgressIndicator()),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red, // background
                                      onPrimary: Colors.white, // foreground
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: _onLoginButtonPressed,
                                    child: Padding(
                                        padding: EdgeInsets.all(15.0),
                                        child: Text('Zarejestruj!')),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red, // background
                                      onPrimary: Colors.white, // foreground
                                    ),
                                  )),
                        SizedBox(
                          height: 30.0,
                        ),
                        FadeAnimation(
                            2,
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/login'); //todo, use BLoC
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent, // background
                                  onPrimary: Colors.white, // foreground
                                  shadowColor: Colors.transparent),
                              child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text('Masz już konto? Zaloguj się')),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
