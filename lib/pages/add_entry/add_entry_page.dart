import 'dart:math';

import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:walewein/pages/add_entry/components/relation_input_field.dart';
import 'package:walewein/shared/components/constants.dart';
import 'package:walewein/shared/components/help_button.dart';
import 'package:walewein/shared/components/view_model_builder.dart';
import 'package:walewein/shared/constants.dart';
import 'package:walewein/view_models/add_entry_view_model.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/pages/add_entry/components/image_container.dart';

class AddEntryPage extends StatelessWidget {
  const AddEntryPage({super.key, required this.graph});

  final Graph graph;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder(
      viewModel: AddEntryViewModel(graph, context),
      view: _view,
    );
  }

  Widget _view(AddEntryViewModel model) {
    return Theme(
      data: Theme.of(model.context).copyWith(
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color(0xff111111),
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xff111111),
        floatingActionButton: FloatingActionButton(
          onPressed: model.save,
          backgroundColor: kPrimaryColor,
          child: const Icon(Icons.done_rounded),
        ),
        body: GestureDetector(
          onTap: model.closeSheet,
          child: CustomScrollView(
            slivers: [
              _buildAppBar(model),
              SliverToBoxAdapter(
                child: _galleryBody(model),
              ),
            ],
          ),
        ),
        bottomSheet: _buildBottomSheet(model),
      ),
    );
  }

  SliverAppBar _buildAppBar(AddEntryViewModel model) {
    return SliverAppBar.large(
      title: Text(
        'general.addEntry'.tr(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 36,
        ),
      ),
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () => Navigator.of(model.context).pop(),
        color: Colors.white,
        icon: const Icon(Icons.arrow_back),
      ),
      actions: [
        HelpButton(
          content: 'addEntry.helpText'.tr(),
          iconColor: Colors.white,
        ),
      ],
      backgroundColor: const Color(0xff111111),
    );
  }

  Widget _buildBottomSheet(AddEntryViewModel model) {
    return BottomBarWithSheet(
      controller: model.bottomBarController,
      curve: Curves.fastOutSlowIn,
      mainActionButtonTheme: const MainActionButtonTheme(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 20),
        size: 65,
        icon: Icon(
          Icons.graphic_eq,
          size: 32,
          color: Colors.black,
        ),
      ),
      bottomBarTheme: BottomBarTheme(
        mainButtonPosition: MainButtonPosition.middle,
        heightOpened: min(model.size.height * 0.25, 215) +
            model.graph.relations.length * 60,
        heightClosed: 110,
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
      onSelectItem: model.getImage,
      sheetChild: _inputs(model),
      items: const [
        BottomBarWithSheetItem(icon: Icons.camera_alt),
        BottomBarWithSheetItem(icon: Icons.image_search),
      ],
    );
  }

  Widget _galleryBody(AddEntryViewModel model) {
    if (!model.didReadImage()) {
      return Container();
    }

    final width = MediaQuery.of(model.context).size.width;

    final k = model.imageResult!.imageSize.width / width;
    final height = model.imageResult!.imageSize.height / k;

    final imageWidgetSize = Size(width, height);

    return ImageContainer(
      image: Image.file(model.imageResult!.image),
      imageWidgetSize: imageWidgetSize,
      imageSize: model.imageResult!.imageSize,
      recognizedText: model.imageResult!.recognizedText,
      onSelectText: model.selectText,
    );
  }

  Widget _inputs(AddEntryViewModel model) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (final relation in graph.relations)
              RelationInputField(
                relation: relation,
                onSelectRelation: model.selectRelation,
                onFieldSubmitted: model.onFieldSubmitted,
                controller: model.controllers[relation]!,
              ),
            defaultHeightSizedBox,
            Text(
              DateFormat('EEEE d MMMM, yyyy').format(model.date),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: model.selectDateWithPicker,
              child: Text('general.editDate'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
