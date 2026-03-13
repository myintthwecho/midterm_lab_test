import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrService {
  Future<String?> scanQrCode(BuildContext context) {
    return Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const _QrScannerScreen()),
    );
  }
}

class _QrScannerScreen extends StatefulWidget {
  const _QrScannerScreen();

  @override
  State<_QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<_QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _hasScanned = false;

  void _handleDetection(BarcodeCapture capture) {
    if (_hasScanned || capture.barcodes.isEmpty) {
      return;
    }

    final token = capture.barcodes.first.rawValue;
    if (token == null || token.isEmpty) {
      return;
    }

    _hasScanned = true;
    Navigator.of(context).pop(token);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: _handleDetection,
      ),
    );
  }
}
