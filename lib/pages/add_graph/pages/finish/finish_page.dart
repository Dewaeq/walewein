import 'package:flutter/cupertino.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/shared/components/constants.dart';
import 'package:walewein/shared/services/graph_service.dart';

class FinishPage extends StatelessWidget {
  const FinishPage(
      {super.key, required this.graphName, required this.graphType});

  final String? graphName;
  final GraphType? graphType;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Create graph:"),
        Text(graphName ?? ""),
        defaultHeightSizedBox,
        const Text("With type:"),
        Text(GraphService.graphTypeToTitle(graphType)),
      ],
    );
  }
}
