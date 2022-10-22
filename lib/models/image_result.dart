import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ImageResult {
  final Size imageSize;
  final RecognizedText recognizedText;
  final File image;

  ImageResult(this.imageSize, this.recognizedText, this.image);
}
