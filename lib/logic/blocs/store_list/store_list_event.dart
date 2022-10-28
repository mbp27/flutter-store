part of 'store_list_bloc.dart';

abstract class StoreListEvent extends Equatable {
  const StoreListEvent();

  @override
  List<Object?> get props => [];
}

class StoreListLoad extends StoreListEvent {}
