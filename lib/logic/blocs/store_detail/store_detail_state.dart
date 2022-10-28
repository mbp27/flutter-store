part of 'store_detail_bloc.dart';

abstract class StoreDetailState extends Equatable {
  const StoreDetailState();

  @override
  List<Object?> get props => [];
}

class StoreDetailInitial extends StoreDetailState {}

class StoreDetailLoadInProgress extends StoreDetailState {}

class StoreDetailLoadSuccess extends StoreDetailState {
  final Store store;

  const StoreDetailLoadSuccess({required this.store});

  @override
  List<Object?> get props => [store];
}

class StoreDetailLoadFailure extends StoreDetailState {
  final String error;

  const StoreDetailLoadFailure({required this.error});
}
