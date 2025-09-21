import 'package:flutter/material.dart';


class RecentScanTile extends StatelessWidget {
  final String name;
  final String batch;
  final String imageUrl;

  const RecentScanTile({
    required this.name,
    required this.batch,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            imageUrl,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          'Batch No: $batch',
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        // trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: null,
      ),
    );
  }
}