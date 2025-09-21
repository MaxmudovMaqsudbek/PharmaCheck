import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pharma_check/features/scanner/presentation/pages/verification_result_page.dart';

import '../bloc/scan_bloc.dart';
import 'not_found_page.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => ScannerPageState();
}

class ScannerPageState extends State<ScannerPage> {
  final MobileScannerController _controller = MobileScannerController(
    facing: CameraFacing.back,
    torchEnabled: false,
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.normal,
    returnImage: false,
  );

  Future<void> start() => _controller.start();
  Future<void> stop() => _controller.stop();

  bool _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // void _onDetect(BarcodeCapture cap) async {
  //   for (final b in cap.barcodes) {
  //     final raw = b.rawValue;
  //     if (raw == null || raw.isEmpty) continue;
  //     await _controller.stop(); // стоп перед переходом
  //     if (!mounted) return;
  //     // Navigator.push(...); // переход на результат
  //     await _controller.start(); // при возврате — старт
  //     break;
  //   }
  // }
  void _onDetect(BarcodeCapture cap) async {
    if (_handled) return;

    for (final b in cap.barcodes) {
      final raw = b.rawValue?.trim();
      if (raw == null || raw.isEmpty) continue;

      _handled = true;
      await _controller.stop();                       // 1) стопаем камеру
      if (!mounted) return;

      context.read<ScanBloc>().add(ScanRequested(raw)); // 2) диспатчим событие
      break;
    }
  }


  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(

        child: BlocListener<ScanBloc, ScanState>(
          listener: (context, state) async {
            if (state.loading) return;
            if (state.isNotFound) {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotFoundPage()),
              );
            }

            // 3b) ошибка — покажем и перезапустим сканер
            if (state.error != null) {
              // ScaffoldMessenger.of(context)
              //     .showSnackBar(SnackBar(content: Text(state.error!)));
              _handled = false;
              await _controller.start();              // возврат к сканированию
              return;
            }

            // 3c) успех — переходим на экран результата
            if (state.data != null) {
              final medicine = state.data!;
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VerificationResultPage(medicine: medicine),
                ),
              );

              // после возврата — сбросить BLoC и камеру
              if (!mounted) return;
              context.read<ScanBloc>().add(const ScanReset());
              _handled = false;
              await _controller.start();
            }
          },
          child: Stack(
            children: [
              // Камера + распознавание
              MobileScanner(
                controller: _controller,
                onDetect: _onDetect,
              ),
          
              // Верхняя панель: назад, фонарик, смена камеры
              Positioned(
                top: 8,
                left: 8,
                right: 8,
                child: Row(
                  children: [

                    const Spacer(),
                    // torch
                    ValueListenableBuilder<TorchState>(
                      valueListenable: _controller.torchState,
                      builder: (_, state, __) {
                        final on = state == TorchState.on;
                        return _CircleBtn(
                          icon: on ? Icons.flash_on : Icons.flash_off,
                          onTap: _controller.toggleTorch,
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    // switch camera
                    _CircleBtn(
                      icon: Icons.cameraswitch_outlined,
                      onTap: _controller.switchCamera,
                    ),
                  ],
                ),
              ),
          
              // Центровой оверлей зоны сканирования (рамка)
              Center(
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.9), width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.35),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
          
              // Подсказка
              Positioned(
                bottom: 28,
                left: 16,
                right: 16,
                child: Text(
                  'Align the QR code within the frame to scan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.15),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}
