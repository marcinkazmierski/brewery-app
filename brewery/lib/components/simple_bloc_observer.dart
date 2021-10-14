import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print('onEvent $event');
    FirebaseCrashlytics.instance.setCustomKey("onEvent", event.toString());
    super.onEvent(bloc, event);
  }

  @override
  onTransition(Bloc bloc, Transition transition) {
    print('onTransition $transition');
    FirebaseCrashlytics.instance
        .setCustomKey("onTransition", transition.toString());
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError $error');
    FirebaseCrashlytics.instance
        .recordError(error, stackTrace, reason: "SimpleBlocObserver onError");
    super.onError(bloc, error, stackTrace);
  }
}
