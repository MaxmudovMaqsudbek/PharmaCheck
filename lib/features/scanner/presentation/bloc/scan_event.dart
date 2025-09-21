part of 'scan_bloc.dart';

sealed class ScanEvent extends Equatable {
  const ScanEvent();
  @override
  List<Object?> get props => [];
}

class ScanRequested extends ScanEvent {
  final String uuid;
  const ScanRequested(this.uuid);
  @override
  List<Object?> get props => [uuid];
}

class ScanReset extends ScanEvent {
  const ScanReset();
}
