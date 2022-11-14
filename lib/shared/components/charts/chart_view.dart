import 'package:flutter/material.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/shared/components/charts/bar_chart_view.dart';
import 'package:walewein/shared/components/charts/line_chart_view.dart';
import 'package:walewein/shared/components/view_model_builder.dart';
import 'package:walewein/shared/constants.dart';
import 'package:walewein/view_models/chart_view_model.dart';

enum ChartViewType {
  usage,
  predictions,
  monthlyUsage,
}

class ChartView extends StatelessWidget {
  ChartView({
    Key? key,
    required this.graph,
    required this.showLabels,
    required this.chartType,
  }) : super(key: key ?? UniqueKey());

  final Graph graph;
  final bool showLabels;
  final ChartViewType chartType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: showLabels ? const EdgeInsets.all(kDefaultPadding) : null,
      child: ViewModelBuilder(
        viewModel: ChartViewModel(context, graph, showLabels, chartType),
        view: _view,
      ),
    );
  }

  Widget _view(ChartViewModel model) {
    final child = _buildChart(model);

    return Container(
      decoration: BoxDecoration(
        color: kGraphBackgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  Widget _buildChart(ChartViewModel model) {
    if (!model.loaded) {
      return const Center(
        child: Text(
          "Add an entry first",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: kGraphTitleColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      );
    }

    if (chartType == ChartViewType.monthlyUsage) {
      return BarChartView(
        model: model,
        title: 'Monthly Usage',
        subtitle: 'Values are estimated',
      );
    }

    if (chartType == ChartViewType.predictions) {
      return LineChartView(
        model: model,
        title: 'Predicted usage',
        subtitle: 'Based on past trends',
        showLabels: true,
      );
    }

    if (model.showLabels) {
      return LineChartView(
        model: model,
        title: 'Cumulative usage',
        subtitle: 'Limited to 4 months',
        showLabels: true,
      );
    }

    return LineChartView(model: model);
  }
}
