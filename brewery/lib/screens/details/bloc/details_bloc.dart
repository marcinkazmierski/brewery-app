import 'dart:async';
import 'dart:developer';
import 'package:brewery/models/beer.dart';
import 'package:brewery/models/review.dart';
import 'package:brewery/repositories/beer_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

///STATE

abstract class DetailsInitState extends Equatable {
  const DetailsInitState();

  @override
  List<Object> get props => [];
}

class DetailsState extends DetailsInitState {
  final Beer beer;

  DetailsState({required this.beer});

  @override
  List<Object> get props => [beer];

  @override
  String toString() => 'DetailsState { beer: $beer }';
}

class DetailsInitialState extends DetailsInitState {}

class DetailsDisplayState extends DetailsState {
  DetailsDisplayState({required Beer beer}) : super(beer: beer);

  @override
  String toString() => 'DetailsDisplayState { beer: $beer }';
}

class AddReviewLoadingState extends DetailsState {
  AddReviewLoadingState({required Beer beer}) : super(beer: beer);

  @override
  String toString() => 'AddReviewLoadingState { beer: $beer }';
}

class AddedReviewSuccessfulState extends DetailsState {
  AddedReviewSuccessfulState({required Beer beer}) : super(beer: beer);

  @override
  String toString() => 'AddedReviewSuccessfulState { beer: $beer }';
}

class DeleteReviewLoadingState extends DetailsState {
  DeleteReviewLoadingState({required Beer beer}) : super(beer: beer);

  @override
  String toString() => 'DeleteReviewLoadingState { beer: $beer }';
}

class DeletedReviewSuccessfulState extends DetailsState {
  DeletedReviewSuccessfulState({required Beer beer}) : super(beer: beer);

  @override
  String toString() => 'DeletedReviewSuccessfulState { beer: $beer }';
}

class DetailsFailureState extends DetailsState {
  final String error;

  DetailsFailureState({required this.error, required Beer beer})
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

  const DisplayDetailsEvent({required this.beer});

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
      {required this.beer, required this.comment, required this.rating});

  @override
  List<Object> get props => [this.beer, this.comment, this.rating];

  @override
  String toString() =>
      'AddNewReviewEvent { beer: $beer, comment: $comment, rating: $rating }';
}

class DeleteReviewEvent extends DetailsEvent {
  final Beer beer;
  final Review review;

  const DeleteReviewEvent({required this.beer, required this.review});

  @override
  List<Object> get props => [this.beer, this.review];

  @override
  String toString() => 'DeleteReviewEvent { beer: $beer, comment: $review }';
}

/// BLOC
class DetailsBloc extends Bloc<DetailsEvent, DetailsInitState> {
  final BeerRepository beerRepository;

  DetailsBloc({required this.beerRepository}) : super(DetailsInitialState()) {
    log(">>>> DetailsBloc START");
    on<DisplayDetailsEvent>(_onDisplayDetailsEvent);
    on<AddNewReviewEvent>(_onAddNewReviewEvent);
    on<DeleteReviewEvent>(_onDeleteReviewEvent);
  }

  void _onDisplayDetailsEvent(
      DisplayDetailsEvent event, Emitter<DetailsInitState> emit) {
    emit(DetailsInitialState());
    emit(DetailsDisplayState(beer: event.beer));
  }

  Future<void> _onAddNewReviewEvent(
      AddNewReviewEvent event, Emitter<DetailsInitState> emit) async {
    try {
      emit(AddReviewLoadingState(beer: event.beer));
      Beer beer = await beerRepository.addReview(
          event.beer, event.comment, event.rating.toDouble());
      emit(AddedReviewSuccessfulState(beer: beer));
    } catch (error) {
      emit(DetailsFailureState(error: error.toString(), beer: event.beer));
    }
  }

  Future<void> _onDeleteReviewEvent(
      DeleteReviewEvent event, Emitter<DetailsInitState> emit) async {
    log("TODO: delete review");
    try {
      // TODO: dokończyć widok usuwania, loadingu i message po usunięciu recenzji...
      emit(DeleteReviewLoadingState(beer: event.beer));
      Beer beer = await beerRepository.deleteReview(event.beer, event.review);
      emit(DeletedReviewSuccessfulState(beer: beer));
    } catch (error) {
      emit(DetailsFailureState(error: error.toString(), beer: event.beer));
    }
  }
}
