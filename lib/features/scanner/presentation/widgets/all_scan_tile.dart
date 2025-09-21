import 'package:flutter/material.dart';

import '../../data/recent_scan_item.dart';

class AllScanTile extends StatelessWidget {
  final RecentScanItem item;
  const AllScanTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final muted = isDark ? Colors.white70 : Colors.black54;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: (item.imageUrl == null || item.imageUrl!.isEmpty)
              ? Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            color: isDark ? Colors.white10 : Colors.black12,
            child: const Icon(Icons.medication_outlined),
          )
              : Image.network(
            item.imageUrl!,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              color: isDark ? Colors.white10 : Colors.black12,
              child: const Icon(Icons.broken_image),
            ),
          ),
        ),
        title: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(
          'Batch: ${item.batch ?? '—'}  ·  ${_fmtShort(item.scannedAt)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: muted),
        ),
        onTap: () {
          // TODO: при желании открыть подробности / повторную проверку по uuid
          // Navigator.push(...);
        },
      ),
    );
  }

  // Без intl: yyyy-MM-dd HH:mm
  String _fmtShort(DateTime dt) {
    final d = dt.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}';
  }
}
