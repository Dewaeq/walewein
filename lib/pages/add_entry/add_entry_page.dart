import 'dart:io';
import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:walewein/shared/constants.dart';

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
  String? _selectedText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _bottomBarController.closeSheet();
        },
        child: CustomScrollView(
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
      ),
      bottomNavigationBar: BottomBarWithSheet(
        controller: _bottomBarController,
        duration: const Duration(milliseconds: 200),
        bottomBarTheme: BottomBarTheme(
          mainButtonPosition: MainButtonPosition.middle,
          heightOpened: MediaQuery.of(context).size.height * 0.3,
          decoration: const BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          itemIconColor: Colors.white,
          selectedItemIconColor: Colors.white,
          itemTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 10.0,
          ),
          selectedItemTextStyle: const TextStyle(
            color: Colors.blue,
            fontSize: 10.0,
          ),
        ),
        onSelectItem: (index) {
          if (index == 0) {
            _getImage(ImageSource.camera);
          } else {
            _getImage(ImageSource.gallery);
          }
        },
        sheetChild: Center(
          child: Text(
            _selectedText ?? "",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 33,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        items: const [
          BottomBarWithSheetItem(icon: Icons.camera_alt),
          BottomBarWithSheetItem(icon: Icons.image_search),
        ],
      ),
    );
  }

  Widget _galleryBody() {
    if (_image == null || _recognizedText == null) {
      return Container();
    }

    return Center(
      child: ImageContainer(
        image: Image.file(_image!),
        recognizedText: _recognizedText!,
        imageSize: _imageSize!,
        onSelectText: (text) {
          setState(() {
            _selectedText = text;
            _bottomBarController.openSheet();
          });
        },
      ),
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
