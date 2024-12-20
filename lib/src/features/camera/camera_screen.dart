import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../shared/domain/models/card_model.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  late List<CameraDescription> cameras;

  CardModel? cardModel;
  bool _isProcessing = false;

  Future<void> requestPermissions() async {
    if (await Permission.camera.isDenied) {
      await Permission.camera.request();
    }
  }

  Future<void> setupCamera() async {
    try {
      await requestPermissions();
      cameras = await availableCameras();

      if (cameras.isEmpty) {
        throw Exception("Kamera topilmadi.");
      }

      _controller = CameraController(
        cameras[0],
        ResolutionPreset.high, 
        imageFormatGroup: ImageFormatGroup.yuv420, 
      );

      await _controller!.initialize();

      if (_controller!.value.isInitialized) {
        _controller!.setFlashMode(FlashMode.off); 
      }

      _controller!.startImageStream(_processCameraImage);

      setState(() {});
    } catch (e) {
      print("Kamera sozlashda xato: $e");
    }
  }

  void _processCameraImage(CameraImage image) async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();
      final size = Size(image.width.toDouble(), image.height.toDouble());

      final inputImageFormat = InputImageFormatValue.fromRawValue(image.format.raw);
      if (inputImageFormat == null) {
        print("Xato: InputImageFormat noto'g'ri.");
        _isProcessing = false;
        return;
      }

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: size,
          bytesPerRow: image.planes[0].bytesPerRow,
          format: InputImageFormat.nv21,
          rotation: InputImageRotation.rotation90deg,
        ),
      );

      final textRecognizer = TextRecognizer();
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      String result = '';
      for (TextBlock block in recognizedText.blocks) {
        result += block.text;
      }
      extractNumbersAndDates(result);
    } catch (e) {
      print("ML Kit xatosi: $e");
      setState(() {});
    } finally {
      _isProcessing = false;
    }
  }

  @override
  void initState() {
    super.initState();
    setupCamera();
  }

  @override
  void dispose() {
    _controller?.stopImageStream();
    _controller?.dispose();
    super.dispose();
  }

  void extractNumbersAndDates(String text) {
    RegExp numberRegex = RegExp(r'\d{4} \d{4} \d{4} \d{4}');
    RegExp dateRegex = RegExp(r'\d{2}/\d{2}');

    Iterable<RegExpMatch> numberMatches = numberRegex.allMatches(text);
    Iterable<RegExpMatch> dateMatches = dateRegex.allMatches(text);

    String cardNumber = '';
    String cardDate = '';
    for (var match in numberMatches) {
      cardNumber += "${match.group(0)}\n";
    }
    for (var match in dateMatches) {
      cardDate += "${match.group(0)}";
    }

    if (cardDate.isNotEmpty && cardNumber.isNotEmpty) {
      cardModel = CardModel(cardExpiry: cardDate, cardNumber: cardNumber);
    } else {
      cardModel = null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: _controller != null && _controller!.value.isInitialized
          ? Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: 1 / _controller!.value.aspectRatio,
                    child: CameraPreview(_controller!),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: size.width * 0.85,
                        height: size.height * 0.3,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 5),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                cardModel != null ? cardModel!.fitchString : 'Kartangizni ramka ichiga olib keling',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (cardModel != null) ...[
                        const SizedBox(height: 20),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            fixedSize: Size(size.width * 0.7, 55),
                            backgroundColor: Colors.blue,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                          onPressed: () {
                            context.pop(cardModel);
                          },
                          child: const Text("Kartani qo'shish"),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
