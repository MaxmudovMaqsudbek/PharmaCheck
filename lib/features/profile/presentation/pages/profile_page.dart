import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final muted = isDark ? Colors.white70 : Colors.black54;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        child: Column(
          children: [
            // Avatar + verified badge
            SizedBox(
              height: 148,
              width: 148,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: Image.network(
                        'http://sotuvchiai.uz/media/products/logo_wto_back.png',
                        // Иллюстрация-плейсхолдер
                        height: 132,
                        width: 132,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 12,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E), // зеленый
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            const Text(
              'Mizan Dynamics',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              'Joined in 2025',
              style: TextStyle(color: muted),
            ),

            const SizedBox(height: 28),

            // Section title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Account',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800, color: muted),
              ),
            ),
            const SizedBox(height: 12),

            // Grouped settings card
            Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  _SettingTile(
                    title: 'Personal Information',
                    onTap: () {
                      // TODO: Navigator.push(...)
                    },
                  ),
                  const _DividerRow(),
                  _SettingTile(
                    title: 'Notifications',
                    onTap: () {
                      // TODO: Navigator.push(...)
                    },
                  ),
                  const _DividerRow(),
                  _SettingTile(
                    title: 'Security',
                    onTap: () {
                      // TODO: Navigator.push(...)
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const _SettingTile({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
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
          ? Colors.white.withOpacity(0.08)
          : Colors.black.withOpacity(0.06),
    );
  }
}
