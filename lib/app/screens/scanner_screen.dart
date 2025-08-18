import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  List<CameraDescription>? cameras; // Hacerlo nullable
  CameraController? _controller; // Hacerlo nullable
  late TextRecognizer _textRecognizer;
  bool _isProcessing = false;
  bool _isInitialized = false; // Agregar estado de inicialización
  String recognizedText = '';

  @override
  void initState() {
    super.initState();
    _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      // Primero obtener las cámaras
      cameras = await availableCameras();

      if (cameras == null || cameras!.isEmpty) {
        return;
      }

      // Luego inicializar el controlador
      _controller = CameraController(
        cameras!.first,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      await _controller!.initialize();

      // Iniciar el stream de imágenes
      await _controller!.startImageStream((image) {
        if (!_isProcessing) {
          _isProcessing = true;
          _processCameraImage(image);
        }
      });

      // Actualizar el estado
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {}
  }

  Future<void> _processCameraImage(CameraImage image) async {
    try {
      final format = InputImageFormatValue.fromRawValue(image.format.raw);
      if (format == null ||
          (Platform.isAndroid && format != InputImageFormat.nv21) ||
          (Platform.isIOS && format != InputImageFormat.bgra8888)) {
        return;
      }

      final inputImage = InputImage.fromBytes(
        bytes: image.planes.first.bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: InputImageRotation.rotation90deg,
          format: format,
          bytesPerRow: image.planes.first.bytesPerRow,
        ),
      );

      final result = await _textRecognizer.processImage(inputImage);

      if (mounted) {
        setState(() {
          recognizedText = result.text;
        });
      }
    } catch (e) {
    } finally {
      _isProcessing = false;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized ||
        _controller == null ||
        !_controller!.value.isInitialized) {
      return const Scaffold(
        appBar: null,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Inicializando cámara...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(child: CameraPreview(_controller!)),
          Padding(
            padding: const  EdgeInsets.only(top: 30, left: 10),
            child:Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color(0x80000000)
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.white,size: 24,),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color(0x80000000)
                  ),
                  child: Text('Scanner Stickers', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Column(
                    children: [

                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
