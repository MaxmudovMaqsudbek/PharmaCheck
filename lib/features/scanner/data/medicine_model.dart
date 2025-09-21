import 'package:equatable/equatable.dart';

class Medicine extends Equatable {
  final String uuid;
  final String name;
  final String? brand;
  final String? brandCertLink;
  final String? brandLicenceLink;
  final String? dosageForm;
  final String? strength;
  final String? activeIngredients; // JSON: activeingredients
  final String? gtin;
  final String? batch;
  final DateTime? manufactureDate;  // "2025-09-20"
  final DateTime? expiryDate;       // "2025-09-20"
  final String? storageConditions;  // JSON: StorageConditions
  final String? regulatoryInfo;
  final String? imageExample;
  final DateTime? createdAt;        // created_at
  final DateTime? updatedAt;        // updated_at
  final bool isRead;

  // NEW:
  final String? costStatus; // "low" | "medium" | "high" (по API строка)
  final List<Recommendation> recommendations;

  const Medicine({
    required this.uuid,
    required this.name,
    this.brand,
    this.brandCertLink,
    this.brandLicenceLink,
    this.dosageForm,
    this.strength,
    this.activeIngredients,
    this.gtin,
    this.batch,
    this.manufactureDate,
    this.expiryDate,
    this.storageConditions,
    this.regulatoryInfo,
    this.imageExample,
    this.createdAt,
    this.updatedAt,
    required this.isRead,
    this.costStatus,
    this.recommendations = const [],
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? v) =>
        v == null || v.isEmpty ? null : DateTime.tryParse(v);

    final recsJson = json['recommendations'] as List<dynamic>?;
    final recs = recsJson == null
        ? const <Recommendation>[]
        : recsJson
        .whereType<Map<String, dynamic>>()
        .map(Recommendation.fromJson)
        .toList();

    return Medicine(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String?,
      brandCertLink: json['brandCertLink'] as String?,
      brandLicenceLink: json['brandLicenceLink'] as String?,
      dosageForm: json['dosageForm'] as String?,
      strength: json['strength'] as String?,
      activeIngredients: json['activeingredients'] as String?,
      gtin: json['gtin'] as String?,
      batch: json['batch'] as String?,
      manufactureDate: parseDate(json['manufactureDate'] as String?),
      expiryDate: parseDate(json['expiryDate'] as String?),
      storageConditions: json['StorageConditions'] as String?,
      regulatoryInfo: json['regulatoryInfo'] as String?,
      imageExample: json['imageExample'] as String?,
      createdAt: parseDate(json['created_at']?.toString()),
      updatedAt: parseDate(json['updated_at']?.toString()),
      isRead: (json['is_read'] as bool?) ?? false,
      costStatus: json['cost_status'] as String?,
      recommendations: recs,
    );
  }

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'brand': brand,
    'brandCertLink': brandCertLink,
    'brandLicenceLink': brandLicenceLink,
    'dosageForm': dosageForm,
    'strength': strength,
    'activeingredients': activeIngredients,
    'gtin': gtin,
    'batch': batch,
    'manufactureDate': manufactureDate?.toIso8601String(),
    'expiryDate': expiryDate?.toIso8601String(),
    'StorageConditions': storageConditions,
    'regulatoryInfo': regulatoryInfo,
    'imageExample': imageExample,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'is_read': isRead,
    // NEW:
    'cost_status': costStatus,
    'recommendations': recommendations.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props =>
      [uuid, name, batch, gtin, updatedAt, costStatus, recommendations];
}

class Recommendation extends Equatable {
  final String name;
  final String? brand;
  final String? costStatus; // "low" | "medium" | "high"
  final String? imageExample;

  const Recommendation({
    required this.name,
    this.brand,
    this.costStatus,
    this.imageExample,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) => Recommendation(
    name: json['name'] as String,
    brand: json['brand'] as String?,
    costStatus: json['cost_status'] as String?,
    imageExample: json['imageExample'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'brand': brand,
    'cost_status': costStatus,
    'imageExample': imageExample,
  };

  @override
  List<Object?> get props => [name, brand, costStatus, imageExample];
}
