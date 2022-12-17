import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/models/data/price_model.dart';
import 'package:walewein/pages/home/home_page.dart';
import 'package:walewein/shared/components/constants.dart';
import 'package:walewein/shared/constants.dart';
import 'package:walewein/shared/extensions.dart';
import 'package:walewein/shared/services/backup_service.dart';
import 'package:walewein/shared/services/localization_service.dart';
import 'package:walewein/shared/services/storage_service.dart';
import 'package:walewein/shared/utils.dart';

class HomeDrawer extends StatelessWidget {
  HomeDrawer({
    Key? key,
    required this.prices,
  }) : super(key: key);

  final List<Price> prices;

  final storage = StorageService();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 45),
      child: ClipRRect(
        borderRadius: const BorderRadius.horizontal(
          right: Radius.circular(25),
        ),
        child: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    'general.settings'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: kDefaultPadding,
                        top: kDefaultPadding,
                      ),
                      child: Text(
                        'settings.editPrice'.tr(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: kTextColor,
                        ),
                      ),
                    ),
                    _buildPriceListTile(context, GraphType.gas),
                    divider(),
                    _buildPriceListTile(context, GraphType.electricity),
                    divider(),
                    _buildPriceListTile(context, GraphType.electricityDouble),
                    divider(),
                    _buildPriceListTile(context, GraphType.water),
                    divider(),
                    _buildPriceListTile(context, GraphType.firePlace),
                  ],
                ),
              ),
              defaultHeightSizedBox,
              FutureBuilder(
                future: PackageInfo.fromPlatform(),
                builder: (_, snapshot) => _buildAboutListTile(snapshot),
              ),
              Padding(
                padding: const EdgeInsets.only(left: kDefaultPadding / 2),
                child: Row(
                  children: [
                    _buildBackupButton(
                      () => _saveBackup(context),
                      Icons.file_download_outlined,
                      'general.backup',
                    ),
                    defaultHalfWidthSizedBox,
                    _buildBackupButton(
                      () => _loadBackup(context),
                      Icons.backup,
                      'general.restore',
                    ),
                  ],
                ),
              ),
              _buildFooter(context)
            ],
          ),
        ),
      ),
    );
  }

  Container _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MaterialButton(
            onPressed: () {
              Scaffold.of(context).closeDrawer();
            },
            color: kPrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              'general.close'.tr().toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          MaterialButton(
            onPressed: () => _showLanguageDialog(context),
            shape: const CircleBorder(),
            minWidth: 0,
            color: kPrimaryColor,
            child: const Icon(
              Icons.language,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return const Divider(
      indent: kDefaultPadding,
      endIndent: kDefaultPadding,
      thickness: 0.8,
    );
  }

  Widget _buildAboutListTile(AsyncSnapshot<PackageInfo> snapshot) {
    if (!snapshot.hasData) return Container();

    final packageInfo = snapshot.data!;
    return AboutListTile(
      applicationVersion: packageInfo.version,
      applicationName: packageInfo.appName,
      applicationIcon: Image.asset(
        'assets/icon/icon.png',
        width: 32,
      ),
      aboutBoxChildren: [
        ListTile(
          title: Text('settings.packageName'.tr()),
          subtitle: Text(packageInfo.packageName),
        ),
        ListTile(
          title: Text('settings.buildNumber'.tr()),
          subtitle: Text(packageInfo.buildNumber),
        ),
        ListTile(
          title: Text('settings.installSource'.tr()),
          subtitle: Text(packageInfo.installerStore ?? 'settings.unknown'.tr()),
        ),
        ListTile(
          title: Text.rich(
            TextSpan(
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              text: 'App icon created by Flat Icons - Flaticon',
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  await launchUrlString(
                      'https://www.flaticon.com/free-icons/electricity');
                },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceListTile(context, GraphType type) {
    final value = prices.firstWhere((x) => x.graphType == type);
    final unit = unityTypeToString(type);

    final typeName = '$type'.tr();
    final title = 'settings.editPrice'.tr(args: [typeName.toLowerCase()]);

    return ListTile(
      title: Text('$type'.tr()),
      subtitle: Text('€ ${value.price.toStringAsFixed(2)}/$unit'),
      onTap: () => _showPriceDialog(context, type, title),
    );
  }

  Widget _buildLocaleListTile(
      BuildContext context, bool isSelected, Locale locale) {
    return ListTile(
      title: Text(locale.languageCode),
      selected: isSelected,
      onTap: () => _setLocale(locale, context),
    );
  }

  Widget _buildBackupButton(Function() onPressed, IconData icon, String title) {
    return TextButton.icon(
      onPressed: onPressed,
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(kPrimaryColor),
      ),
      icon: Icon(
        icon,
        color: Colors.white,
        size: 24,
      ),
      label: Text(
        title.tr(),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  void _showPriceDialog(
    BuildContext context,
    GraphType type,
    String title,
  ) async {
    final value = prices.firstWhere((x) => x.graphType == type);
    final controller =
        TextEditingController(text: value.price.toStringAsFixed(2));

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'general.cancel'.tr()),
              child: Text('general.cancel'.tr()),
            ),
            TextButton(
              onPressed: () async {
                value.price = double.parse(controller.text.parse());
                await storage.savePrice(value);

                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: Text('general.ok'.tr()),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final current = context.locale;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + kDefaultPadding,
            left: kDefaultPadding,
            right: kDefaultPadding,
            top: kDefaultPadding,
          ),
          child: ListView(
            shrinkWrap: true,
            children: supportedLocales
                .map((locale) => _buildLocaleListTile(
                      context,
                      locale == current,
                      locale,
                    ))
                .toList(),
          ),
        );
      },
    );
  }

  Future<void> _setLocale(Locale target, BuildContext context) async {
    await LocalizationService.setGlobalLocale(context, target);

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  Future<void> _saveBackup(BuildContext context) async {
    await BackupService.saveBackup(
      onSucces: () {
        showModalBottomSheetNote(context, 'settings.savedBackup');
      },
      onError: () {
        _showAlertDialog(
            context, 'general.saveError', 'settings.saveBackupError');
      },
    );
  }

  Future<void> _loadBackup(BuildContext context) async {
    await BackupService.loadBackup(
      onSucces: () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()));
      },
      onError: () {
        _showAlertDialog(
            context, 'general.readError', 'settings.loadBackupError');
      },
    );
  }

  void _showAlertDialog(BuildContext context, String title, String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title.tr()),
          content: Text(text.tr()),
          actionsPadding: const EdgeInsets.only(
            right: 20,
            bottom: 10,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'general.close'.tr()),
              child: Text('general.close'.tr()),
            ),
          ],
        );
      },
    );
  }
}
