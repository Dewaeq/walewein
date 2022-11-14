import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:walewein/shared/components/constants.dart';
import 'package:walewein/shared/components/simple_text_button.dart';
import 'package:walewein/shared/components/view_model_builder.dart';
import 'package:walewein/view_models/edit_entry_view_model.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/models/data/graph_node.dart';
import 'package:walewein/shared/constants.dart';

class EditEntryModal extends StatelessWidget {
  final GraphNode node;
  final Graph graph;

  const EditEntryModal({super.key, required this.node, required this.graph});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder(
      viewModel: EditEntryViewModel(node, graph, context),
      view: _view,
    );
  }

  Widget _view(EditEntryViewModel model) {
    if (!model.loaded) {
      return const CircularProgressIndicator();
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom:
            MediaQuery.of(model.context).viewInsets.bottom + kDefaultPadding,
        left: kDefaultPadding,
        right: kDefaultPadding,
        top: kDefaultPadding,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: model.controller,
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: model.onFieldSubmitted,
                    style: const TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  model.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            defaultHeightSizedBox,
            Text(
              DateFormat("EEEE d MMMM, yyyy").format(model.date!),
            ),
            TextButton(
              onPressed: model.selectDateWithPicker,
              child: const Text("Change date"),
            ),
            SimpleTextButton(
              onPressed: model.saveNode,
              color: kPrimaryColor,
              text: "Save",
            ),
            SimpleTextButton(
              onPressed: model.deleteNode,
              color: Colors.red,
              text: "Delete",
            ),
          ],
        ),
      ),
    );
  }
}
