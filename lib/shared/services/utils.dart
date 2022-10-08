import 'package:flutter/foundation.dart';

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

String keyToDateString(double value) {
  final month = value.floor().toInt();
  var parts = (value - month.toDouble()) * 2592000;

  final day = parts ~/ (24 * 3600);
  parts -= day * 24 * 3600;

  final hour = parts ~/ 3600;
  parts -= hour * 3600;

  final minute = parts ~/ 60;

  return "$day/$month\n$hour:$minute";
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
