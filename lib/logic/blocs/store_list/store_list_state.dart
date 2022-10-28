part of 'store_list_bloc.dart';

abstract class StoreListState extends Equatable {
  const StoreListState();

  @override
  List<Object?> get props => [];
}

class StoreListInitial extends StoreListState {}

class StoreListLoadInProgress extends StoreListState {}

class StoreListLoadSuccess extends StoreListState {
  final List<Store> stores;

  const StoreListLoadSuccess({required this.stores});

  @override
  List<Object?> get props => [stores];
}

class StoreListLoadFailure extends StoreListState {
  final String error;

  const StoreListLoadFailure({required this.error});
}
