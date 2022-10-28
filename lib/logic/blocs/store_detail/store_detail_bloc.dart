import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pitjarusstore/data/models/store.dart';
import 'package:pitjarusstore/data/repositories/store_repository.dart';

part 'store_detail_event.dart';
part 'store_detail_state.dart';

class StoreDetailBloc extends Bloc<StoreDetailEvent, StoreDetailState> {
  final StoreRepository _storeRepository;

  StoreDetailBloc({required StoreRepository storeRepository})
      : _storeRepository = storeRepository,
        super(StoreDetailInitial()) {
    on<StoreDetailLoad>(_onStoreDetailLoad);
  }

  FutureOr<void> _onStoreDetailLoad(
      StoreDetailLoad event, Emitter<StoreDetailState> emit) async {
    try {
      emit(StoreDetailLoadInProgress());
      final storeId = event.store.id;
      if (storeId == null) throw 'Terdapat kesalahan';
      final store = await _storeRepository.getStoreDetail(storeId);
      if (store == null) throw 'Data tidak ditemukan';
      emit(StoreDetailLoadSuccess(store: store));
    } catch (e) {
      emit(StoreDetailLoadFailure(error: e.toString()));
    }
  }
}
