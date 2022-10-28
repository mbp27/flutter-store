part of 'store_visit_bloc.dart';

abstract class StoreVisitState extends Equatable {
  const StoreVisitState();

  @override
  List<Object?> get props => [];
}

class StoreVisitInitial extends StoreVisitState {}

class StoreVisitStartedInProgress extends StoreVisitState {}

class StoreVisitStartedSuccess extends StoreVisitState {
  final StoreVisit storeVisit;

  const StoreVisitStartedSuccess({
    required this.storeVisit,
  });

  @override
  List<Object?> get props => [storeVisit];
}

class StoreVisitStartedFailure extends StoreVisitState {
  final String error;

  const StoreVisitStartedFailure({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}
