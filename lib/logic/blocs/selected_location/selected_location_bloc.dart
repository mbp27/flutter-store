import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

part 'selected_location_event.dart';
part 'selected_location_state.dart';

class SelectedLocationBloc
    extends Bloc<SelectedLocationEvent, SelectedLocationState> {
  SelectedLocationBloc() : super(SelectedLocationInitial()) {
    on<SelectedLocationLoad>(_onSelectedLocationLoad);
  }

  FutureOr<void> _onSelectedLocationLoad(
      SelectedLocationLoad event, Emitter<SelectedLocationState> emit) async {
    try {
      emit(SelectedLocationLoadInProgress());
      await Geolocator.requestPermission();
      final position = await Geolocator.getCurrentPosition();
      emit(SelectedLocationLoadSuccess(position: position));
    } catch (e) {
      emit(SelectedLocationLoadFailure(error: e));
    }
  }
}
