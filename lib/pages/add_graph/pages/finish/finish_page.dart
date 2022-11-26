import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/shared/components/constants.dart';
import 'package:walewein/shared/constants.dart';

class FinishPage extends StatelessWidget {
  const FinishPage({
    super.key,
    required this.graphName,
    required this.graphType,
  });

  final String? graphName;
  final GraphType? graphType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Text(
              'addGraph.checkValues'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          ),
          const SizedBox(height: 60),
          _buildCard('addGraph.createGraph'.tr(), graphName ?? ''),
          _buildCard('addGraph.withType'.tr(), '$graphType'.tr()),
        ],
      ),
    );
  }

  Container _buildCard(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding:
          const EdgeInsets.symmetric(horizontal: 15, vertical: kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: defaultButtonBorderRadius,
        border: Border.all(
          color: Colors.grey[200]!,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
