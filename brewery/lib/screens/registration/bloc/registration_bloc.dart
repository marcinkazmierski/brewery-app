import 'dart:async';
import 'dart:developer';
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

class RegistrationLoading extends RegistrationState {}

class RegistrationCreateFailureState extends RegistrationState {
  final String error;

  const RegistrationCreateFailureState({required this.error});

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

class DisplayedRegistrationErrorEvent extends RegistrationEvent {
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
    on<DisplayedRegistrationErrorEvent>(_onDisplayedRegistrationErrorEvent);
  }

  Future<void> _onRegistrationButtonPressedEvent(
      RegistrationButtonPressedEvent event,
      Emitter<RegistrationState> emit) async {
    try {
      emit(RegistrationLoading());
      bool result = await this
          .userRepository
          .register(event.email, event.nick, event.password);
      emit(RegisteredState());
    } catch (error) {
      emit(RegistrationCreateFailureState(error: error.toString()));
    }
  }

  void _onDisplayedRegistrationErrorEvent(
      DisplayedRegistrationErrorEvent event, Emitter<RegistrationState> emit) {
    emit(RegistrationInitialState());
  }
}
