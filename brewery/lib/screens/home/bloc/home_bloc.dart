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
  final Beer? activeBeer;

  HomeLoadedState({required this.beers, this.activeBeer});

  @override
  List<Object> get props => [beers, activeBeer!];

  @override
  String toString() =>
      'HomeLoadedState { beers: $beers, activeBeer: $activeBeer }';
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

class DisplayHomeEvent extends HomeEvent {
  final Beer? activeBeer;

  const DisplayHomeEvent({this.activeBeer});

  @override
  List<Object> get props => [this.activeBeer!];

  @override
  String toString() => 'DisplayHomeEvent { activeBeer: $activeBeer }';
}

class DisplayScannerEvent extends HomeEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'DisplayScannerEvent {}';
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
    on<DisplayScannerEvent>(_onDisplayScannerEvent);
    on<AddNewBeerEvent>(_onAddNewBeerEvent);
    on<DisplayHomeEvent>(_onDisplayHomeEvent);
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
      final uri = await getInitialUri();
      if (uri != null && uri.queryParameters.containsKey('code')) {
        log("BEER CODE: " + uri.queryParameters['code']!);
        await beerRepository.addBeerByCode(uri.queryParameters['code']!);
        emit(AddedBeerSuccessfulState());
      }
    } catch (error) {
      // yield HomeFailureState(error: error.toString());
    }
    try {
      this.beers = await this.beerRepository.getBeers();
      emit(HomeLoadedState(beers: this.beers, activeBeer: event.activeBeer));
    } catch (error) {
      emit(HomeFailureState(error: error.toString()));
    }
  }
}
