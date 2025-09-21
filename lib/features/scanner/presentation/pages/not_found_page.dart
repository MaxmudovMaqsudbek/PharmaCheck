import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Result'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 220,
                  height: 160,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDECEC),       // светло-красный
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.gpp_bad_rounded,       // щит с крестом
                      size: 72, color: const Color(0xFFEF4444)),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Medicine Not Found',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This medicine was not found in our database. '
                      'It may be a counterfeit. Please contact your healthcare provider immediately.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Rescan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
