import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';

import '../../data/medicine_model.dart';
import '../../data/recent_scan_item.dart';
import '../../data/recent_scans_storage.dart';
import '../../data/scan_repository.dart';

part 'scan_event.dart';
part 'scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final ScanRepository repository;

  ScanBloc(this.repository) : super(const ScanState.initial()) {
    on<ScanRequested>(_onScanRequested);
    on<ScanReset>((event, emit) => emit(const ScanState.initial()));
  }

  Future<void> _onScanRequested(
      ScanRequested event,
      Emitter<ScanState> emit,
      ) async {
    emit(const ScanState.loading());

    try {
      final medicine = await repository.fetchByUuid(event.uuid);
      await RecentScansStorage.instance.upsertFromMedicine(medicine);
      emit(ScanState.success(medicine));
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        emit(const ScanState.notFound());
        return;
      }
      final msg = e.response?.data is Map
          ? (e.response?.data['detail']?.toString()
          ?? e.response?.statusMessage
          ?? 'Network error')
          : (e.message ?? 'Network error');
      emit(ScanState.failure(msg));
    } catch (e) {
      emit(ScanState.failure(e.toString()));
    }
  }
}
