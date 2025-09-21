import 'dart:ui';
import 'package:flutter/material.dart';

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final double blurSigma;

  const GlassAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.blurSigma = 18,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? Colors.black : Colors.white;

    return AppBar(
      leading: leading,
      title: Text(title),
      actions: actions,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            // Градиент: сверху плотнее, к низу в ноль — мягкое «растворение»
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  base.withOpacity(0.14),

                  base.withOpacity(0.32),
                  base.withOpacity(0.55),
                  Colors.transparent,
                ],
                stops: const [1.0, 0.8, 0.45, 0.0,  ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
