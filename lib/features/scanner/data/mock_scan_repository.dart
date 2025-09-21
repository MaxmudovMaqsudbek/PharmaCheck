// lib/scan_bloc/mock_scan_repository.dart
import 'dart:async';
import '../../../mock/mock_medicine.dart';
import 'medicine_model.dart';
import 'scan_repository.dart';

class MockScanRepository extends ScanRepository {
  final Map<String, dynamic> mockJson;
  MockScanRepository({Map<String, dynamic>? data})
      : mockJson = data ?? kMockMedicineJson,
        super();

  @override
  Future<Medicine> fetchByUuid(String uuid) async {
    // имитируем сеть
    await Future.delayed(const Duration(milliseconds: 500));
    return Medicine.fromJson(mockJson);
  }
}
