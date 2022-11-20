import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/shared/components/charts/bar_chart_view.dart';
import 'package:walewein/shared/components/charts/line_chart_view.dart';
import 'package:walewein/shared/components/view_model_builder.dart';
import 'package:walewein/shared/constants.dart';
import 'package:walewein/view_models/chart_view_model.dart';

enum ChartViewType {
  cumulativeUsage,
  predictions,
  monthlyUsage,
}

class ChartView extends StatelessWidget {
  const ChartView({
    super.key,
    required this.graph,
    required this.showLabels,
    required this.chartType,
  });

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
    return Container(
      decoration: BoxDecoration(
        color: kGraphBackgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(16),
      child: _buildChart(model),
    );
  }

  Widget _buildChart(ChartViewModel model) {
    if (!model.loaded) {
      return Center(
        child: Text(
          'chart.addEntryFirst'.tr(),
          textAlign: TextAlign.center,
          style: const TextStyle(
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
        title: 'chart.monthlyUsage'.tr(),
        subtitle: 'chart.monthlyUsageEstimated'.tr(),
      );
    }

    if (chartType == ChartViewType.predictions) {
      return LineChartView(
        model: model,
        title: 'chart.predictedUsage'.tr(),
        subtitle: 'chart.predictedUsageEstimated'.tr(),
        showLabels: true,
      );
    }

    if (model.showLabels) {
      return LineChartView(
        model: model,
        title: 'chart.cumulativeUsage'.tr(),
        subtitle: 'chart.cumulativeUsageLimit'.tr(),
        showLabels: true,
      );
    }

    return LineChartView(model: model);
  }
}
