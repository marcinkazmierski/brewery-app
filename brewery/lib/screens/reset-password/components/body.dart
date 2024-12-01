import 'package:brewery/components/fade_animation.dart';
import 'package:brewery/screens/reset-password/bloc/reset_password_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _CreateLoginFormState();
}

class _CreateLoginFormState extends State<Body> {
  final _loginController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isObscure = true;

  _onSendCodeButtonPressed() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    BlocProvider.of<ResetPasswordBloc>(context).add(
      ResetPasswordButtonPressedEvent(email: _loginController.text),
    );
  }

  _onSetNewPasswordButtonPressed() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    BlocProvider.of<ResetPasswordBloc>(context).add(
      ResetPasswordWithCodeAndNewPasswordButtonPressedEvent(
          email: _loginController.text,
          code: _codeController.text,
          password: _passwordController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordBloc, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSendCodeFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
            backgroundColor: Colors.redAccent,
          ));

          BlocProvider.of<ResetPasswordBloc>(context)
              .add(DisplayedResetPasswordSendCodeErrorEvent());
        }
        if (state is ResetPasswordSetNewPasswordFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
            backgroundColor: Colors.redAccent,
          ));
          BlocProvider.of<ResetPasswordBloc>(context)
              .add(DisplayedResetPasswordSetNewPasswordErrorEvent());
        }
        if (state is ResetCodeSent && state.showToast) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(milliseconds: 6000),
            content: Text(
                'Kod resetujący został wysłany. Sprawdź swoją skrzynkę i wpisz kod oraz nowe hasło w formularzu.'),
            backgroundColor: Colors.lightGreen,
          ));
        }
        if (state is PasswordChanged) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(milliseconds: 6000),
            content: Text(
                'Twoje hasło zmieniono pomyślnie. Zaloguj się do aplikacji wpisując nowe hasło.'),
            backgroundColor: Colors.lightGreen,
          ));
          Navigator.pushNamed(context, '/login');
        }
      },
      child: BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
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
                                'Podaj Twój adres e-mail, aby resetować hasło. Następnie na podaną skrzynkę zostanie wysłany tymczasowy kod potrzebny do zakończenia procesu ustawniania nowego hasła dla Twojego konta.',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            )),
                        const SizedBox(
                          height: 20.0,
                        ),
                        FadeAnimation(
                            2,
                            TextFormField(
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              controller: _loginController,
                              autocorrect: false,
                              autofillHints: const [AutofillHints.email],
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
                        state is ResetCodeSent
                            ? FadeAnimation(
                                2,
                                TextFormField(
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  controller: _codeController,
                                  key: const Key('codeInput'),
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
                                      hintText: 'Twój kod resetujący z emaila'),
                                ))
                            : Container(),
                        state is ResetCodeSent
                            ? const SizedBox(
                                height: 15.0,
                              )
                            : Container(),
                        state is ResetCodeSent
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
                        state is ResetCodeSent
                            ? const SizedBox(
                                height: 45.0,
                              )
                            : Container(),
                        FadeAnimation(
                            2,
                            state is ResetPasswordLoading
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
                                : state is ResetPasswordInitialState
                                    ? ElevatedButton(
                                        onPressed: _onSendCodeButtonPressed,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.red, // background
                                          foregroundColor:
                                              Colors.white, // foreground
                                        ),
                                        child: const Padding(
                                            padding: EdgeInsets.all(15.0),
                                            child: Text(
                                                'Wyślij kod resetujący na podany e-mail!')),
                                      )
                                    : ElevatedButton(
                                        onPressed:
                                            _onSetNewPasswordButtonPressed,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.red, // background
                                          foregroundColor:
                                              Colors.white, // foreground
                                        ),
                                        child: const Padding(
                                            padding: EdgeInsets.all(15.0),
                                            child: Text('Ustaw nowe hasło')),
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
                                  backgroundColor: Colors.transparent,
                                  // background
                                  foregroundColor: Colors.white,
                                  // foreground
                                  shadowColor: Colors.transparent),
                              child: const Padding(
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
