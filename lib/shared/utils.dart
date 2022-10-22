import 'package:flutter/material.dart';

extension WaleweinParse on String {
  String parse() {
    if (contains(",")) {
      return replaceAll(",", ".").parse();
    }

    var result = "";
    var hasComma = false;

    for (var i = 0; i < length; i++) {
      final char = this[i];
      if (double.tryParse(char) != null) {
        result += char;
      } else if (char == "." && !hasComma) {
        result += char;
        hasComma = true;
      }
    }

    return result;
  }
}

Future<DateTime> pickDate({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime defaultDate,
}) async {
  return await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
        lastDate: DateTime.now().add(const Duration(days: 9000)),
      ) ??
      defaultDate;
}

String intToMonth(int month) {
  switch (month) {
    case 1:
      return 'JAN';
    case 2:
      return 'FEB';
    case 3:
      return 'MAR';
    case 4:
      return 'APR';
    case 5:
      return 'MAY';
    case 6:
      return 'JUN';
    case 7:
      return 'JUL';
    case 8:
      return 'AUG';
    case 9:
      return 'SEP';
    case 10:
      return 'OCT';
    case 11:
      return 'NOV';
    case 12:
      return 'DEC';
    default:
      return '';
  }
}
