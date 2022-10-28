part of 'store_detail_bloc.dart';

abstract class StoreDetailEvent extends Equatable {
  const StoreDetailEvent();

  @override
  List<Object?> get props => [];
}

class StoreDetailLoad extends StoreDetailEvent {
  final Store store;

  const StoreDetailLoad({required this.store});

  @override
  List<Object?> get props => [store];
}
