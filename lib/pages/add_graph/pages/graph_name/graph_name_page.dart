import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class GraphNamePage extends StatelessWidget {
  const GraphNamePage({
    super.key,
    required this.value,
    required this.onChange,
  });

  final Function(String) onChange;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('addGraph.graphName'.tr()),
        TextFormField(
          initialValue: value,
          onChanged: onChange,
        ),
      ],
    );
  }
}
