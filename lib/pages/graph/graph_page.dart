import 'package:walewein/pages/graph/components/relation_card.dart';
import 'package:walewein/shared/components/constants.dart';
import 'package:walewein/shared/components/view_model_builder.dart';
import 'package:walewein/view_models/graph_view_model.dart';
import '../../shared/components/chart_view.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:walewein/models/graph/graph_model.dart';
import 'package:walewein/pages/add_entry/add_entry_page.dart';
import 'package:walewein/pages/home/components/text_with_custom_underline.dart';
import 'package:walewein/pages/home/home_page.dart';
import 'package:walewein/shared/constants.dart';

class GraphPage extends StatelessWidget {
  const GraphPage({super.key, required this.id});

  final Id id;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder(
      viewModel: GraphViewModel(id, context),
      view: (model) {
        return model.loaded ? _body(model, context) : _loadingScreen();
      },
    );
  }

  Widget _loadingScreen() {
    return Scaffold(
      body: const Center(
        child: CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: kPrimaryColor,
        tooltip: 'Add Entry',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _body(GraphViewModel model, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model.title),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const HomePage(),
            ));
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 10,
              ),
              height: MediaQuery.of(context).size.height * 0.7,
              child: PageView(
                children: [
                  _buildPage(
                    "Current Usage",
                    ChartView(graph: model.graph, showPrediction: false),
                  ),
                  _buildPage(
                    "Predicted Usage",
                    ChartView(graph: model.graph, showPrediction: true),
                  ),
                ],
              ),
            ),
            _buildRelationsList(model),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(model.graph, context),
    );
  }

  FloatingActionButton _buildFloatingActionButton(
      Graph graph, BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _addEntry(graph, context),
      backgroundColor: kPrimaryColor,
      tooltip: 'Add Entry',
      child: const Icon(Icons.add),
    );
  }

  Widget _buildPage(String title, Widget chart) {
    return Column(
      children: [
        TextWithCustomUnderline(text: title),
        defaultHeightSizedBox,
        chart,
      ],
    );
  }

  Widget _buildRelationsList(GraphViewModel model) {
    return Column(
      children: model.graph.relations
          .map(
            (e) => RelationCard(
              relation: e,
              onNodePressed: model.onNodePressed,
            ),
          )
          .toList(),
    );
  }

  void _addEntry(Graph graph, BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddEntryPage(graph: graph)),
    );
  }
}
