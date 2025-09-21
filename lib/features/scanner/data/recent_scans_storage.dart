import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'recent_scan_item.dart';
import 'medicine_model.dart'; // твой Medicine

class RecentScansStorage {
  static final RecentScansStorage instance = RecentScansStorage._();
  RecentScansStorage._();

  static const _key = 'recent_scans_v1';
  static const _maxKeep = 50; // лимит хранимых записей

  final ValueNotifier<List<RecentScanItem>> items = ValueNotifier(const []);

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    items.value = _load();
  }

  List<RecentScanItem> _load() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const [];
    final list = (json.decode(raw) as List)
        .whereType<Map<String, dynamic>>()
        .map(RecentScanItem.fromJson)
        .toList()
      ..sort((a, b) => b.scannedAt.compareTo(a.scannedAt)); // desc
    return list;
  }

  Future<void> _save(List<RecentScanItem> list) async {
    final enc = json.encode(list.map((e) => e.toJson()).toList());
    await _prefs.setString(_key, enc);
    items.value = List.unmodifiable(list);
  }

  /// upsert по uuid + обновить scannedAt, поставить элемент в начало
  Future<void> upsert(RecentScanItem item) async {
    final list = List<RecentScanItem>.from(items.value);
    list.removeWhere((e) => e.uuid == item.uuid);
    list.insert(0, item);
    if (list.length > _maxKeep) list.removeRange(_maxKeep, list.length);
    await _save(list);
  }

  Future<void> upsertFromMedicine(Medicine m) => upsert(
    RecentScanItem(
      uuid: m.uuid,
      name: m.name,
      batch: m.batch,
      imageUrl: m.imageExample,
      scannedAt: DateTime.now(),
    ),
  );

  List<RecentScanItem> lastN(int n) =>
      List<RecentScanItem>.from(items.value.take(n));
}
