import 'dart:async';
import 'package:brewery/models/beer.dart';
import 'package:brewery/repositories/beer_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

///STATE
abstract class DetailsState extends Equatable {
  const DetailsState();

  @override
  List<Object> get props => [];
}

class DetailsInitialState extends DetailsState {}

class DetailsLoadedState extends DetailsState {
  final Beer beer;

  DetailsLoadedState({this.beer});

  @override
  List<Object> get props => [beer];

  @override
  String toString() => 'DetailsLoadedState { beer: $beer }';
}

class AddedReviewSuccessfulState extends DetailsState {}

class DetailsFailureState extends DetailsState {
  final String error;

  const DetailsFailureState({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'DetailsFailureState { error: $error }';
}

///EVENT
abstract class DetailsEvent extends Equatable {
  const DetailsEvent();
}

class DisplayDetailsEvent extends DetailsEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'DisplayDetailsEvent {}';
}

class AddNewReviewEvent extends DetailsEvent {
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
class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  BeerRepository beerRepository;

  DetailsBloc({@required this.beerRepository}) : super(DetailsInitialState()) {
    print(">>>> DetailsBloc START");
  }

  @override
  Stream<DetailsState> mapEventToState(DetailsEvent event) async* {
    if (event is DisplayDetailsEvent) {
      yield DetailsInitialState();
// todo
    } else if (event is AddNewReviewEvent) {
      try {
        await beerRepository.addReview(
            event.beer, event.comment, event.rating.toDouble());
        //todo: new state
      } catch (error) {
        yield DetailsFailureState(error: error.toString());
      }
    }
  }
}
