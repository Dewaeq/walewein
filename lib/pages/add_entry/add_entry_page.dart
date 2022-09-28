import 'dart:io';
import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import 'components/image_container.dart';

class AddEntryPage extends StatefulWidget {
  const AddEntryPage({super.key});

  @override
  State<AddEntryPage> createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  final TextRecognizer _textRecognizer = TextRecognizer();
  final ImagePicker _imagePicker = ImagePicker();
  final _bottomBarController = BottomBarWithSheetController(initialIndex: 0);

  RecognizedText? _recognizedText;
  Size? _imageSize;
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          SliverAppBar.large(
            title: const Text("Add entry"),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: _galleryBody(),
          ),
        ],
      ),
      bottomNavigationBar: BottomBarWithSheet(
        controller: _bottomBarController,
        bottomBarTheme: const BottomBarTheme(
          mainButtonPosition: MainButtonPosition.middle,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          itemIconColor: Colors.grey,
          itemTextStyle: TextStyle(
            color: Colors.grey,
            fontSize: 10.0,
          ),
          selectedItemTextStyle: TextStyle(
            color: Colors.blue,
            fontSize: 10.0,
          ),
        ),
        onSelectItem: (index) {
          _bottomBarController.toggleSheet();
          debugPrint('$index');
        },
        sheetChild: Center(
          child: Text(
            "Another content",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        items: const [
          BottomBarWithSheetItem(icon: Icons.people),
          BottomBarWithSheetItem(icon: Icons.shopping_cart),
          BottomBarWithSheetItem(icon: Icons.settings),
          BottomBarWithSheetItem(icon: Icons.favorite),
        ],
      ),
    );
  }

  Widget _galleryBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_image != null && _recognizedText != null)
          ImageContainer(
            image: Image.file(_image!),
            recognizedText: _recognizedText!,
            imageSize: _imageSize!,
          )
        else
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ElevatedButton(
                    child: const Text('From Gallery'),
                    onPressed: () => _getImage(ImageSource.gallery),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ElevatedButton(
                    child: const Text('Take a picture'),
                    onPressed: () => _getImage(ImageSource.camera),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
      ],
    );
  }

  void _getImage(ImageSource source) async {
    final pickedFile = await _imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      _processPickedfile(pickedFile);
    }
  }

  void _processPickedfile(XFile pickedFile) async {
    final path = pickedFile.path;

    setState(() {
      _image = File(path);
    });

    var inputImage = InputImage.fromFilePath(path);
    final img = Image.file(_image!);

    img.image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      final size =
          Size(info.image.width.toDouble(), info.image.height.toDouble());
      _imageSize = size;
      _processImage(inputImage);
    }));
  }

  void _processImage(InputImage image) async {
    final recognizedText = await _textRecognizer.processImage(image);

    setState(() {
      _recognizedText = recognizedText;
    });
  }
}
