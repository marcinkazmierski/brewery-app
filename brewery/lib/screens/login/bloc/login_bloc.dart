import 'dart:async';
import 'package:brewery/models/user.dart';
import 'package:brewery/repositories/user_repository.dart';
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

class LoginLoading extends LoginState {}

class AuthenticationAuthenticated extends LoginState {}

class UserAuthenticatedState extends LoginState {
  final User user;

  UserAuthenticatedState({this.user});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'UserAuthenticatedState { user: $user }';
}

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

class AppStarted extends LoginEvent {
  @override
  List<Object> get props => [];
}

class LogoutEvent extends LoginEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'LogoutEvent {}';
}

class LoginButtonPressedEvent extends LoginEvent {
  final String email;
  final String password;

  const LoginButtonPressedEvent({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [this.email, this.password];

  @override
  String toString() =>
      'LoginButtonPressedEvent { email: $email, password: ### }';
}

class DisplayedLoginErrorEvent extends LoginEvent {
  @override
  List<Object> get props => [];
}

/// BLOC
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository userRepository;

  LoginBloc({@required this.userRepository}) : super(LoginInitialState()) {
    print(">>>> LoginBloc START");
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is AppStarted) {
      try {
        User user = await this.userRepository.profile();
        yield UserAuthenticatedState(user: user);
      } catch (error) {
        print(error.toString());
        yield LoginInitialState();
      }
    }
    if (event is LoginButtonPressedEvent) {
      yield LoginLoading();
      try {
        User user =
            await this.userRepository.login(event.email, event.password);
        yield UserAuthenticatedState(user: user);
      } catch (error) {
        yield LoginCreateFailureState(error: error.toString());
      }
    }
    if (event is DisplayedLoginErrorEvent) {
      yield LoginInitialState();
    }

    if (event is LogoutEvent) {
      await this.userRepository.logout();
      yield LoginInitialState();
    }
  }
}
