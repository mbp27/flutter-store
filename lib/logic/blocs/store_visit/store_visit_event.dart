part of 'store_visit_bloc.dart';

abstract class StoreVisitEvent extends Equatable {
  const StoreVisitEvent();

  @override
  List<Object?> get props => [];
}

class StoreVisitStarted extends StoreVisitEvent {
  final StoreVisit storeVisit;

  const StoreVisitStarted({
    required this.storeVisit,
  });

  @override
  List<Object?> get props => [storeVisit];
}
