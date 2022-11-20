import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:walewein/shared/components/constants.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    super.key,
    required this.image,
    required this.imageWidgetSize,
    required this.imageSize,
    required this.recognizedText,
    required this.onSelectText,
  });

  final Image image;
  final Size imageSize;
  final Size imageWidgetSize;
  final RecognizedText recognizedText;
  final Function(String) onSelectText;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.pink,
      ),
      child: _buildOverlay(context, size),
    );
  }

  Widget _buildOverlay(BuildContext context, Size size) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Image(
          image: image.image,
          fit: BoxFit.fitWidth,
        ),
        ..._texts(context, size),
      ],
    );
  }

  List<Widget> _texts(BuildContext context, Size size) {
    final texts = recognizedText.blocks
        .map((block) => _positioned(
            rect: block.boundingBox, child: _textButton(block.text)))
        .toList();

    return texts;
  }

  Widget _textButton(String text) {
    return MaterialButton(
      onPressed: () {
        onSelectText(text);
      },
      color: Colors.green.withOpacity(.4),
      shape: RoundedRectangleBorder(
        borderRadius: defaultButtonBorderRadius,
      ),
    );
  }

  Widget _positioned({required Rect rect, required Widget child}) {
    return Positioned(
      top: _map(rect.top, 0, imageSize.height, 0, imageWidgetSize.height) - 2,
      left: _map(rect.left, 0, imageSize.width, 0, imageWidgetSize.width) - 2,
      width: _map(rect.right - rect.left, 0, imageSize.width, 0,
              imageWidgetSize.width) +
          4,
      height: _getPositionedHeight(rect) + 4,
      child: child,
    );
  }

  double _getPositionedHeight(Rect rect) {
    var height = _map(
        rect.bottom - rect.top, 0, imageSize.width, 0, imageWidgetSize.width);

    if (height < 20) {
      height = 20;
    }

    return height;
  }

  double _map(double x, double a, double b, double c, double d) {
    return c + ((d - c) / (b - a)) * (x - a);
  }
}
