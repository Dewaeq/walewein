import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:walewein/shared/components/constants.dart';
import 'package:walewein/shared/components/temp.dart';
import 'package:walewein/shared/components/view_model_builder.dart';
import 'package:walewein/view_models/chart_view_model.dart';
import '../../models/data/graph_model.dart';
import '../constants.dart';

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
    if (!model.loaded) {
      return const Center(
        child: Text(
          "Add an entry first",
        ),
      );
    }

    if (chartType == ChartViewType.monthlyUsage) {
      return _buildBarChart(model);
    }
    if (chartType == ChartViewType.predictions) {
      return const BarChartSample1();
    }

    if (model.showLabels) {
      return _buildChartWithLabels(model);
    }

    return _buildLineChart(model);
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
                child: _buildLineChart(model),
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

  Widget _buildLineChart(ChartViewModel model) {
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

  Widget _buildBarChart(ChartViewModel model) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff81e5cd),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: getTitles,
                reservedSize: 38,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: model.monthlyUsages
              .map(
                (e) => BarChartGroupData(x: e[0], barRods: [
                  BarChartRodData(
                    toY: e[1].toDouble(),
                    color: Colors.white,
                    width: 22,
                    borderSide: const BorderSide(color: Colors.white, width: 0),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: 40,
                      color: const Color(0xff72d8bf),
                    ),
                  ),
                ]),
              )
              .toList(),
          gridData: FlGridData(show: false),
        ),
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    final date = DateTime(0, value.toInt());
    final content = DateFormat("MMM").format(date);

    final text = Text(
      content,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
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
    if (model.chartType != ChartViewType.predictions) return [];

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
