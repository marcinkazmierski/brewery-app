import 'package:brewery/common/constants.dart';
import 'package:brewery/components/fade_animation.dart';
import 'package:brewery/constants.dart';
import 'package:brewery/screens/registration/bloc/registration_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _CreateLoginFormState();
}

class _CreateLoginFormState extends State<Body> {
  final _loginController = TextEditingController();
  final _nickController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;

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
                content: Text(state.error),
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
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Twoje konto jest już zarejestrowane :)'),
            backgroundColor: Colors.lightGreen,
          ));
          Navigator.pushNamed(context, '/home');
        }
        if (state is RegisteredState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
            body: Stack(
              children: <Widget>[
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
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
                          height: 20.0,
                        ),
                        FadeAnimation(
                            2,
                            const Center(
                              child: Text(
                                'Rejestracja konta',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            )),
                        const SizedBox(
                          height: 10.0,
                        ),
                        FadeAnimation(
                            2,
                            const Center(
                              child: Text(
                                'Zarejestruj konto aby w pełni korzystać z możliwości aplikacji. Twoje powiązania z kontem będą trwale zapisane w naszej bazie!',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            )),
                        const SizedBox(
                          height: 20.0,
                        ),
                        state is DisplayRegistrationPageState
                            ? FadeAnimation(
                                2,
                                TextFormField(
                                  enabled: false,
                                  style: const TextStyle(
                                    color: Colors.black45,
                                  ),
                                  controller: _nickController,
                                  key: const Key('nickInput'),
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.account_circle,
                                        color: Colors.black,
                                      ),
                                      hintStyle: const TextStyle(
                                          color: Colors.black54),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.5),
                                      hintText: 'Twój nick'),
                                ),
                              )
                            : Container(),
                        const SizedBox(
                          height: 15.0,
                        ),
                        state is DisplayRegistrationPageState
                            ? FadeAnimation(
                                2,
                                state.user.status ==
                                        UserStatusConstants
                                            .guestWaitForConfirmation
                                    ? const Center(
                                        child: Text(
                                          'Twoje konto jest w trakcie rejestracji. Dokończ proces klikając w link w mailu.',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                      )
                                    : TextFormField(
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        controller: _loginController,
                                        autofillHints: const [
                                          AutofillHints.email
                                        ],
                                        key: const Key('loginInput'),
                                        autocorrect: false,
                                        decoration: InputDecoration(
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.red),
                                            ),
                                            prefixIcon: const Icon(
                                              Icons.alternate_email,
                                              color: Colors.black,
                                            ),
                                            hintStyle: const TextStyle(
                                              color: Colors.black54,
                                            ),
                                            filled: true,
                                            fillColor:
                                                Colors.white.withOpacity(0.5),
                                            hintText: 'Twój e-mail'),
                                      ))
                            : Container(),
                        const SizedBox(
                          height: 15.0,
                        ),
                        state is DisplayRegistrationPageState &&
                                state.user.status == UserStatusConstants.guest
                            ? FadeAnimation(
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
                                        borderSide:
                                            BorderSide(color: Colors.red),
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
                                      hintStyle: const TextStyle(
                                          color: Colors.black54),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.5),
                                      hintText: 'Twoje hasło'),
                                ))
                            : Container(),
                        const SizedBox(
                          height: 45.0,
                        ),
                        FadeAnimation(
                            2,
                            state is RegistrationLoading ||
                                    (state is DisplayRegistrationPageState &&
                                        state.user.status ==
                                            UserStatusConstants
                                                .guestWaitForConfirmation)
                                ? ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red, // background
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
                                      backgroundColor: Colors.red, // background
                                      foregroundColor:
                                          Colors.white, // foreground
                                    ),
                                    child: const Padding(
                                        padding: EdgeInsets.all(15.0),
                                        child: Text('Zarejestruj!')),
                                  )),
                        const SizedBox(
                          height: 30.0,
                        ),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                    child: Container(
                  margin: const EdgeInsets.only(
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
