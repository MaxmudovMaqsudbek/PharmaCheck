import 'package:flutter/material.dart';
import '../../data/recent_scans_storage.dart';
import '../../data/recent_scan_item.dart';
import 'all_scan_tile.dart';

void showRecentScansBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              const SizedBox(height: 8),
              // drag handle
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white24
                      : Colors.black12,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    // IconButton(
                    //   icon: const Icon(Icons.close),
                    //   onPressed: () => Navigator.pop(context),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 4),

              Expanded(
                child: ValueListenableBuilder<List<RecentScanItem>>(
                  valueListenable: RecentScansStorage.instance.items,
                  builder: (context, list, _) {
                    if (list.isEmpty) {
                      // пустой контейнер
                      return const SizedBox.shrink();
                    }

                    return ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return AllScanTile(item: item);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
