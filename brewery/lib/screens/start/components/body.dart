import 'package:brewery/components/fade_animation.dart';
import 'package:brewery/screens/start/bloc/start_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Body extends StatefulWidget {
  const Body({super.key});

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
                content: Text(state.error),
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
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25.0),
                child: state is CheckingAuthentication
                    ? const CircularProgressIndicator()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const FadeAnimation(
                              2,
                              CircleAvatar(
                                radius: 100.0,
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                child: Icon(Icons.wifi, size: 220),
                              )),
                          const SizedBox(
                            height: 30.0,
                          ),
                          const FadeAnimation(
                              2,
                              Center(
                                child: Text(
                                  'Zdalny browar',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 46),
                                ),
                              )),
                          const SizedBox(
                            height: 45.0,
                          ),
                          FadeAnimation(
                              2,
                              TextFormField(
                                autocorrect: false,
                                autofillHints: const [AutofillHints.email],
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                controller: _nickController,
                                key: const Key('nickInput'),
                                decoration: InputDecoration(
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.account_circle,
                                      color: Colors.black,
                                    ),
                                    hintStyle:
                                        const TextStyle(color: Colors.black54),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.5),
                                    hintText: 'Twój nick albo ksywka'),
                              )),
                          const SizedBox(
                            height: 45.0,
                          ),
                          FadeAnimation(
                              2,
                              state is RegisterGuestLoadingState
                                  ? ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.red, // background
                                        foregroundColor:
                                            Colors.white, // foreground
                                      ),
                                      child: const Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: CircularProgressIndicator()),
                                    )
                                  : ElevatedButton(
                                      onPressed: _onStartButtonPressed,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.red, // background
                                        foregroundColor:
                                            Colors.white, // foreground
                                      ),
                                      child: const Padding(
                                          padding: EdgeInsets.all(15.0),
                                          child: Text('Zaczynamy!')),
                                    )),
                          const SizedBox(
                            height: 30.0,
                          ),
                          FadeAnimation(
                              2,
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.transparent, // background
                                    foregroundColor: Colors.white, // foreground
                                    shadowColor: Colors.transparent),
                                child: const Padding(
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
