import 'package:easy_localization/easy_localization.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:walewein/pages/graph/components/relation_card.dart';
import 'package:walewein/shared/components/charts/chart_view.dart';
import 'package:walewein/shared/components/constants.dart';
import 'package:walewein/shared/components/view_model_builder.dart';
import 'package:walewein/view_models/graph_view_model.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/pages/add_entry/add_entry_page.dart';
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
        tooltip: 'general.addEntry'.tr(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _body(GraphViewModel model) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            defaultHeightSizedBox,
            Container(
              padding: const EdgeInsets.only(
                bottom: 15,
                left: 10,
                right: 10,
              ),
              height: model.size.height * 0.55,
              child: PageView(
                controller: model.controller,
                children: [
                  _buildPage(
                    model,
                    model.graph,
                    ChartViewType.monthlyUsage,
                  ),
                  _buildPage(
                    model,
                    model.graph,
                    ChartViewType.cumulativeUsage,
                  ),
                  _buildPage(
                    model,
                    model.graph,
                    ChartViewType.predictions,
                  ),
                ],
              ),
            ),
            SmoothPageIndicator(
              controller: model.controller,
              count: 3,
              effect: const WormEffect(
                spacing: 12,
                dotHeight: 11,
                dotWidth: 40,
                activeDotColor: kPrimaryColor,
              ),
              onDotClicked: model.goToPage,
            ),
            defaultHeightSizedBox,
            defaultHeightSizedBox,
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
      tooltip: 'general.addEntry'.tr(),
      child: const Icon(Icons.add),
    );
  }

  Widget _buildPage(
      GraphViewModel model, Graph graph, ChartViewType chartType) {
    return ChartView(
      key: model.chartViewKeys[chartType.index],
      graph: graph,
      showLabels: true,
      chartType: chartType,
    );
  }

  Widget _buildRelationsList(GraphViewModel model) {
    List<Widget> children = [];

    for (final relation in model.graph.relations) {
      children.add(RelationCard(
        relation: relation,
        onNodePressed: model.onNodePressed,
      ));
      children.add(defaultHeightSizedBox);
    }

    return Column(
      children: children,
    );
  }

  void _addEntry(Graph graph, BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddEntryPage(graph: graph)),
    );
  }
}
