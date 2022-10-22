import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:walewein/shared/components/constants.dart';
import 'package:walewein/shared/components/widget_size.dart';

class ImageContainer extends StatefulWidget {
  const ImageContainer({
    super.key,
    required this.image,
    required this.recognizedText,
    required this.imageSize,
    required this.onSelectText,
  });

  final Image image;
  final Size imageSize;
  final RecognizedText recognizedText;
  final Function(String) onSelectText;

  @override
  State<ImageContainer> createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  Size? _imageWidgetSize;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.pink,
      ),
      child: _buildOverlay(size),
    );
  }

  Widget _buildOverlay(Size size) {
    return Stack(
      fit: StackFit.loose,
      children: [
        WidgetSize(
          child: Image(
            image: widget.image.image,
          ),
          onChange: (size) {
            setState(() {
              _imageWidgetSize = size;
            });
          },
        ),
        ..._texts(size),
      ],
    );
  }

  List<Widget> _texts(Size size) {
    if (_imageWidgetSize == null) return [];
    return [
      for (var i in widget.recognizedText.blocks)
        _positioned(
          rect: i.boundingBox,
          child: _textButton(i.text),
        ),
    ];
  }

  Widget _textButton(String text) {
    return MaterialButton(
      onPressed: () {
        widget.onSelectText(text);
      },
      color: Colors.green.withOpacity(.4),
      shape: RoundedRectangleBorder(
        borderRadius: defaultButtonBorderRadius,
      ),
    );
  }

  Widget _positioned({required Rect rect, required Widget child}) {
    return Positioned(
      top: _map(rect.top, 0, widget.imageSize.height, 0,
              _imageWidgetSize!.height) -
          2,
      left: _map(rect.left, 0, widget.imageSize.width, 0,
              _imageWidgetSize!.width) -
          2,
      width: _map(rect.right - rect.left, 0, widget.imageSize.width, 0,
              _imageWidgetSize!.width) +
          4,
      height: _getPositionedHeight(rect) + 4,
      child: child,
    );
  }

  double _getPositionedHeight(Rect rect) {
    var height = _map(rect.bottom - rect.top, 0, widget.imageSize.width, 0,
        _imageWidgetSize!.width);

    if (height < 20) {
      height = 20;
    }

    return height;
  }

  double _map(double x, double a, double b, double c, double d) {
    return c + ((d - c) / (b - a)) * (x - a);
  }
}
