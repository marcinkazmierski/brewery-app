import 'dart:async';
import 'package:brewery/models/beer.dart';
import 'package:brewery/repositories/beer_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
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

  HomeLoadedState({this.beers});

  @override
  List<Object> get props => [beers];

  @override
  String toString() => 'HomeLoadedState { beers: $beers }';
}

class HomeCacheLoadedState extends HomeState {
  final List<Beer> beers;

  HomeCacheLoadedState({this.beers});

  @override
  List<Object> get props => [beers];

  @override
  String toString() => 'HomeCacheLoadedState { beers: $beers }';
}

class DisplayScannerState extends HomeState {}

class AddedBeerSuccessfulState extends HomeState {}

class HomeFailureState extends HomeState {
  final String error;

  const HomeFailureState({this.error});

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

  const AddNewBeerEvent({@required this.code});

  @override
  List<Object> get props => [this.code];

  @override
  String toString() => 'AddNewBeerEvent { code: $code }';
}

/// BLOC
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  BeerRepository beerRepository;
  List<Beer> beers; //todo: cache

  HomeBloc({@required this.beerRepository}) : super(HomeInitialState()) {
    print(">>>> HomeBloc START");
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is InitHomeEvent) {
      yield HomeInitialState();
      try {
        final uri = await getInitialUri();
        if (uri != null && uri.queryParameters.containsKey('code')) {
          print("BEER CODE: " + uri.queryParameters['code']);
          await beerRepository.addBeerByCode(uri.queryParameters['code']);
          yield AddedBeerSuccessfulState();
        }
      } catch (error) {
        // yield HomeFailureState(error: error.toString());
      }
    } else if (event is DisplayScannerEvent) {
      yield DisplayScannerState();
    } else if (event is AddNewBeerEvent) {
      String code = event.code;
      try {
        await beerRepository.addBeerByCode(code);
        yield AddedBeerSuccessfulState();
      } catch (error) {
        yield HomeFailureState(error: error.toString());
        yield HomeLoadedState(beers: this.beers);
      }
    } else if (event is DisplayHomeEvent) {
      // if (this.beers != null && this.beers.isNotEmpty) {
      //   yield HomeCacheLoadedState(beers: this.beers);
      // } else {
      //   yield HomeLoadingState();
      // }
      yield HomeLoadingState();
      try {
        this.beers = await this.beerRepository.getBeers();
        yield HomeLoadedState(beers: this.beers);
      } catch (error) {
        yield HomeFailureState(error: error.toString());
      }
    }
  }
}
