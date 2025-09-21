import 'package:flutter/material.dart';
import '../../data/medicine_model.dart'; // где объявлен Recommendation

class SimilarMedicinesSection extends StatelessWidget {
  final List<Recommendation> recommendations;
  const SimilarMedicinesSection({super.key, required this.recommendations});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context)
        .textTheme
        .titleLarge
        ?.copyWith(fontWeight: FontWeight.w800);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Similar Medicines', style: titleStyle),
        const SizedBox(height: 12),
        ...recommendations.map((r) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _SimilarMedicineTile(rec: r),
        )),
      ],
    );
  }
}

class _SimilarMedicineTile extends StatelessWidget {
  final Recommendation rec;
  const _SimilarMedicineTile({required this.rec});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final muted = isDark ? Colors.white70 : Colors.black54;
    final cost = _costInfo(rec.costStatus);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // TODO: переход на карточку аналога (если нужно)
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              // аватар/иконка
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: rec.imageExample == null || rec.imageExample!.isEmpty
                    ? Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.black.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.medication_outlined, size: 28),
                )
                    : Image.network(
                  ("http://cd2628a5ec24.ngrok-free.app/${rec.imageExample!}"),
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.black.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.medication_outlined, size: 28),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // название + бренд
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rec.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      rec.brand ?? '—',
                      style: TextStyle(color: muted),
                    ),
                  ],
                ),
              ),

              // статус цены: dot + label
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: cost.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    cost.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CostInfo {
  final String label;
  final Color color;
  const _CostInfo(this.label, this.color);
}

_CostInfo _costInfo(String? status) {
  switch ((status ?? '').toLowerCase()) {
    case 'low':
      return const _CostInfo('Affordable', Color(0xFF22C55E)); // зелёный
    case 'medium':
      return const _CostInfo('Moderate', Color(0xFFF59E0B)); // янтарный
    case 'high':
      return const _CostInfo('Expensive', Color(0xFFEF4444)); // красный
    default:
      return const _CostInfo('—', Colors.grey);
  }
}
