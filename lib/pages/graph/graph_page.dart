import 'package:flutter/material.dart';
import 'package:walewein/models/graph/graph_model.dart';
import 'package:walewein/pages/add_entry/add_entry_page.dart';
import 'package:walewein/shared/constants.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key, required this.graph});

  final Graph graph;

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.graph.name),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _addEntry,
      backgroundColor: kPrimaryColor,
      tooltip: 'Add Entry',
      child: const Icon(Icons.add),
    );
  }

  _addEntry() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddEntryPage()),
    );
  }
}
