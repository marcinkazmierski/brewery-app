import 'dart:async';
import 'dart:developer';
import 'package:brewery/models/beer.dart';
import 'package:brewery/repositories/beer_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:uni_links/uni_links.dart';

///STATE
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final List<Beer> beers;

  HomeLoadedState({required this.beers});

  @override
  List<Object> get props => [beers];

  @override
  String toString() => 'HomeLoadedState { beers: $beers }';
}

class HomeCacheLoadedState extends HomeState {
  final List<Beer> beers;

  HomeCacheLoadedState({required this.beers});

  @override
  List<Object> get props => [beers];

  @override
  String toString() => 'HomeCacheLoadedState { beers: $beers }';
}

class DisplayScannerState extends HomeState {}

class AddedBeerSuccessfulState extends HomeState {}

class HomeFailureState extends HomeState {
  final String error;

  const HomeFailureState({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'HomeFailureState { error: $error }';
}

///EVENT
abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class InitHomeEvent extends HomeEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'InitHomeEvent {}';
}

class DisplayHomeEvent extends HomeEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'DisplayHomeEvent {}';
}

class DisplayScannerEvent extends HomeEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'DisplayScannerEvent { }';
}

class AddNewBeerEvent extends HomeEvent {
  final String code;

  const AddNewBeerEvent({required this.code});

  @override
  List<Object> get props => [this.code];

  @override
  String toString() => 'AddNewBeerEvent { code: $code }';
}

/// BLOC
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  BeerRepository beerRepository;
  List<Beer> beers = []; //todo: cache

  HomeBloc({required this.beerRepository}) : super(HomeInitialState()) {
    log(">>>> HomeBloc START");
    on<InitHomeEvent>(_onInitHomeEvent);
    on<DisplayScannerEvent>(_onDisplayScannerEvent);
    on<AddNewBeerEvent>(_onAddNewBeerEvent);
    on<DisplayHomeEvent>(_onDisplayHomeEvent);
  }

  Future<void> _onInitHomeEvent(
      InitHomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeInitialState());
    try {
      final uri = await getInitialUri();
      if (uri != null && uri.queryParameters.containsKey('code')) {
        log("BEER CODE: " + uri.queryParameters['code']!);
        await beerRepository.addBeerByCode(uri.queryParameters['code']!);
        emit(AddedBeerSuccessfulState());
      }
    } catch (error) {
      // yield HomeFailureState(error: error.toString());
    }
  }

  void _onDisplayScannerEvent(
      DisplayScannerEvent event, Emitter<HomeState> emit) {
    emit(DisplayScannerState());
  }

  Future<void> _onAddNewBeerEvent(
      AddNewBeerEvent event, Emitter<HomeState> emit) async {
    String code = event.code;
    try {
      await beerRepository.addBeerByCode(code);
      emit(AddedBeerSuccessfulState());
    } catch (error) {
      emit(HomeFailureState(error: error.toString()));
      emit(HomeLoadedState(beers: this.beers));
    }
  }

  Future<void> _onDisplayHomeEvent(
      DisplayHomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    try {
      this.beers = await this.beerRepository.getBeers();
      emit(HomeLoadedState(beers: this.beers));
    } catch (error) {
      emit(HomeFailureState(error: error.toString()));
    }
  }
}
