import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:walewein/shared/components/toggle_button.dart';
import 'package:walewein/shared/constants.dart';
import 'package:walewein/view_models/chart_view_model.dart';

class BarChartView extends StatelessWidget {
  const BarChartView({
    super.key,
    required this.model,
    required this.subtitle,
  });

  final ChartViewModel model;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: _buildTitles()),
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
        Text(
          (model.showCosts ? 'chart.monthlyCosts' : 'chart.monthlyUsage').tr(),
          style: const TextStyle(
            color: kGraphTitleColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          subtitle,
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
        color: kGraphAccentColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: model.toggleCosts,
        icon: ToggleButton(
          showPrimary: model.showCosts,
          primaryIcon: Icons.calendar_month,
          secondaryIcon: Icons.price_change,
          iconColor: kGraphTitleColor,
        ),
      ),
    );
  }

  Text _notEnoughEntries() {
    return Text(
      'chart.atLeastTwoEntries'.tr(),
      textAlign: TextAlign.center,
      style: const TextStyle(
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
        getTooltipItem: (g, _, r, __) =>
            getTooltipItem(model, g, r as ViewBarDataPoint),
      ),
      touchCallback: (e, r) => touchCallBack(model, e, r),
    );
  }

  BarTooltipItem? getTooltipItem(
    ChartViewModel model,
    BarChartGroupData group,
    ViewBarDataPoint rod,
  ) {
    final date = DateTime(0, group.x);
    final month = DateFormat('MMMM').format(date);
    final prefix = model.showCosts ? '€ ' : '';

    String content(int i) =>
        (rod.entries[i].toY - rod.entries[i].fromY).round().toString();
    String label(int i) => model.showCosts ? '' : rod.entries[i].label.tr();
    String suffix(int i) => i == rod.entries.length - 1 ? '' : '\n';

    return BarTooltipItem(
      '$month\n',
      const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      children: <TextSpan>[
        for (int i = 0; i < rod.entries.length; i++)
          TextSpan(
            text: '$prefix${content(i)} ${label(i)}${suffix(i)}',
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
    final barColors = model.graph.relations.length == 1
        ? [Colors.white, Colors.white]
        : [kPrimaryColor, Colors.white];

    return BarChartGroupData(
      x: data.x,
      barRods: [
        ViewBarDataPoint(
          entries: data.entries,
          toY: model.barHeight(data),
          color: model.barColor(data),
          width: 22,
          rodStackItems: _buildRodStackItems(data, model, barColors),
          borderRadius: BorderRadius.circular(50),
          borderSide: data.isSelected
              ? const BorderSide(color: Colors.yellow)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: model.barBackgroundHeight(data),
            color: kGraphAccentColor,
          ),
        ),
      ],
    );
  }

  List<BarChartRodStackItem> _buildRodStackItems(
      BarDataPoint data, ChartViewModel model, List<Color> barColors) {
    return [
      for (int i = 0; i < data.entries.length; i++)
        BarChartRodStackItem(
          data.entries[i].fromY,
          data.entries[i].toY,
          data.isSelected || model.isAnimatingCosts
              ? Colors.yellow
              : barColors[i],
        ),
    ];
  }

  Widget getTitles(double value, TitleMeta meta) {
    final date = DateTime(0, value.toInt());
    final content =
        DateFormat('MMM').format(date).substring(0, 1).toUpperCase();

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
