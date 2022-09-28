import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:walewein/shared/components/widget_size.dart';

class ImageContainer extends StatefulWidget {
  const ImageContainer({
    super.key,
    required this.image,
    required this.recognizedText,
    required this.imageSize,
  });

  final Image image;
  final Size imageSize;
  final RecognizedText recognizedText;

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
        _showBottomSheet(context, text);
      },
      color: Colors.green.withOpacity(.4),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            5,
          ),
        ),
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

  void _showBottomSheet(BuildContext context, String text) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.green,
      barrierColor: theme.primaryColor.withOpacity(.1),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          color: theme.scaffoldBackgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            SizedBox(
              width: 30,
              child: MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.of(context).maybePop(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.close,
                  color: theme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
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
