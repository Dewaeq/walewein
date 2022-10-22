import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:walewein/models/image_result.dart';

class ImageProcessor {
  final textRecognizer = TextRecognizer();

  Future<ImageResult> processImage(XFile pickedFile) async {
    final path = pickedFile.path;
    final image = File(path);
    final inputImage = InputImage.fromFile(image);

    final decodedImage = await decodeImageFromList(image.readAsBytesSync());
    final imageSize =
        Size(decodedImage.width.toDouble(), decodedImage.height.toDouble());

    final recognizedText = await readImage(inputImage);

    return ImageResult(imageSize, recognizedText, image);
  }

  Future<RecognizedText> readImage(InputImage inputImage) async {
    final recognizedText = await textRecognizer.processImage(inputImage);

    return recognizedText;
  }
}
