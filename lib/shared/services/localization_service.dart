import 'package:easy_localization/easy_localization.dart';
import 'package:intl/date_symbol_data_local.dart';

class LocalizationService {
  static Future<void> setDateLocale(String locale) async {
    await initializeDateFormatting(locale, null);
    Intl.defaultLocale = locale;
  }
}
