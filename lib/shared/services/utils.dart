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
