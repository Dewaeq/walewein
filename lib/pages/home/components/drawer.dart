import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/models/data/price_model.dart';
import 'package:walewein/shared/constants.dart';
import 'package:walewein/shared/extensions.dart';
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
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Settings",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
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
              const Spacer(),
              FutureBuilder(
                future: PackageInfo.fromPlatform(),
                builder: (_, snapshot) => _buildAboutListTile(snapshot),
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
            child: const Text(
              "CLOSE",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {},
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
          title: const Text('Package name'),
          subtitle: Text(packageInfo.packageName),
        ),
        ListTile(
          title: const Text('Build number'),
          subtitle: Text(packageInfo.buildNumber),
        ),
        ListTile(
          title: const Text('Install source'),
          subtitle: Text(packageInfo.installerStore ?? "Unknown"),
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

    final typeName = graphTypeToUnitString(type);
    final title = 'Edit $typeName price';

    return ListTile(
      title: Text(title),
      subtitle: Text('€ ${value.price.toStringAsFixed(2)}/$unit'),
      onTap: () => _showPriceDialog(context, type, title),
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
              onPressed: () => Navigator.pop(context, "Cancel"),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                value.price = double.parse(controller.text.parse());
                await storage.savePrice(value);

                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
