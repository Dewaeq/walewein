import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:walewein/shared/constants.dart';
import 'package:walewein/view_models/chart_view_model.dart';

class BarChartView extends StatelessWidget {
  const BarChartView({
    super.key,
    required this.model,
    this.title,
    this.subtitle,
  });

  final ChartViewModel model;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTitles(),
            _buildCostsButton(),
          ],
        ),
        const SizedBox(
          height: 38,
        ),
        Expanded(
          child: model.monthlyUsages.isEmpty
              ? Center(child: _notEnoughEntries())
              : _buildBarChart(),
        ),
      ],
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

  Container _buildCostsButton() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff72d8bf),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: model.toggleCosts,
        icon: Stack(
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 300),
              scale: model.showCosts ? 0 : 1,
              child: const Icon(
                Icons.calendar_month,
                color: kGraphTitleColor,
              ),
            ),
            AnimatedScale(
              duration: const Duration(milliseconds: 300),
              scale: model.showCosts ? 1 : 0,
              child: const Icon(
                Icons.price_change,
                color: kGraphTitleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text _notEnoughEntries() {
    return const Text(
      "Add at least two entries to enable monthly usage tracking",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  BarChart _buildBarChart() {
    return BarChart(
      BarChartData(
        titlesData: titlesData(),
        borderData: FlBorderData(
          show: false,
        ),
        barTouchData: barTouchData(model),
        barGroups:
            model.monthlyUsages.map((data) => barData(model, data)).toList(),
        gridData: FlGridData(show: false),
      ),
    );
  }

  FlTitlesData titlesData() {
    return FlTitlesData(
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
    );
  }

  BarTouchData barTouchData(ChartViewModel model) {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.blueGrey,
        getTooltipItem: (g, _, r, __) => getTooltipItem(model, g, r),
      ),
      touchCallback: (e, r) => touchCallBack(model, e, r),
    );
  }

  BarTooltipItem? getTooltipItem(
      ChartViewModel model, BarChartGroupData group, BarChartRodData rod) {
    final date = DateTime(0, group.x);
    final month = DateFormat("MMMM").format(date);
    final prefix = model.showCosts ? '€ ' : '';
    final suffix =
        model.showCosts ? '' : ' ${model.graph.relations.first.yLabel}';
    final content = model.toolTipValue(rod.toY);

    return BarTooltipItem(
      '$month\n',
      const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      children: <TextSpan>[
        TextSpan(
          text: prefix + content + suffix,
          style: const TextStyle(
            color: Colors.yellow,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void touchCallBack(ChartViewModel model, FlTouchEvent event,
      BarTouchResponse? barTouchResponse) {
    if (!event.isInterestedForInteractions ||
        barTouchResponse == null ||
        barTouchResponse.spot == null) {
      model.unSelectBar();
      return;
    }
    model.selectBar(barTouchResponse.spot!.touchedBarGroupIndex);
  }

  BarChartGroupData barData(ChartViewModel model, BarDataPoint data) {
    return BarChartGroupData(
      x: data.x,
      barRods: [
        BarChartRodData(
          toY: model.barHeight(data),
          color: data.isSelected ? Colors.yellow : model.graphColor,
          width: 22,
          borderSide: data.isSelected
              ? const BorderSide(color: Colors.yellow)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: model.barBackgroundHeight(),
            color: const Color(0xff72d8bf),
          ),
        ),
      ],
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    final date = DateTime(0, value.toInt());
    final content =
        DateFormat("MMM").format(date).substring(0, 1).toUpperCase();

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
}
