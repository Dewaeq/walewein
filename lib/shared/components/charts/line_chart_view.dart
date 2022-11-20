import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:walewein/shared/components/charts/chart_view.dart';
import 'package:walewein/shared/components/constants.dart';
import 'package:walewein/shared/constants.dart';
import 'package:walewein/view_models/chart_view_model.dart';

class LineChartView extends StatelessWidget {
  const LineChartView({
    super.key,
    required this.model,
    this.title,
    this.subtitle,
    this.showLabels = false,
  });

  final ChartViewModel model;
  final String? title;
  final String? subtitle;
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitles(),
        if (title != null || subtitle != null)
          const SizedBox(
            height: 38,
          ),
        Expanded(
          child: model.isGraphEmpty()
              ? Center(child: _notEnoughEntries())
              : showLabels
                  ? _buildChartWithLabels()
                  : _buildLineChart(),
        ),
      ],
    );
  }

  Text _notEnoughEntries() {
    return Text(
      'chart.addEntryFirst'.tr(),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: showLabels ? 22 : 14,
        fontWeight: FontWeight.bold,
        color: showLabels ? Colors.white : kGraphTitleColor,
      ),
    );
  }

  Column _buildTitles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: const TextStyle(
              color: kGraphTitleColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (title != null || subtitle != null)
          const SizedBox(
            height: 4,
          ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: const TextStyle(
              color: kGraphTextColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  LineChart _buildLineChart() {
    return LineChart(
      LineChartData(
        minX: model.chartRange.minX,
        maxX: model.chartRange.maxX,
        minY: model.chartRange.minY,
        maxY: model.chartRange.maxY,
        gridData: model.gridData(),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: _lineTouchData(),
        lineBarsData: [
          for (final relation in model.chartRelations)
            LineChartBarData(
              isStrokeCapRound: true,
              isStrokeJoinRound: true,
              barWidth: model.selectedPointIndex >= 0 ? 14 : 11,
              isCurved: true,
              color:
                  model.selectedPointIndex >= 0 ? Colors.yellow : Colors.white,
              spots: [
                ...model.buildSpots(relation),
                if (model.chartType == ChartViewType.predictions)
                  FlSpot(
                    model.trends[relation]!.x.millisecondsSinceEpoch.toDouble(),
                    model.trends[relation]!.y,
                  ),
              ],
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
        ],
      ),
    );
  }

  Widget _buildChartWithLabels() {
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
                  children: model.yLabels().map((e) => _title(e)).toList(),
                ),
              ),
              defaultWidthSizedBox,
              Expanded(
                child: _buildLineChart(),
              ),
            ],
          ),
        ),
        defaultHeightSizedBox,
        Padding(
          padding: const EdgeInsets.only(left: kDefaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: model.xLabels().map((e) => _title(e)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: kGraphTextColor,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  FlDotData dotData([Color? color]) {
    return FlDotData(
      show: showLabels,
      getDotPainter: (p0, p1, p2, p3) {
        return FlDotCirclePainter(
          strokeColor: Colors.transparent,
          color:
              model.selectedPointIndex >= 0 && p0.y != model.selectedPointIndex
                  ? Colors.yellow
                  : color ?? kGraphTextColor,
          radius: 4.5,
        );
      },
    );
  }

  LineTouchData _lineTouchData() {
    return LineTouchData(
      getTouchedSpotIndicator: (barData, spotIndexes) => List.filled(
        spotIndexes.length,
        TouchedSpotIndicatorData(
          FlLine(color: Colors.transparent),
          FlDotData(show: false),
        ),
      ),
      touchCallback: (event, lineTouchResponse) {
        if (!event.isInterestedForInteractions ||
            lineTouchResponse == null ||
            lineTouchResponse.lineBarSpots == null ||
            lineTouchResponse.lineBarSpots!.isEmpty) {
          model.unSelectPoint();
          return;
        }
        model.selectPoint(lineTouchResponse.lineBarSpots!.first.y);
      },
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: Colors.blueGrey,
        getTooltipItems: (spots) {
          List<LineTooltipItem?> items = List.filled(spots.length, null);

          for (int i = 0; i < spots.length; i++) {
            final spot = spots[i];
            final date = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
            final suffix = ' ${model.graph.relations[i].yLabel}';

            items[i] = LineTooltipItem(
                i == 0 ? '${DateFormat('d MMMM').format(date)}\n' : '',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: [
                  TextSpan(
                    text: spot.y.round().toString() + suffix,
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ]);
          }

          return items;
        },
      ),
    );
  }
}
