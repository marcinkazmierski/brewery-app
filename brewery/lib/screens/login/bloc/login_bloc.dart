import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

///STATE
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitialState extends LoginState {}

class LoginCreateFailureState extends LoginState {
  final String error;

  const LoginCreateFailureState({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'LoginCreateFailureState { error: $error }';
}

///EVENT
abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressedEvent extends LoginEvent {
  final String login;
  final String password;

  const LoginButtonPressedEvent({
    @required this.login,
    @required this.password,
  });

  @override
  List<Object> get props => [this.login, this.password];

  @override
  String toString() =>
      'LoginButtonPressedEvent { login: $login, password: ### }';
}

class DisplayedLoginErrorEvent extends LoginEvent {
  @override
  List<Object> get props => [];
}

/// BLOC
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    print(">>>> LoginBloc START");
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressedEvent) {
      yield LoginCreateFailureState(
          error: "Invalid login or password. Try again!");
    }
    if (event is DisplayedLoginErrorEvent) {
      yield LoginInitialState();
    }
  }
}
