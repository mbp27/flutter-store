part of 'selected_location_bloc.dart';

abstract class SelectedLocationState extends Equatable {
  const SelectedLocationState();

  @override
  List<Object?> get props => [];
}

class SelectedLocationInitial extends SelectedLocationState {}

class SelectedLocationLoadInProgress extends SelectedLocationState {}

class SelectedLocationLoadSuccess extends SelectedLocationState {
  final Position position;

  const SelectedLocationLoadSuccess({
    required this.position,
  });

  @override
  List<Object?> get props => [position];
}

class SelectedLocationLoadFailure extends SelectedLocationState {
  final Object error;

  const SelectedLocationLoadFailure({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
