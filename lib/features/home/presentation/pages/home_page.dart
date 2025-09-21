import 'package:flutter/material.dart';

import '../../../scanner/data/recent_scan_item.dart';
import '../../../scanner/data/recent_scans_storage.dart';
import '../../../scanner/presentation/widgets/recent_scans_bottom_sheet.dart';
import '../widgets/action_button.dart';
import '../widgets/recent_scan_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          // Quick Actions
          // Text(
          //   'Quick Actions',
          //   style: Theme.of(context)
          //       .textTheme
          //       .titleLarge
          //       ?.copyWith(fontWeight: FontWeight.w800),
          // ),
          // const SizedBox(height: 12),
          // Row(
          //   children: [
          //     Expanded(
          //       child: ActionButton(
          //         title: 'Scan Medicine',
          //         icon: Icons.qr_code_scanner,
          //         filled: true,
          //         onTap: () {},
          //       ),
          //     ),
          //     const SizedBox(width: 12),
          //     Expanded(
          //       child: ActionButton(
          //         title: 'View History',
          //         icon: Icons.history,
          //         filled: false,
          //         onTap: () {},
          //       ),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 24),

          // Recent Scans
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       'Recent Scans',
          //       style: Theme.of(context)
          //           .textTheme
          //           .titleLarge
          //           ?.copyWith(fontWeight: FontWeight.w800),
          //     ),
          //     Text(
          //       'More',
          //       style: Theme.of(context)
          //           .textTheme
          //           .titleSmall
          //           ?.copyWith(fontWeight: FontWeight.w500),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 12),
          // Column(
          //   children: const [
          //     RecentScanTile(
          //       name: 'Aspirin 500mg',
          //       batch: '123456789',
          //       imageUrl:
          //         'http://sotuvchiai.uz/media/products/71sFt1-svKL._UF10001000_QL80_.jpg'
          //     ),
          //     SizedBox(height: 5),
          //     RecentScanTile(
          //       name: 'Paracetamol 250mg',
          //       batch: '987654321',
          //       imageUrl:
          //         'http://sotuvchiai.uz/media/products/Paratsetamol-20t.png'
          //     ),
          //   ],
          // ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Scans',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              GestureDetector(
                onTap: () => showRecentScansBottomSheet(context),
                child: Text(
                  'More',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ValueListenableBuilder<List<RecentScanItem>>(
            valueListenable: RecentScansStorage.instance.items,
            builder: (context, list, _) {
              if (list.isEmpty) {
                // пусто — ничего не показываем
                return const SizedBox.shrink();
              }

              final recent = list.take(2).toList(); // последние 2

              return Column(
                children: List.generate(recent.length, (i) {
                  final r = recent[i];
                  return Padding(
                    padding: EdgeInsets.only(bottom: i == recent.length - 1 ? 0 : 5),
                    child: RecentScanTile(
                      name: r.name,
                      batch: r.batch ?? '—',
                      imageUrl: (r.imageUrl?.isNotEmpty ?? false)
                          ? r.imageUrl!
                          : 'https://picsum.photos/seed/${r.uuid}/200',
                    ),
                  );
                }),
              );
            },
          ),
          const SizedBox(height: 24),

          // Health News & Tips
          Text(
            'Health News & Tips',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // image banner
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    'http://sotuvchiai.uz/media/products/0379_638648588226268942.avif',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Health Tip',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.w600,
                          )),
                      const SizedBox(height: 6),
                      Text(
                        'Stay Hydrated: The Importance of Water',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Drinking enough water is crucial for maintaining overall health and well-being.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? Colors.white70
                              : Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}