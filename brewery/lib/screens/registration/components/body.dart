import 'package:brewery/common/constants.dart';
import 'package:brewery/components/fade_animation.dart';
import 'package:brewery/constants.dart';
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
  bool _isObscure = true; //todo bloc

  _onLoginButtonPressed() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

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
              .then((value) {});
          if (state.reload) {
            BlocProvider.of<RegistrationBloc>(context)
                .add(DisplayRegistrationPageEvent());
          }
        }
        if (state is DisplayRegistrationPageState) {
          _nickController.text = state.user.nick;
        }
        if (state is AlreadyRegisteredState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Twoje konto jest już zarejestrowane :)'),
            backgroundColor: Colors.lightGreen,
          ));
          Navigator.pushNamed(context, '/home');
        }
        if (state is RegisteredState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 6000),
            content: Text(
                'Zarejestrowano pomyślnie. Sprawdź mail w celu dokończenia procesu!'),
            backgroundColor: Colors.lightGreen,
          ));
          Navigator.pushNamed(context, '/home');
        }
      },
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            bottomSheet: Container(
                child: Text(kAppVersion,
                    style: TextStyle(color: Colors.grey, fontSize: 8)),
                decoration: BoxDecoration(color: Colors.black)),
            body: Stack(
              children: <Widget>[
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
                          height: 20.0,
                        ),
                        FadeAnimation(
                            2,
                            Center(
                              child: Text(
                                'Rejestracja konta',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            )),
                        SizedBox(
                          height: 20.0,
                        ),
                        state is DisplayRegistrationPageState
                            ? FadeAnimation(
                                2,
                                TextFormField(
                                  enabled: false,
                                  style: TextStyle(
                                    color: Colors.black45,
                                  ),
                                  controller: _nickController,
                                  key: Key('nickInput'),
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.account_circle,
                                        color: Colors.black,
                                      ),
                                      hintStyle:
                                          TextStyle(color: Colors.black54),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.5),
                                      hintText: 'Twój nick'),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: 15.0,
                        ),
                        state is DisplayRegistrationPageState
                            ? FadeAnimation(
                                2,
                                state.user.status ==
                                        UserStatusConstants
                                            .GUEST_WAIT_FOR_CONFIRMATION
                                    ? Center(
                                        child: Text(
                                          'Twoje konto jest w trakcie rejestracji. Dokończ proces klikając w link w mailu.',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                      )
                                    : TextFormField(
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                        controller: _loginController,
                                        autofillHints: [AutofillHints.email],
                                        key: Key('loginInput'),
                                        autocorrect: false,
                                        decoration: InputDecoration(
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.red),
                                            ),
                                            prefixIcon: Icon(
                                              Icons.alternate_email,
                                              color: Colors.black,
                                            ),
                                            hintStyle: TextStyle(
                                                color: Colors.black54),
                                            filled: true,
                                            fillColor:
                                                Colors.white.withOpacity(0.5),
                                            hintText: 'Twój e-mail'),
                                      ))
                            : Container(),
                        SizedBox(
                          height: 15.0,
                        ),
                        state is DisplayRegistrationPageState &&
                                state.user.status == UserStatusConstants.GUEST
                            ? FadeAnimation(
                                2,
                                TextFormField(
                                  obscureText: _isObscure,
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
                                      suffixIcon: IconButton(
                                          icon: Icon(
                                            _isObscure
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isObscure = !_isObscure;
                                            });
                                          }),
                                      hintStyle:
                                          TextStyle(color: Colors.black54),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.5),
                                      hintText: 'Twoje hasło'),
                                ))
                            : Container(),
                        SizedBox(
                          height: 45.0,
                        ),
                        FadeAnimation(
                            2,
                            state is RegistrationLoading ||
                                    (state is DisplayRegistrationPageState &&
                                        state.user.status ==
                                            UserStatusConstants
                                                .GUEST_WAIT_FOR_CONFIRMATION)
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
                      ],
                    ),
                  ),
                ),
                SafeArea(
                    child: Container(
                  margin: EdgeInsets.only(
                      left: kDefaultPadding, top: kDefaultPadding),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: BackButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/home');
                      },
                      color: Colors.white),
                )),
              ],
            ),
          );
        },
      ),
    );
  }
}
