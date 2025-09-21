import 'package:flutter/material.dart';

import '../core/widgets/glass_appBar.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/scanner/presentation/pages/scanner_page.dart';




class BottomBar extends StatefulWidget {
  const BottomBar({super.key});
  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final scannerKey = GlobalKey<ScannerPageState>();
  int tab = 0; // по умолчанию Home в центре

  Future<void> _switchTab(int i) async {
    final prev = tab;
    setState(() => tab = i);

    // если уходим со сканера — выключаем камеру
    if (prev == 1 && i != 1) {
      await scannerKey.currentState?.stop();
    }
    // если заходим на сканер — включаем
    if (i == 1) {
      await scannerKey.currentState?.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 10,
        surfaceTintColor: Colors.transparent,
      ),

      // appBar: const GlassAppBar(title: ''),
      // backgroundColor: Colors.white,
      body: IndexedStack(
        index: tab,
        children: [
          HomePage(),
          ScannerPage(key: scannerKey),
          ProfilePage()
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _switchTab(1), // центральная кнопка = Home
        child:  Icon(tab == 1 ? Icons.qr_code_scanner : Icons.qr_code_scanner_outlined),
      ),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              tooltip: 'Home',
              icon: Icon( tab == 0 ? Icons.home : Icons.home_outlined),
              onPressed: () => _switchTab(0),
            ),
            const SizedBox(width: 48), // место под FAB
            IconButton(
              tooltip: 'Profile',
              icon: Icon(tab == 2 ? Icons.person : Icons.person_outline),
              onPressed: () => _switchTab(2),
            ),
          ],
        ),
      ),
    );
  }
}