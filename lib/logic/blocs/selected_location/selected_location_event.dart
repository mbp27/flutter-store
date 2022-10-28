part of 'selected_location_bloc.dart';

abstract class SelectedLocationEvent extends Equatable {
  const SelectedLocationEvent();

  @override
  List<Object?> get props => [];
}

class SelectedLocationLoad extends SelectedLocationEvent {}
