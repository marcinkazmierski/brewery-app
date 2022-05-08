import 'dart:async';
import 'package:brewery/models/user.dart';
import 'package:brewery/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

///STATE
abstract class StartState extends Equatable {
  const StartState();

  @override
  List<Object> get props => [];
}

class StartInitialState extends StartState {}

class CheckingAuthentication extends StartState {}

class RegisterGuestAccountState extends StartState {}

class RegisterGuestLoadingState extends StartState {}

class GuestAuthenticatedState extends StartState {
  final User user;

  GuestAuthenticatedState({required this.user});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'GuestAuthenticatedState { user: $user }';
}

class StartFailureState extends StartState {
  final String error;

  const StartFailureState({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'StartFailureState { error: $error }';
}

///EVENT
abstract class StartEvent extends Equatable {
  const StartEvent();
}

class ApplicationStarted extends StartEvent {
  @override
  List<Object> get props => [];
}

class LoginGuestButtonPressedEvent extends StartEvent {
  final String nick;

  LoginGuestButtonPressedEvent({required this.nick});

  @override
  List<Object> get props => [this.nick];

  @override
  String toString() => 'LoginGuestButtonPressedEvent { nick: $nick }';
}

class DisplayedLoginErrorEvent extends StartEvent {
  @override
  List<Object> get props => [];
}

/// BLOC
class StartBloc extends Bloc<StartEvent, StartState> {
  UserRepository userRepository;

  StartBloc({required this.userRepository}) : super(StartInitialState()) {
    print(">>>> StartBloc START");
  }

  @override
  Stream<StartState> mapEventToState(StartEvent event) async* {
    if (event is ApplicationStarted) {
      yield CheckingAuthentication();
      try {
        User user = await this.userRepository.profile();
        yield GuestAuthenticatedState(user: user);
      } catch (error) {
        print(error.toString());
        yield StartInitialState();
      }
    }
    if (event is LoginGuestButtonPressedEvent) {
      yield RegisterGuestLoadingState();
      try {
        User user = await this.userRepository.loginGuest(event.nick);
        yield GuestAuthenticatedState(user: user);
      } catch (error) {
        yield StartFailureState(error: error.toString());
      }
    }
    if (event is DisplayedLoginErrorEvent) {
      yield StartInitialState();
    }
  }
}
