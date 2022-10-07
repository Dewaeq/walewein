import 'dart:io';
import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:walewein/models/graph/graph_node.dart';
import 'package:walewein/shared/services/graph_service.dart';
import 'package:walewein/shared/services/utils.dart';
import '../../models/graph/graph_model.dart';
import '../../models/graph/relation_model.dart';
import 'components/image_container.dart';

class AddEntryPage extends StatefulWidget {
  const AddEntryPage({super.key, required this.graph});

  final Graph graph;

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
  Relation? _selectedRelation;

  Map<Relation, String> values = {};
  Map<Relation, TextEditingController> controllers = {};

  @override
  void initState() {
    for (final relation in widget.graph.relations) {
      controllers[relation] = TextEditingController();
    }

    super.initState();
  }

  @override
  void dispose() {
    for (final relation in widget.graph.relations) {
      controllers[relation]?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff111111),
      floatingActionButton: FloatingActionButton(
        onPressed: _save,
        child: const Icon(Icons.done_rounded),
      ),
      body: GestureDetector(
        onTap: () {
          _bottomBarController.closeSheet();
        },
        child: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            SliverAppBar.large(
              title: const Text(
                "Add entry",
                style: TextStyle(color: Color(0xff43a345)),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Colors.white,
                icon: const Icon(Icons.arrow_back),
              ),
              backgroundColor: const Color(0xff111111),
            ),
            SliverToBoxAdapter(
              child: _galleryBody(),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: const Color(0xff111111),
        child: BottomBarWithSheet(
          controller: _bottomBarController,
          curve: Curves.fastOutSlowIn,
          mainActionButtonTheme: const MainActionButtonTheme(
            color: Color(0xff43a345),
          ),
          bottomBarTheme: BottomBarTheme(
            mainButtonPosition: MainButtonPosition.middle,
            heightOpened: MediaQuery.of(context).size.height * 0.3,
            decoration: const BoxDecoration(
              color: Color(0xff1e1e1e),
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
            _getImage(index == 0 ? ImageSource.camera : ImageSource.gallery);
          },
          sheetChild: _inputs(),
          items: const [
            BottomBarWithSheetItem(icon: Icons.camera_alt),
            BottomBarWithSheetItem(icon: Icons.image_search),
          ],
        ),
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
        onSelectText: _selectText,
      ),
    );
  }

  Widget _inputs() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (final relation in widget.graph.relations) ...[
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() => _selectedRelation = relation);
                    },
                    tooltip: "Read from image",
                    icon: const Icon(
                      Icons.image,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: controllers[relation],
                      textAlign: TextAlign.left,
                      onFieldSubmitted: (value) {
                        controllers[relation]?.text = value.parse();
                        setState(() => values[relation] = value.parse());
                      },
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 33,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    relation.yLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ],
          ],
        ),
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

  void _selectText(String text) async {
    text = text.parse();
    _bottomBarController.closeSheet();

    if (widget.graph.relations.length == 1) {
      values[widget.graph.relations.first] = text;
      controllers[widget.graph.relations.first]?.text = text;
    } else if (_selectedRelation != null) {
      values[_selectedRelation!] = text;
      controllers[_selectedRelation]?.text = text;
    }

    setState(() {});

    await Future.delayed(const Duration(milliseconds: 500));
    _bottomBarController.openSheet();
  }

  void _save() async {
    final now = DateTime.now();
    for (final entry in values.entries) {
      final relation = entry.key;
      final value = entry.value;
      final node = GraphNode.from(x: now, y: double.parse(value));

      await GraphService.addNode(widget.graph, relation, node);
    }

    Navigator.of(context).pop();
  }
}
