import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:walewein/pages/graph/components/relation_card.dart';
import 'package:walewein/shared/components/constants.dart';
import 'package:walewein/shared/components/view_model_builder.dart';
import 'package:walewein/view_models/graph_view_model.dart';
import '../../shared/components/chart_view.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:walewein/models/data/graph_model.dart';
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
      view: _view,
    );
  }

  Widget _view(GraphViewModel model) {
    return model.loaded ? _body(model) : _loadingScreen();
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

  Widget _body(GraphViewModel model) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model.title),
        leading: IconButton(
          onPressed: () {
            Navigator.of(model.context).push(MaterialPageRoute(
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
              height: model.size.height * 0.6,
              child: PageView(
                controller: model.controller,
                children: [
                  _buildPage(
                    "Current Usage",
                    Expanded(
                      child: ChartViewV2(
                        graph: model.graph,
                        showLabels: true,
                        showPredictions: false,
                      ),
                    ),
                  ),
                  _buildPage(
                    "Predicted Usage",
                    Expanded(
                      child: ChartViewV2(
                        graph: model.graph,
                        showLabels: true,
                        showPredictions: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SmoothPageIndicator(
              controller: model.controller,
              count: 2,
              effect: const WormEffect(
                spacing: 12,
                dotHeight: 11,
                dotWidth: 40,
                activeDotColor: kPrimaryColor,
              ),
              onDotClicked: model.goToPage,
            ),
            _buildRelationsList(model),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(model),
    );
  }

  FloatingActionButton _buildFloatingActionButton(GraphViewModel model) {
    return FloatingActionButton(
      onPressed: () => _addEntry(model.graph, model.context),
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
      children: [
        for (final relation in model.graph.relations)
          RelationCard(
            relation: relation,
            onNodePressed: model.onNodePressed,
          )
      ],
    );
  }

  void _addEntry(Graph graph, BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddEntryPage(graph: graph)),
    );
  }
}
