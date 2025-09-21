class RecentScanItem {
  final String uuid;
  final String name;
  final String? batch;
  final String? imageUrl;
  final DateTime scannedAt;

  const RecentScanItem({
    required this.uuid,
    required this.name,
    required this.scannedAt,
    this.batch,
    this.imageUrl,
  });

  factory RecentScanItem.fromJson(Map<String, dynamic> j) => RecentScanItem(
    uuid: j['uuid'] as String,
    name: j['name'] as String,
    batch: j['batch'] as String?,
    imageUrl: j['imageUrl'] as String?,
    scannedAt: DateTime.parse(j['scannedAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'batch': batch,
    'imageUrl': imageUrl,
    'scannedAt': scannedAt.toIso8601String(),
  };
}
