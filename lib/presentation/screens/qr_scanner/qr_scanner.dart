import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:terminal_project/presentation/cubit/settings/settings_cubit.dart';

class QrScanner extends StatefulWidget {
  final void Function(String value) onScan;

  const QrScanner({super.key, required this.onScan});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: false,
  );

  bool _isScanned = false;

  _initPermission() async {
    final settingsCubit = context.read<SettingsCubit>();
    await settingsCubit.requestCameraPermission();
  }

  @override
  void initState() {
    _initPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (_isScanned) return;

              final barcode = capture.barcodes.first.rawValue;

              if (barcode != null && barcode.isNotEmpty) {
                _isScanned = true;

                widget.onScan(barcode);

                Navigator.pop(context);
              }
            },
          ),

          // overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
