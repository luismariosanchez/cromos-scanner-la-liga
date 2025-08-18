import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:cromos_scanner_laliga/app/entities/sticker.dart';
import 'package:cromos_scanner_laliga/app/enums/status_sticker.dart';
import 'package:cromos_scanner_laliga/app/widgets/sticker_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  List<CameraDescription>? cameras;
  CameraController? _controller;
  late TextRecognizer _textRecognizer;
  late ObjectDetector _objectDetector;
  bool _isProcessing = false;
  bool _isInitialized = false;
  bool _isScanning = true; // Nuevo: estado del escaneo
  String recognizedText = '';
  List<DetectedObject> _detectedObjects = [];
  List<String> _rectangleTexts = [];

  List<Sticker>? stickersScanned;

  @override
  void initState() {
    super.initState();
    _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    // Configurar el detector de objetos para detectar rectángulos/objetos
    final options = ObjectDetectorOptions(
      mode: DetectionMode.stream,
      classifyObjects: false,
      multipleObjects: true,
    );
    _objectDetector = ObjectDetector(options: options);

    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();

      if (cameras == null || cameras!.isEmpty) {
        return;
      }

      _controller = CameraController(
        cameras!.first,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      await _controller!.initialize();

      await _controller!.startImageStream((image) {
        if (!_isProcessing && _isScanning) { // Solo procesar si está escaneando
          _isProcessing = true;
          _processCameraImage(image);
        }
      });

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  // Método para pausar el escaneo
  void _pauseScanning() {
    setState(() {
      _isScanning = false;
    });
    print('Escaneo pausado');
  }

  // Método para reanudar el escaneo
  void _resumeScanning() {
    setState(() {
      _isScanning = true;
    });
    print('Escaneo reanudado');
  }

  // Método para alternar entre pausar y reanudar
  void _toggleScanning() {
    if (_isScanning) {
      _pauseScanning();
    } else {
      _resumeScanning();
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    try {
      // Verificar si aún está escaneando antes de procesar
      if (!_isScanning) {
        _isProcessing = false;
        return;
      }

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

      // Primero detectar objetos/rectángulos
      final detectedObjects = await _objectDetector.processImage(inputImage);

      // Luego procesar el texto completo
      final textResult = await _textRecognizer.processImage(inputImage);

      // Procesar texto en cada rectángulo detectado
      List<String> rectangleTexts = [];

      if (detectedObjects.isNotEmpty) {
        for (var detectedObject in detectedObjects) {
          // Obtener el texto que está dentro del rectángulo
          String rectangleText = _getTextInRectangle(
            textResult,
            detectedObject.boundingBox,
          );

          if (rectangleText.isNotEmpty) {
            rectangleTexts.add(rectangleText);
          }
        }
      }

      if (mounted) {
        setState(() {
          recognizedText = textResult.text;
          _detectedObjects = detectedObjects;
          _rectangleTexts = rectangleTexts;
        });

        // Procesar cada rectángulo detectado
        _processDetectedRectangles(rectangleTexts);
      }
    } catch (e) {
      print('Error processing image: $e');
    } finally {
      _isProcessing = false;
    }
  }

  String _getTextInRectangle(RecognizedText recognizedText, Rect rectangle) {
    StringBuffer textInRectangle = StringBuffer();

    for (var textBlock in recognizedText.blocks) {
      // Verificar si el bloque de texto está dentro del rectángulo
      if (_isRectangleOverlapping(textBlock.boundingBox, rectangle)) {
        for (var line in textBlock.lines) {
          if (_isRectangleOverlapping(line.boundingBox, rectangle)) {
            for (var element in line.elements) {
              if (_isRectangleOverlapping(element.boundingBox, rectangle)) {
                textInRectangle.write('${element.text} ');
              }
            }
            textInRectangle.writeln();
          }
        }
      }
    }

    return textInRectangle.toString().trim();
  }

  bool _isRectangleOverlapping(Rect textBoundingBox, Rect objectBoundingBox) {
    // Verificar si hay solapamiento entre los rectángulos
    return !(textBoundingBox.right < objectBoundingBox.left ||
        textBoundingBox.left > objectBoundingBox.right ||
        textBoundingBox.bottom < objectBoundingBox.top ||
        textBoundingBox.top > objectBoundingBox.bottom);
  }

  void _processDetectedRectangles(List<String> rectangleTexts) {
    // Aquí puedes procesar cada texto de rectángulo por separado
    for (int i = 0; i < rectangleTexts.length; i++) {
      String text = rectangleTexts[i];
      print('Rectángulo ${i + 1}: $text');

      // Aquí puedes agregar tu lógica para procesar cada rectángulo
      // Por ejemplo, buscar patrones específicos, números de cartas, etc.
      _analyzeRectangleText(text, i);
    }
  }

  void _analyzeRectangleText(String text, int rectangleIndex) {
    // Ejemplo de análisis del texto de cada rectángulo
    // Puedes buscar patrones específicos aquí

    // Buscar nombres de jugadores
    RegExp namePattern = RegExp(r'[A-Za-z]+\s+[A-Za-z]+');
    var names = namePattern.allMatches(text);

    print('Rectángulo $rectangleIndex:');
    print('  Texto: $text');
    print('  Nombres encontrados: ${names.map((m) => m.group(0)).toList()}');
    print('length of names: ${names.length}');
    print('-------------------------------------------------------');

    // Aquí puedes crear nuevos Sticker objects basados en lo que encuentres
    // y agregarlos a stickersScanned


  }

  @override
  void dispose() {
    _controller?.dispose();
    _textRecognizer.close();
    _objectDetector.close();
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
          SizedBox.expand(
            child: Stack(
              children: [
                SizedBox.expand(child: CameraPreview(_controller!)),
                // Overlay para mostrar los rectángulos detectados
                CustomPaint(
                  painter: ObjectDetectionPainter(_detectedObjects),
                  child: Container(),
                ),
                // Overlay cuando está pausado
                if (!_isScanning)
                  Container(
                    color: Colors.black26,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.pause_circle_outline,
                              color: Colors.white,
                              size: 48,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Escaneo Pausado',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 10),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color(0x80000000),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 24),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color(0x80000000),
                  ),
                  child: Text(
                    'Scanner Stickers',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Botones de control de escaneo
          Positioned(
            top: 30,
            right: 10,
            child: Row(
              children: [
                // Botón para pausar/reanudar
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: _isScanning ? Color(0x80FF5722) : Color(0x804CAF50),
                  ),
                  child: IconButton(
                    onPressed: _toggleScanning,
                    icon: Icon(
                      _isScanning ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                // Indicador de estado
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: _isScanning ? Color(0x804CAF50) : Color(0x80FF5722),
                  ),
                  child: Text(
                    _isScanning ? 'Escaneando' : 'Pausado',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Debug info
          Positioned(
            top: 100,
            left: 10,
            right: 10,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Rectángulos detectados: ${_detectedObjects.length}',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: _isScanning ? Colors.green : Colors.red,
                        ),
                        child: Text(
                          _isScanning ? 'ACTIVO' : 'PAUSADO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_rectangleTexts.isNotEmpty)
                    ..._rectangleTexts
                        .asMap()
                        .entries
                        .map(
                          (entry) => Text(
                        'R${entry.key + 1}: ${entry.value}',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Botones flotantes en la parte inferior (alternativa)
          // Bottom sheet con stickers
          if (stickersScanned != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.35,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF212121),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          height: 4,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            children: stickersScanned!.map((sticker) {
                              return StickerCardWidget(sticker: sticker);
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAmount(Sticker sticker) {
    if (sticker.status == StatusSticker.missing) {
      return Container(
        decoration: BoxDecoration(
          color: Color(0xFF303030),
          borderRadius: BorderRadius.circular(100),
        ),
        child: IconButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Center(child: CircularProgressIndicator());
              },
            );
            setState(() {});
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.add, size: 32),
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF303030),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Center(child: CircularProgressIndicator());
                },
              );
              setState(() {});
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.remove, size: 32),
          ),
        ),
        const SizedBox(width: 15),
        Text(
          '${sticker.amount}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 15),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF303030),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Center(child: CircularProgressIndicator());
                },
              );
              setState(() {});
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.add, size: 32),
          ),
        ),
      ],
    );
  }
}

// Painter personalizado para dibujar los rectángulos detectados
class ObjectDetectionPainter extends CustomPainter {
  final List<DetectedObject> objects;

  ObjectDetectionPainter(this.objects);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    for (var detectedObject in objects) {
      canvas.drawRect(detectedObject.boundingBox, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}