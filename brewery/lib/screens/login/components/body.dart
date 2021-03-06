import 'package:brewery/components/fade_animation.dart';
import 'package:brewery/constants.dart';
import 'package:brewery/screens/login/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _CreateLoginFormState();
}

class _CreateLoginFormState extends State<Body> {
  final _loginController = TextEditingController(text: "test"); //todo
  final _passwordController = TextEditingController(text: "testtest");

  _onLoginButtonPressed() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    BlocProvider.of<LoginBloc>(context).add(
      LoginButtonPressedEvent(
        email: _loginController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginCreateFailureState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.redAccent,
              ))
              .closed
              .then((value) => BlocProvider.of<LoginBloc>(context)
                  .add(DisplayedLoginErrorEvent()));
        }
        if (state is UserAuthenticatedState) {
          Navigator.pushNamed(context, '/home');
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Scaffold(
            bottomSheet: Container(
                child: Text(kAppVersion,
                    style: TextStyle(color: Colors.grey, fontSize: 8)),
                decoration: BoxDecoration(color: Colors.black)),
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
                    child: state is CheckingAuth
                        ? CircularProgressIndicator()
                        : Column(
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
                                          borderSide:
                                              BorderSide(color: Colors.red),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.alternate_email,
                                          color: Colors.black,
                                        ),
                                        hintStyle:
                                            TextStyle(color: Colors.black54),
                                        filled: true,
                                        fillColor:
                                            Colors.white.withOpacity(0.5),
                                        hintText: 'Tw??j e-mail'),
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
                                          borderSide:
                                              BorderSide(color: Colors.red),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.vpn_key,
                                          color: Colors.black,
                                        ),
                                        hintStyle:
                                            TextStyle(color: Colors.black54),
                                        filled: true,
                                        fillColor:
                                            Colors.white.withOpacity(0.5),
                                        hintText: 'Twoje has??o'),
                                  )),
                              SizedBox(
                                height: 45.0,
                              ),
                              FadeAnimation(
                                  2,
                                  state is LoginLoading
                                      ? ElevatedButton(
                                          onPressed: () {},
                                          child: Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child:
                                                  CircularProgressIndicator()),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.red, // background
                                            onPrimary:
                                                Colors.white, // foreground
                                          ),
                                        )
                                      : ElevatedButton(
                                          onPressed: _onLoginButtonPressed,
                                          child: Padding(
                                              padding: EdgeInsets.all(15.0),
                                              child: Text('Zaczynamy!')),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.red, // background
                                            onPrimary:
                                                Colors.white, // foreground
                                          ),
                                        )),
                              SizedBox(
                                height: 30.0,
                              ),
                              FadeAnimation(
                                  2,
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context,
                                          '/registration'); //todo, use BLoC
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary:
                                            Colors.transparent, // background
                                        onPrimary: Colors.white, // foreground
                                        shadowColor: Colors.transparent),
                                    child: Padding(
                                        padding: EdgeInsets.all(15.0),
                                        child:
                                            Text('Jeste?? nowy? Stw??rz konto')),
                                  )),
                              FadeAnimation(
                                  2,
                                  ElevatedButton(
                                    onPressed: () {
                                      print('reset-password');
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary:
                                            Colors.transparent, // background
                                        onPrimary: Colors.white, // foreground
                                        shadowColor: Colors.transparent),
                                    child: Padding(
                                        padding: EdgeInsets.all(15.0),
                                        child: Text('Nie pami??tasz has??a?')),
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
