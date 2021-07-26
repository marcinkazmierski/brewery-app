import 'dart:async';
import 'package:brewery/models/beer.dart';
import 'package:brewery/repositories/beer_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

///STATE
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitialState extends HomeState {}

class HomeLoadedState extends HomeState {
  final List<Beer> beers;

  HomeLoadedState({this.beers});

  @override
  List<Object> get props => [beers];

  @override
  String toString() => 'HomeLoadedState { beers: $beers }';
}

class DisplayScannerState extends HomeState {}

class AddedBeerSuccessfulState extends HomeState {}

class AddedReviewSuccessfulState extends HomeState {}

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

class AddNewReviewEvent extends HomeEvent {
  final Beer beer;
  final String comment;
  final int rating;

  const AddNewReviewEvent(
      {@required this.beer, @required this.comment, @required this.rating});

  @override
  List<Object> get props => [this.beer, this.comment, this.rating];

  @override
  String toString() =>
      'AddNewReviewEvent { beer: $beer, comment: $comment, rating: $rating }';
}

/// BLOC
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  BeerRepository beerRepository;

  HomeBloc({@required this.beerRepository}) : super(HomeInitialState()) {
    print(">>>> HomeBloc START");
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is DisplayScannerEvent) {
      yield DisplayScannerState();
    } else if (event is AddNewBeerEvent) {
      String code = event.code;
      try {
        await beerRepository.addBeerByCode(code);
        yield AddedBeerSuccessfulState();
      } catch (error) {
        yield HomeFailureState(error: error.toString());
      }
    } else if (event is DisplayHomeEvent) {
      yield HomeInitialState();
      try {
        List<Beer> beers = await this.beerRepository.getBeers();
        yield HomeLoadedState(beers: beers);
      } catch (error) {
        yield HomeFailureState(error: error.toString());
      }
    } else if (event is AddNewReviewEvent) {
      try {
        await beerRepository.addReview(
            event.beer, event.comment, event.rating.toDouble());
        yield AddedReviewSuccessfulState();
      } catch (error) {
        yield HomeFailureState(error: error.toString());
      }
    }
  }
}
