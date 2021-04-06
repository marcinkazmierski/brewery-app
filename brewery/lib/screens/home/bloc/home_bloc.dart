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

class DisplayScannerState extends HomeState {}

///EVENT
abstract class HomeEvent extends Equatable {
  const HomeEvent();
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

  HomeBloc({@required this.beerRepository}) : super(HomeInitialState()) {
    print(">>>> HomeBloc START");
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is DisplayScannerEvent) {
      yield DisplayScannerState();
    }
    if (event is AddNewBeerEvent) {
      String code = event.code;
      Beer newBeer = beerRepository.addBeerByCode(code);
      //todo
    }
  }
}
