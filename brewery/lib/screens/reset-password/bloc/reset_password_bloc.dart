import 'dart:async';
import 'package:brewery/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

///STATE
abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object> get props => [];
}

class ResetPasswordInitialState extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetCodeSent extends ResetPasswordState {
  final bool showToast;

  const ResetCodeSent({required this.showToast});

  @override
  List<Object> get props => [showToast];

  @override
  String toString() => 'ResetCodeSent { showToast: $showToast }';
}

class PasswordChanged extends ResetPasswordState {}

class ResetPasswordSendCodeFailureState extends ResetPasswordState {
  final String error;

  const ResetPasswordSendCodeFailureState({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ResetPasswordSendCodeFailureState { error: $error }';
}

class ResetPasswordSetNewPasswordFailureState extends ResetPasswordState {
  final String error;

  const ResetPasswordSetNewPasswordFailureState({ required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() =>
      'ResetPasswordSetNewPasswordFailureState { error: $error }';
}

///EVENT
abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();
}

class ResetPasswordButtonPressedEvent extends ResetPasswordEvent {
  final String email;

  const ResetPasswordButtonPressedEvent({required this.email});

  @override
  List<Object> get props => [this.email];

  @override
  String toString() => 'ResetPasswordButtonPressedEvent { email: $email }';
}

class ResetPasswordWithCodeAndNewPasswordButtonPressedEvent
    extends ResetPasswordEvent {
  final String email;
  final String code;
  final String password;

  const ResetPasswordWithCodeAndNewPasswordButtonPressedEvent({
    required this.email,
    required this.code,
    required this.password,
  });

  @override
  List<Object> get props => [this.email, this.code, this.password];

  @override
  String toString() =>
      'ResetPasswordWithCodeAndNewPasswordButtonPressedEvent { email: $email, code: $code, password: ### }';
}

class DisplayedResetPasswordSendCodeErrorEvent extends ResetPasswordEvent {
  @override
  List<Object> get props => [];
}

class DisplayedResetPasswordSetNewPasswordErrorEvent
    extends ResetPasswordEvent {
  @override
  List<Object> get props => [];
}

/// BLOC
class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  UserRepository userRepository;

  ResetPasswordBloc({required this.userRepository})
      : super(ResetPasswordInitialState()) {
    print(">>>> ResetPasswordBloc START");
  }

  @override
  Stream<ResetPasswordState> mapEventToState(ResetPasswordEvent event) async* {
    if (event is ResetPasswordButtonPressedEvent) {
      try {
        yield ResetPasswordLoading();
        bool result = await this.userRepository.resetPassword(event.email);
        yield ResetCodeSent(showToast: true);
      } catch (error) {
        yield ResetPasswordSendCodeFailureState(error: error.toString());
      }
    }
    if (event is ResetPasswordWithCodeAndNewPasswordButtonPressedEvent) {
      try {
        yield ResetPasswordLoading();
        bool result = await this
            .userRepository
            .resetPasswordConfirm(event.email, event.code, event.password);
        yield PasswordChanged();
      } catch (error) {
        yield ResetPasswordSetNewPasswordFailureState(error: error.toString());
      }
    }
    if (event is DisplayedResetPasswordSendCodeErrorEvent) {
      yield ResetPasswordInitialState();
    }
    if (event is DisplayedResetPasswordSetNewPasswordErrorEvent) {
      yield ResetCodeSent(showToast: false);
    }
  }
}
