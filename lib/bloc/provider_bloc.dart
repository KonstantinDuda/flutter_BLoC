import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ProviderEvent {rootPage, chackPage}

@immutable 
abstract class ProviderState {}

class RootState extends ProviderState {}

class ChackState extends ProviderState {}

class ProviderBloc extends Bloc<ProviderEvent, ProviderState> {
  ProviderBloc() : super(RootState());

  @override 
  Stream<ProviderState> mapEventToState(ProviderEvent event) async* {
    switch (event) {
      case ProviderEvent.rootPage:
        yield RootState();
        break;
      case ProviderEvent.chackPage:
        yield ChackState();
        break;
    }
  }
}