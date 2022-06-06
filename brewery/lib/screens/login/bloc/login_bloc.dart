import 'dart:async';
import 'dart:developer';
import 'package:brewery/common/application.dart';
import 'package:brewery/models/user.dart';
import 'package:brewery/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

///STATE
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitialState extends LoginState {}

class CheckingAuth extends LoginState {}

class LoginLoading extends LoginState {}

class AuthenticationAuthenticated extends LoginState {}

class UserAuthenticatedState extends LoginState {
  final User user;

  UserAuthenticatedState({required this.user});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'UserAuthenticatedState { user: $user }';
}

class LoginCreateFailureState extends LoginState {
  final String error;

  const LoginCreateFailureState({required this.error});

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
    required this.email,
    required this.password,
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

  LoginBloc({required this.userRepository}) : super(LoginInitialState()) {
    log(">>>> LoginBloc START");
    on<AppStarted>(_onAppStarted);
    on<LogoutEvent>(_onLogoutEvent);
    on<LoginButtonPressedEvent>(_onLoginButtonPressedEvent);
    on<DisplayedLoginErrorEvent>(_onDisplayedLoginErrorEvent);
  }

  void _onAppStarted(AppStarted event, Emitter<LoginState> emit) {
    emit(LoginInitialState());
  }

  Future<void> _onLogoutEvent(
      LogoutEvent event, Emitter<LoginState> emit) async {
    await this.userRepository.logout();
    emit(LoginInitialState());
  }

  Future<void> _onLoginButtonPressedEvent(
      LoginButtonPressedEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      User user = await this.userRepository.login(event.email, event.password);
      Application.currentUser = user;
      emit(UserAuthenticatedState(user: user));
    } catch (error) {
      emit(LoginCreateFailureState(error: error.toString()));
    }
  }

  void _onDisplayedLoginErrorEvent(
      DisplayedLoginErrorEvent event, Emitter<LoginState> emit) {
    emit(LoginInitialState());
  }
}
