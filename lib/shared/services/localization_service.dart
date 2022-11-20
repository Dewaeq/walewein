import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

class LocalizationService {
  static Future<void> setGlobalLocale(
      BuildContext context, Locale locale) async {
    await context.setLocale(locale);
    await setDateLocale(locale.languageCode);
  }

  static Future<void> setDateLocale(String locale) async {
    await initializeDateFormatting(locale, null);
    Intl.defaultLocale = locale;
  }
}
