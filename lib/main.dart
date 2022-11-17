import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:walewein/pages/home/home_page.dart';
import 'package:walewein/shared/constants.dart';
import 'package:walewein/shared/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDisplayMode.setHighRefreshRate();

  final storage = StorageService();
  await storage.initPrices();

  await initializeDateFormatting("nl_BE", null);
  Intl.defaultLocale = "nl_BE";

  setSystemNavBarColor();

  runApp(const MyApp());
}

void setSystemNavBarColor() {
  if (!Platform.isAndroid) return;

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarContrastEnforced: false,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Walewein',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: "Mulish",
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
