import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

///STATE
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitialState extends HomeState {}

///EVENT
abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

/// BLOC
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitialState()) {
    print(">>>> HomeBloc START");
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {}
}
