import 'dart:async';
import 'package:brewery/models/user.dart';
import 'package:brewery/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:developer';

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
    log(">>>> StartBloc START");
    on<ApplicationStarted>(_onApplicationStarted);
    on<LoginGuestButtonPressedEvent>(_onLoginGuestButtonPressedEvent);
    on<DisplayedLoginErrorEvent>(_onDisplayedLoginErrorEvent);
  }

  Future<void> _onApplicationStarted(
      ApplicationStarted event, Emitter<StartState> emit) async {
    emit(CheckingAuthentication());
    try {
      User user = await this.userRepository.profile();
      emit(GuestAuthenticatedState(user: user));
    } catch (error) {
      log(error.toString());
      emit(StartInitialState());
    }
  }

  Future<void> _onLoginGuestButtonPressedEvent(
      LoginGuestButtonPressedEvent event, Emitter<StartState> emit) async {
    emit(RegisterGuestLoadingState());
    try {
      User user = await this.userRepository.loginGuest(event.nick);
      emit(GuestAuthenticatedState(user: user));
    } catch (error) {
      emit(StartFailureState(error: error.toString()));
    }
  }

  void _onDisplayedLoginErrorEvent(
      DisplayedLoginErrorEvent event, Emitter<StartState> emit) {
    emit(StartInitialState());
  }
}
