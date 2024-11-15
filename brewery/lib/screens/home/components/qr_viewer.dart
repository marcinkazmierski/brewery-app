import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QRViewScreen extends StatefulWidget {
  const QRViewScreen({super.key});

  @override
  _QRViewScreenState createState() => _QRViewScreenState();
}

class _QRViewScreenState extends State<QRViewScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zeskanuj QR z etykiety'),
        backgroundColor: Colors.redAccent,
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.redAccent,
          borderRadius: 0,
          borderLength: 30,
          borderWidth: 8,
          cutOutSize: 280,
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      controller.dispose(); // Zamknij skaner po zeskanowaniu
      Navigator.pop(context, scanData.code); // Wróć z wynikiem
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
