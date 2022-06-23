import 'dart:async';
import 'dart:developer';
import 'package:brewery/common/constants.dart';
import 'package:brewery/models/user.dart';
import 'package:brewery/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

///STATE
abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object> get props => [];
}

class RegistrationInitialState extends RegistrationState {}

class RegisteredState extends RegistrationState {}

class AlreadyRegisteredState extends RegistrationState {}

class DisplayRegistrationPageState extends RegistrationState {
  final User user;

  DisplayRegistrationPageState({required this.user});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'DisplayRegistrationPageState { user: $user }';
}

class RegistrationLoading extends RegistrationState {}

class RegistrationCreateFailureState extends RegistrationState {
  final String error;
  final bool reload;

  const RegistrationCreateFailureState(
      {required this.error, required this.reload});

  @override
  List<Object> get props => [error, reload];

  @override
  String toString() =>
      'RegistrationCreateFailureState { error: $error, reload: $reload }';
}

///EVENT
abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();
}

class RegistrationButtonPressedEvent extends RegistrationEvent {
  final String email;
  final String nick;
  final String password;

  const RegistrationButtonPressedEvent({
    required this.email,
    required this.nick,
    required this.password,
  });

  @override
  List<Object> get props => [this.email, this.nick, this.password];

  @override
  String toString() =>
      'RegistrationButtonPressedEvent { email: $email, nick: $nick, password: ### }';
}

class DisplayRegistrationPageEvent extends RegistrationEvent {
  @override
  List<Object> get props => [];
}

/// BLOC
class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  UserRepository userRepository;

  RegistrationBloc({required this.userRepository})
      : super(RegistrationInitialState()) {
    log(">>>> RegistrationBloc START");
    on<RegistrationButtonPressedEvent>(_onRegistrationButtonPressedEvent);
    on<DisplayRegistrationPageEvent>(_onDisplayRegistrationPageEvent);
  }

  Future<void> _onDisplayRegistrationPageEvent(
      DisplayRegistrationPageEvent event,
      Emitter<RegistrationState> emit) async {
    try {
      emit(RegistrationLoading());
      User user = await this.userRepository.profile();
      if (user.status == UserStatusConstants.ACTIVE) {
        emit(AlreadyRegisteredState());
      } else {
        emit(DisplayRegistrationPageState(user: user));
      }
    } catch (error) {
      emit(RegistrationCreateFailureState(
          error: error.toString(), reload: false));
    }
  }

  Future<void> _onRegistrationButtonPressedEvent(
      RegistrationButtonPressedEvent event,
      Emitter<RegistrationState> emit) async {
    try {
      emit(RegistrationLoading());
      User user = await this.userRepository.profile();
      if (user.status == UserStatusConstants.ACTIVE) {
        emit(AlreadyRegisteredState());
      } else {
        await this.userRepository.registerGuest(event.email, event.password);
        emit(RegisteredState());
      }
    } catch (error) {
      emit(RegistrationCreateFailureState(
          error: error.toString(), reload: true));
    }
  }
}
