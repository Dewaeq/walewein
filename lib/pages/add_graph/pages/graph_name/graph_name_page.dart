import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:walewein/shared/components/constants.dart';
import 'package:walewein/shared/constants.dart';

class GraphNamePage extends StatelessWidget {
  const GraphNamePage({
    super.key,
    required this.value,
    required this.onChange,
  });

  final Function(String) onChange;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'addGraph.graphName'.tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          defaultHeightSizedBox,
          TextFormField(
            initialValue: value,
            onChanged: onChange,
            decoration: InputDecoration(
              filled: true,
              contentPadding: const EdgeInsets.all(kDefaultPadding),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              hintStyle: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
