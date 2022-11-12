import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:walewein/shared/components/constants.dart';
import 'package:walewein/shared/components/view_model_builder.dart';
import 'package:walewein/view_models/chart_view_model.dart';
import '../../models/data/graph_model.dart';
import '../constants.dart';

class ChartViewV2 extends StatelessWidget {
  ChartViewV2({
    Key? key,
    required this.graph,
    required this.showLabels,
    required this.showPredictions,
  }) : super(key: key ?? UniqueKey());

  final Graph graph;
  final bool showLabels;
  final bool showPredictions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: showLabels ? const EdgeInsets.all(kDefaultPadding) : null,
      child: ViewModelBuilder(
        viewModel: ChartViewModel(context, graph, showLabels, showPredictions),
        view: _view,
      ),
    );
  }

  Widget _view(ChartViewModel model) {
    if (!model.loaded) {
      return const Center(
        child: Text(
          "Add an entry first",
        ),
      );
    }

    if (model.showLabels) {
      return _buildChartWithLabels(model);
    }

    return _buildChart(model);
  }

  Widget _buildChartWithLabels(ChartViewModel model) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (final label in model.yLabels()) Text(label),
                  ],
                ),
              ),
              defaultHalfWidthSizedBox,
              Expanded(
                child: _buildChart(model),
              ),
            ],
          ),
        ),
        defaultHalfHeightSizedBox,
        Padding(
          padding: const EdgeInsets.only(left: kDefaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final label in model.xLabels()) Text(label),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChart(ChartViewModel model) {
    return LineChart(
      LineChartData(
        minX: model.chartRange.minX,
        maxX: model.chartRange.maxX,
        minY: model.chartRange.minY,
        maxY: model.chartRange.maxY,
        gridData: model.gridData(),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          for (final relation in model.chartRelations)
            LineChartBarData(
              barWidth: 5,
              isCurved: true,
              gradient: const LinearGradient(colors: [
                Color(0xff23b6e6),
                Color(0xff02d39a),
              ]),
              spots: model.buildSpots(relation),
              dotData: dotData(),
              belowBarData: BarAreaData(
                show: false,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xff23b6e6),
                    const Color(0xff02d39a),
                  ].map((color) => color.withOpacity(0.3)).toList(),
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ..._buildPredictions(model),
        ],
      ),
    );
  }

  FlDotData dotData([Color color = kPrimaryColor]) {
    return FlDotData(
      show: showLabels,
      getDotPainter: (p0, p1, p2, p3) {
        return FlDotCirclePainter(
          strokeColor: Colors.transparent,
          color: color,
          radius: 2.5,
        );
      },
    );
  }

  List<LineChartBarData> _buildPredictions(ChartViewModel model) {
    if (!model.showPredictions) return [];

    return [
      for (final entry in model.trends.entries)
        LineChartBarData(
          barWidth: 5,
          spots: [
            FlSpot(
              model.lastNode.x.millisecondsSinceEpoch.toDouble(),
              model.lastNode.y,
            ),
            FlSpot(
              entry.value.x.millisecondsSinceEpoch.toDouble(),
              entry.value.y,
            ),
          ],
          dotData: dotData(Colors.red),
          color: Colors.orange,
        ),
    ];
  }
}
