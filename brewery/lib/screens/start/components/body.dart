import 'package:brewery/components/fade_animation.dart';
import 'package:brewery/constants.dart';
import 'package:brewery/screens/start/bloc/start_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _CreateLoginFormState();
}

class _CreateLoginFormState extends State<Body> {
  final _nickController = TextEditingController();

  _onStartButtonPressed() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    BlocProvider.of<StartBloc>(context).add(
      LoginGuestButtonPressedEvent(
        nick: _nickController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StartBloc, StartState>(
      listener: (context, state) {
        if (state is StartFailureState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.redAccent,
              ))
              .closed
              .then((value) => BlocProvider.of<StartBloc>(context)
                  .add(DisplayedLoginErrorEvent()));
        }
        if (state is GuestAuthenticatedState) {
          Navigator.pushNamed(context, '/home');
        }
      },
      child: BlocBuilder<StartBloc, StartState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            bottomSheet: Container(
                child: Text(kAppVersion,
                    style: TextStyle(color: Colors.grey, fontSize: 8)),
                decoration: BoxDecoration(color: Colors.black)),
            body: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(25.0),
                child: state is CheckingAuthentication
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
                                autocorrect: false,
                                autofillHints: [AutofillHints.email],
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
                                    hintText: 'Twój nick albo ksywka'),
                              )),
                          SizedBox(
                            height: 45.0,
                          ),
                          FadeAnimation(
                              2,
                              state is RegisterGuestLoadingState
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
                                      onPressed: _onStartButtonPressed,
                                      child: Padding(
                                          padding: EdgeInsets.all(15.0),
                                          child: Text('Zaczynamy!')),
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
                                  Navigator.pushNamed(context, '/login');
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
          );
        },
      ),
    );
  }
}
