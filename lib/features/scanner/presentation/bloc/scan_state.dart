part of 'scan_bloc.dart';

class ScanState extends Equatable {
  final bool loading;
  final Medicine? data;
  final String? error;
  final bool isNotFound;

  const ScanState._({required this.loading, this.data, this.error, this.isNotFound = false,});

  const ScanState.initial() : this._(loading: false);
  const ScanState.loading() : this._(loading: true);
  const ScanState.success(Medicine m) : this._(loading: false, data: m);
  const ScanState.failure(String msg) : this._(loading: false, error: msg);
  const ScanState.notFound([String msg = 'Medicine not found'])
      : this._(loading: false, error: msg, isNotFound: true);

  @override
  List<Object?> get props => [loading, data, error, isNotFound];
}
