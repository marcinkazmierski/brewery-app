import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    log('onEvent $event');
    super.onEvent(bloc, event);
  }

  @override
  onTransition(Bloc bloc, Transition transition) {
    log('onTransition $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('onError $error');
    Sentry.captureException(error,
        stackTrace: stackTrace, hint: 'SimpleBlocObserver onError');
    super.onError(bloc, error, stackTrace);
  }
}
