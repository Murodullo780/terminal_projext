import 'package:flutter/services.dart';

class ScanService {
  static const _platform = MethodChannel('scanner_channel');

  static void init() {
    _platform.setMethodCallHandler((call) async {
      if (call.method == "onScan") {
        String barcode = call.arguments;
        print("SCAN: $barcode");
      }
    });
  }
}
