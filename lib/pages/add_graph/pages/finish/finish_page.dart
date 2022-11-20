import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/shared/components/constants.dart';
import 'package:walewein/shared/utils.dart';

class FinishPage extends StatelessWidget {
  const FinishPage({
    super.key,
    required this.graphName,
    required this.graphType,
  });

  final String? graphName;
  final GraphType? graphType;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('addGraph.createGraph'.tr()),
        Text(graphName ?? ''),
        defaultHeightSizedBox,
        Text('addGraph.withType'.tr()),
        Text(graphTypeToString(graphType!)),
      ],
    );
  }
}
