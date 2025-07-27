import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  String? _barcodeValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leitor de Código de Barras'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: MobileScanner(
              // fit: BoxFit.contain, // Descomente se quiser ajustar o aspect ratio
              controller: cameraController,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                // final Uint8List? image = capture.image; // Se precisar da imagem
                if (barcodes.isNotEmpty) {
                  final barcode = barcodes.first;
                  if (barcode.rawValue != null) {
                    setState(() {
                      _barcodeValue = barcode.rawValue;
                    });
                    // Você pode navegar para outra tela, mostrar um diálogo, etc.
                    _showBarcodeDialog(barcode.rawValue!);
                    // Para evitar múltiplos scans rápidos, você pode parar o scanner:
                    // cameraController.stop();
                    // Ou usar uma flag para processar apenas uma vez
                  }
                  debugPrint('Barcode found! ${barcode.rawValue}');
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (_barcodeValue != null)
                  ? Text('Código lido: $_barcodeValue')
                  : const Text('Aponte a câmera para um código de barras'),
            ),
          ),
        ],
      ),
    );
  }

  void _showBarcodeDialog(String value) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Código de Barras Detectado"),
          content: Text("Valor: $value"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                // Se você parou o scanner, reinicie-o aqui se necessário:
                // if (!cameraController.isStarting) {
                // cameraController.start();
                // }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
