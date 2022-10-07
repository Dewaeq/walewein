import 'package:flutter/cupertino.dart';
import 'package:walewein/models/graph/graph_model.dart';
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
        const SizedBox(height: 15),
        const Text("With type:"),
        Text(GraphService.graphTypeToTitle(graphType)),
      ],
    );
  }
}
