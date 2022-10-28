import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pitjarusstore/data/models/store_visit.dart';
import 'package:pitjarusstore/data/repositories/store_visit_repository.dart';

part 'store_visit_event.dart';
part 'store_visit_state.dart';

class StoreVisitBloc extends Bloc<StoreVisitEvent, StoreVisitState> {
  final StoreVisitRepository _storeVisitRepository;

  StoreVisitBloc({required StoreVisitRepository storeVisitRepository})
      : _storeVisitRepository = storeVisitRepository,
        super(StoreVisitInitial()) {
    on<StoreVisitStarted>(_onStoreVisitStarted);
  }

  FutureOr<void> _onStoreVisitStarted(
      StoreVisitStarted event, Emitter<StoreVisitState> emit) async {
    try {
      emit(StoreVisitStartedInProgress());
      final storeVisit = await _storeVisitRepository.insert(event.storeVisit);
      emit(StoreVisitStartedSuccess(storeVisit: storeVisit));
    } catch (e) {
      emit(StoreVisitStartedFailure(error: e.toString()));
    }
  }
}
