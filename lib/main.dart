import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:walewein/pages/home/home_page.dart';
import 'package:walewein/shared/constants.dart';
import 'package:walewein/shared/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDisplayMode.setHighRefreshRate();

  final storage = StorageService();
  await storage.initPrices();

  await EasyLocalization.ensureInitialized();

  setSystemNavBarColor();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('nl'), Locale('fr')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
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
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Mulish',
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
