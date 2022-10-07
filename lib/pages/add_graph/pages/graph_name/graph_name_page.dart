import 'package:flutter/material.dart';

class GraphNamePage extends StatelessWidget {
  const GraphNamePage({super.key, required this.onSubmit, required this.value});

  final Function(String) onSubmit;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("Graph name"),
          TextFormField(
            initialValue: value,
            onFieldSubmitted: onSubmit,
          ),
        ],
      ),
    );
  }
}
