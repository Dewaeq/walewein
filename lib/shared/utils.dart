import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:walewein/models/data/graph_model.dart';

Future<DateTime> pickDate({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime defaultDate,
}) async {
  return await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
        lastDate: DateTime.now(),
      ) ??
      defaultDate;
}

String unityTypeToString(GraphType graphType) {
  switch (graphType) {
    case GraphType.gas:
      return 'm³';
    case GraphType.electricityDouble:
      return 'kWh';
    case GraphType.electricity:
      return 'kWh';
    case GraphType.water:
      return 'm³';
    case GraphType.firePlace:
      return 'kg';
    default:
      throw Exception('Graph type not found!');
  }
}

String graphTypeToUnitString(GraphType graphType) {
  switch (graphType) {
    case GraphType.gas:
      return 'Gas';
    case GraphType.electricityDouble:
      return 'Elektriciteit (\'s nachts)';
    case GraphType.electricity:
      return 'Elektriciteit (overdag)';
    case GraphType.water:
      return 'Water';
    case GraphType.firePlace:
      return 'Haardvuur';
    default:
      throw Exception('Graph type not found!');
  }
}

String graphTypeToString(GraphType graphType) {
  switch (graphType) {
    case GraphType.gas:
      return 'Gas';
    case GraphType.electricityDouble:
      return 'Elektriciteit (dubbele meter)';
    case GraphType.electricity:
      return 'Elektriciteit';
    case GraphType.water:
      return 'Water';
    case GraphType.firePlace:
      return 'Haardvuur';
    default:
      throw Exception('Graph type not found!');
  }
}

DisplayDateSpread daysToDisplayDateSpread(int days) {
  if (days > 95) {
    return DisplayDateSpread.year;
  } else if (days > 7) {
    return DisplayDateSpread.month;
  } else if (days > 1) {
    return DisplayDateSpread.week;
  }

  return DisplayDateSpread.day;
}

Color graphTypeToColor(GraphType graphType) {
  switch (graphType) {
    case GraphType.gas:
      return Colors.green;
    case GraphType.electricityDouble:
    case GraphType.electricity:
      return const Color(0xffff8c32);
    case GraphType.water:
      return const Color(0xff146beb);
    case GraphType.firePlace:
      return const Color(0xffcf1b04);
    default:
      return const Color(0xffaaaaaa);
  }
}

IconData graphTypeToIconData(GraphType graphType) {
  switch (graphType) {
    case GraphType.gas:
      return Icons.gas_meter;
    case GraphType.electricityDouble:
    case GraphType.electricity:
      return Icons.electrical_services;
    case GraphType.water:
      return Icons.water;
    case GraphType.firePlace:
      return CupertinoIcons.flame_fill;
    default:
      return Icons.list_alt;
  }
}

Widget graphTypeToIcon(GraphType graphType, [double radius = 20]) {
  final color = graphTypeToColor(graphType);

  return CircleAvatar(
    radius: radius,
    backgroundColor: color.withOpacity(0.2),
    child: Icon(
      graphTypeToIconData(graphType),
      color: color,
      size: radius * 1.2,
    ),
  );
}
