import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pitjarusstore/data/models/store.dart';
import 'package:pitjarusstore/data/repositories/store_repository.dart';

part 'store_list_event.dart';
part 'store_list_state.dart';

class StoreListBloc extends Bloc<StoreListEvent, StoreListState> {
  final StoreRepository _storeRepository;

  StoreListBloc({required StoreRepository storeRepository})
      : _storeRepository = storeRepository,
        super(StoreListInitial()) {
    on<StoreListLoad>(_onStoreListLoad);
  }

  FutureOr<void> _onStoreListLoad(
      StoreListLoad event, Emitter<StoreListState> emit) async {
    try {
      emit(StoreListLoadInProgress());
      final stores = await _storeRepository.getStores();
      emit(StoreListLoadSuccess(stores: stores));
    } catch (e) {
      emit(StoreListLoadFailure(error: e.toString()));
    }
  }
}
