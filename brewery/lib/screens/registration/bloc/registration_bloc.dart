import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

///STATE
abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object> get props => [];
}

class RegistrationInitialState extends RegistrationState {}

class RegistrationCreateFailureState extends RegistrationState {
  final String error;

  const RegistrationCreateFailureState({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'RegistrationCreateFailureState { error: $error }';
}

///EVENT
abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();
}

class RegistrationButtonPressedEvent extends RegistrationEvent {
  final String login;
  final String nick;
  final String password;

  const RegistrationButtonPressedEvent({
    @required this.login,
    @required this.nick,
    @required this.password,
  });

  @override
  List<Object> get props => [this.login, this.nick, this.password];

  @override
  String toString() =>
      'RegistrationButtonPressedEvent { login: $login, nick: $nick, password: ### }';
}

class DisplayedRegistrationErrorEvent extends RegistrationEvent {
  @override
  List<Object> get props => [];
}

/// BLOC
class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(RegistrationInitialState()) {
    print(">>>> RegistrationBloc START");
  }

  @override
  Stream<RegistrationState> mapEventToState(RegistrationEvent event) async* {
    if (event is RegistrationButtonPressedEvent) {
      //todo
      yield RegistrationCreateFailureState(
          error: "Invalid login or password. Try again!");
    }
    if (event is DisplayedRegistrationErrorEvent) {
      yield RegistrationInitialState();
    }
  }
}
