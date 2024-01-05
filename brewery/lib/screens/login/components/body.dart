import 'package:brewery/components/fade_animation.dart';
import 'package:brewery/screens/login/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _CreateLoginFormState();
}

class _CreateLoginFormState extends State<Body> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;

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
                content: Text(state.error),
                backgroundColor: Colors.redAccent,
              ))
              .closed
              .then((value) => BlocProvider.of<LoginBloc>(context)
                  .add(DisplayedLoginErrorEvent()));
        }
        if (state is UserAuthenticatedState) {
          Navigator.pushNamed(context, '/home');
        }
        if (state is LoggedOutState) {
          Navigator.pushNamed(context, '/start');
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25.0),
                child: state is CheckingAuth
                    ? const CircularProgressIndicator()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          FadeAnimation(
                              2,
                              const CircleAvatar(
                                radius: 100.0,
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                child: Icon(Icons.wifi, size: 220),
                              )),
                          const SizedBox(
                            height: 30.0,
                          ),
                          FadeAnimation(
                              2,
                              const Center(
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
                                controller: _loginController,
                                key: const Key('loginInput'),
                                decoration: InputDecoration(
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.alternate_email,
                                      color: Colors.black,
                                    ),
                                    hintStyle:
                                        const TextStyle(color: Colors.black54),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.5),
                                    hintText: 'Twój e-mail'),
                              )),
                          const SizedBox(
                            height: 15.0,
                          ),
                          FadeAnimation(
                              2,
                              TextFormField(
                                obscureText: _isObscure,
                                enableSuggestions: false,
                                autocorrect: false,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                controller: _passwordController,
                                key: const Key('passwordInput'),
                                decoration: InputDecoration(
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                    prefixIcon: const Icon(
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
                                        const TextStyle(color: Colors.black54),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.5),
                                    hintText: 'Twoje hasło'),
                              )),
                          const SizedBox(
                            height: 45.0,
                          ),
                          FadeAnimation(
                              2,
                              state is LoginLoading
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
                                      onPressed: _onLoginButtonPressed,
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
                                  Navigator.pushNamed(
                                      context, '/reset-password');
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.transparent, // background
                                    foregroundColor: Colors.white, // foreground
                                    shadowColor: Colors.transparent),
                                child: const Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Text('Nie pamiętasz hasła?')),
                              )),
                          FadeAnimation(
                              2,
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/start');
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.transparent, // background
                                    foregroundColor: Colors.white, // foreground
                                    shadowColor: Colors.transparent),
                                child: const Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Text('Zacznij jako gość')),
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
