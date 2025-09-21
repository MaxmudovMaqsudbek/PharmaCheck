import 'dart:convert';
import 'package:dio/dio.dart';

import 'medicine_model.dart';

class ScanRepository {
  final Dio _dio;
  final String baseUrl;

  ScanRepository({
    Dio? dio,
    this.baseUrl = 'https://cd2628a5ec24.ngrok-free.app/api',
  }) : _dio = dio ??
      Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        // headers: {'Accept': 'application/json'},
      ));

  Future<Medicine> fetchByUuid(String uuid) async {
    final url = '$baseUrl/$uuid';
    final res = await _dio.get(url);

    // Dio уже парсит JSON в Map, но на всякий случай поддержим строку.
    final data = res.data["pharmacy"] is Map<String, dynamic>
        ? res.data["pharmacy"] as Map<String, dynamic>
        : json.decode(res.data["pharmacy"] as String) as Map<String, dynamic>;

    return Medicine.fromJson(data);
  }
}
