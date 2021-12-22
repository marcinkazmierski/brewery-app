import 'dart:async';
import 'package:brewery/models/beer.dart';
import 'package:brewery/models/review.dart';
import 'package:brewery/repositories/beer_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

///STATE
abstract class DetailsState extends Equatable {
  final Beer beer;

  DetailsState({@required this.beer});

  @override
  List<Object> get props => [beer];

  @override
  String toString() => 'DetailsState { beer: $beer }';
}

class DetailsInitialState extends DetailsState {}

class DetailsDisplayState extends DetailsState {
  DetailsDisplayState({@required Beer beer}) : super(beer: beer);

  @override
  String toString() => 'DetailsDisplayState { beer: $beer }';
}

class AddReviewLoadingState extends DetailsState {
  AddReviewLoadingState({@required Beer beer}) : super(beer: beer);

  @override
  String toString() => 'AddReviewLoadingState { beer: $beer }';
}

class AddedReviewSuccessfulState extends DetailsState {
  AddedReviewSuccessfulState({@required Beer beer}) : super(beer: beer);

  @override
  String toString() => 'AddedReviewSuccessfulState { beer: $beer }';
}

class DeleteReviewLoadingState extends DetailsState {
  DeleteReviewLoadingState({@required Beer beer}) : super(beer: beer);

  @override
  String toString() => 'DeleteReviewLoadingState { beer: $beer }';
}

class DeletedReviewSuccessfulState extends DetailsState {
  DeletedReviewSuccessfulState({@required Beer beer}) : super(beer: beer);

  @override
  String toString() => 'DeletedReviewSuccessfulState { beer: $beer }';
}

class DetailsFailureState extends DetailsState {
  final String error;

  DetailsFailureState({@required this.error, @required Beer beer})
      : super(beer: beer);

  @override
  List<Object> get props => [error, beer];

  @override
  String toString() => 'DetailsFailureState { error: $error }';
}

///EVENT
abstract class DetailsEvent extends Equatable {
  const DetailsEvent();
}

class DisplayDetailsEvent extends DetailsEvent {
  final Beer beer;

  const DisplayDetailsEvent({@required this.beer});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'DisplayDetailsEvent { beer: $beer }';
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

class DeleteReviewEvent extends DetailsEvent {
  final Beer beer;
  final Review review;

  const DeleteReviewEvent({@required this.beer, @required this.review});

  @override
  List<Object> get props => [this.beer, this.review];

  @override
  String toString() => 'DeleteReviewEvent { beer: $beer, comment: $review }';
}

/// BLOC
class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final BeerRepository beerRepository;

  DetailsBloc({@required this.beerRepository}) : super(DetailsInitialState()) {
    print(">>>> DetailsBloc START");
  }

  @override
  Stream<DetailsState> mapEventToState(DetailsEvent event) async* {
    if (event is DisplayDetailsEvent) {
      yield DetailsInitialState();
      // Beer beer = await beerRepository.getBeerById(event.beer.id); // reload
      yield DetailsDisplayState(beer: event.beer);
    } else if (event is AddNewReviewEvent) {
      try {
        yield AddReviewLoadingState(beer: event.beer);
        Beer beer = await beerRepository.addReview(
            event.beer, event.comment, event.rating.toDouble());
        yield AddedReviewSuccessfulState(beer: beer);
      } catch (error) {
        yield DetailsFailureState(error: error.toString(), beer: event.beer);
      }
    } else if (event is DeleteReviewEvent) {
      print("TODO: delete review");

      try {
        // TODO: dokończyć widok usuwania, loadingu i message po usunięciu recenzji...
        yield DeleteReviewLoadingState(beer: event.beer);
        Beer beer = await beerRepository.deleteReview(event.beer, event.review);
        yield DeletedReviewSuccessfulState(beer: beer);
      } catch (error) {
        yield DetailsFailureState(error: error.toString(), beer: event.beer);
      }
    }
  }
}
