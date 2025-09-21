
import 'package:flutter/material.dart';
import '../../data/medicine_model.dart';
import '../widgets/similar_medicines_section.dart';

class VerificationResultPage extends StatefulWidget {
  final Medicine medicine;

  const VerificationResultPage({
    super.key,
    required this.medicine,
  });

  @override
  State<VerificationResultPage> createState() => _VerificationResultPageState();
}

class _VerificationResultPageState extends State<VerificationResultPage> {

  String _fmtDate(DateTime? d) => d == null ? '—' : d.toIso8601String().substring(0, 10);

  @override
  Widget build(BuildContext context) {
    final m = widget.medicine;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Verification Result'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Статус (пока фиксированный "Authentic" — можно сделать динамическим по полю)

              if(!m.isRead)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFDFF7DF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: const [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFF22C55E),
                      child: Icon(Icons.verified, color: Colors.white, size: 44),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Authentic',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF166534),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'This medicine is verified and authentic.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),

              if(m.isRead)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2), // red-100
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: const [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0xFFEF4444), // red-500
                        child: Icon(Icons.warning_amber_rounded, color: Colors.white, size: 44),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Already Sold',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF991B1B), // red-800
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'This medicine has already been sold. Do not purchase or consume it. '
                            'Please report this to the relevant authorities.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),


              const SizedBox(height: 16),

              // Большое изображение препарата
              AspectRatio(
                aspectRatio: 3 / 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    m.imageExample ??
                        'https://picsum.photos/800/1200?blur=2', // плейсхолдер
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.black12,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, size: 48),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Medicine Details',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),

              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Column(
                    children: [
                      _DetailRow(label: 'Product Name', value: m.name),
                      const _DividerRow(),
                      _DetailRow(
                        label: 'Manufacturing Date',
                        value: _fmtDate(m.manufactureDate),
                      ),
                      const _DividerRow(),
                      _DetailRow(
                        label: 'Expiration Date',
                        value: _fmtDate(m.expiryDate),
                      ),
                      const _DividerRow(),
                      _DetailRow(label: 'Batch Number', value: m.batch ?? '—'),
                      const _DividerRow(),
                      _DetailRow(label: 'GTIN', value: m.gtin ?? '—'),
                      const _DividerRow(),
                      _DetailRow(label: 'Dosage Form', value: m.dosageForm ?? '—'),
                      const _DividerRow(),
                      _DetailRow(label: 'Strength', value: m.strength ?? '—'),
                      const _DividerRow(),
                      _DetailRow(label: 'Manufacturer', value: m.brand ?? '—'),
                      const _DividerRow(),
                      _DetailRowCost(label: 'Cost Status', value: m.costStatus ?? '—'),

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Ссылки на сертификаты/лицензии (если есть)
              if ((m.brandCertLink ?? m.brandLicenceLink) != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Column(
                      children: [
                        if (m.brandCertLink != null)
                          _LinkRow(label: 'Brand Certificate', url: m.brandCertLink!),
                        if (m.brandCertLink != null && m.brandLicenceLink != null)
                          const _DividerRow(),
                        if (m.brandLicenceLink != null)
                          _LinkRow(label: 'Brand Licence', url: m.brandLicenceLink!),
                      ],
                    ),
                  ),
                ),

              if (m.recommendations.isNotEmpty) ...[
                const SizedBox(height: 24),
                SimilarMedicinesSection(recommendations: m.recommendations),
              ],
            ],
          ),
        ),
      ),




    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(fontSize: 13, color: muted)),
          ),
          const SizedBox(width: 12),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
class _DetailRowCost extends StatelessWidget {
  final String label;
  final String? value; // можно передать m.costStatus или уже маппленный текст
  const _DetailRowCost({required this.label, this.value});

  Color _dotColor(String? v) {
    final s = (v ?? '').toLowerCase();
    switch (s) {
      case 'low':
      case 'affordable':
        return const Color(0xFF22C55E); // green
      case 'medium':
      case 'moderate':
        return const Color(0xFFF59E0B); // amber
      case 'high':
      case 'expensive':
        return const Color(0xFFEF4444); // red
      default:
        return Colors.grey;
    }
  }

  String _statusText(String? v) {
    final s = (v ?? '').toLowerCase();
    switch (s) {
      case 'low':
        return 'Affordable';
      case 'medium':
        return 'Moderate';
      case 'high':
        return 'Expensive';
      case 'affordable':
      case 'moderate':
      case 'expensive':
        return v![0].toUpperCase() + v.substring(1); // нормализуем регистр
      default:
        return '—';
    }
  }

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(fontSize: 13, color: muted)),
          ),
          const SizedBox(width: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _dotColor(value),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _statusText(value),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _DividerRow extends StatelessWidget {
  const _DividerRow();
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white.withOpacity(0.12)
          : Colors.black.withOpacity(0.06),
    );
  }
}

class _LinkRow extends StatelessWidget {
  final String label;
  final String url;
  const _LinkRow({required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      dense: true,
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(url, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.open_in_new, size: 18),
      onTap: () {
        // TODO: открыть ссылку (например, url_launcher)
      },
    );
  }
}
