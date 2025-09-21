import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app.dart';
import 'features/scanner/data/mock_scan_repository.dart';
import 'features/scanner/data/recent_scans_storage.dart';
import 'features/scanner/data/scan_repository.dart';
import 'features/scanner/presentation/bloc/scan_bloc.dart';

void main() async{

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  widgetsBinding;
  await RecentScansStorage.instance.init();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // SystemChrome.setEnabledSystemUIMode(
  //   SystemUiMode.edgeToEdge,
  //   overlays: [SystemUiOverlay.top],
  // );

  const bool useMock = false; // переключатель
  final repo = useMock ? MockScanRepository() : ScanRepository();

  runApp(BlocProvider<ScanBloc>(
    create: (_) => ScanBloc(repo),
    child: const MediCheckApp(),
  ),
  );

}















