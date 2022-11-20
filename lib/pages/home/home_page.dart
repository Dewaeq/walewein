import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/pages/graph/graph_page.dart';
import 'package:walewein/pages/home/components/drawer.dart';
import 'package:walewein/pages/home/components/graph_card.dart';
import 'package:walewein/pages/home/components/title_with_edit_button.dart';
import 'package:walewein/shared/components/constants.dart';
import 'package:walewein/shared/components/view_model_builder.dart';
import 'package:walewein/shared/constants.dart';
import 'package:walewein/shared/utils.dart';
import 'package:walewein/view_models/home_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder(
      viewModel: HomeViewModel(context),
      view: _view,
    );
  }

  Widget _view(HomeViewModel model) {
    if (!model.loaded) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: kBackgroundColor,
      drawer: HomeDrawer(prices: model.prices),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopBar(model),
            TitleWithEditButton(
              title: 'home.graphs'.tr(),
              isEditing: model.isSelecting,
              onPress: model.editGraphs,
            ),
            _buildGraphsList(model),
            defaultHeightSizedBox,
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(model),
    );
  }

  Widget _buildTopBar(HomeViewModel model) {
    return Container(
      margin: const EdgeInsets.only(bottom: kDefaultPadding * 2.5),
      height: model.size.height * 0.2,
      child: Stack(
        children: [
          _buildHeader(model),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding,
                vertical: kDefaultPadding * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 50,
                    color: kPrimaryColor.withOpacity(0.23),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'home.costs'.tr(),
                    style: const TextStyle(
                      color: kSubTextColor,
                      fontSize: 16,
                    ),
                  ),
                  defaultHalfHeightSizedBox,
                  if (model.graphs.isEmpty)
                    Text(
                      'home.createGraphFirst'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: model.graphs
                        .take(3)
                        .map((e) => _priceCard(model, e))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildHeader(HomeViewModel model) {
    return Container(
      height: model.size.height * 0.2 - 40,
      padding: const EdgeInsets.only(
        left: kDefaultPadding,
        right: kDefaultPadding,
        bottom: 36 + kDefaultPadding,
      ),
      decoration: const BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(36),
        ),
      ),
      child: Row(
        children: [
          Text(
            'home.greeting'.tr(),
            style: Theme.of(model.context).textTheme.headline4?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Spacer(),
          const Icon(
            size: 38,
            Icons.graphic_eq,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _priceCard(HomeViewModel model, Graph graph) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: RawMaterialButton(
          onPressed: () {
            Navigator.of(model.context).push(
              MaterialPageRoute(builder: (context) => GraphPage(id: graph.id!)),
            );
          },
          fillColor: Colors.grey.shade100,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          padding: const EdgeInsets.symmetric(vertical: 5),
          elevation: 0,
          focusElevation: 0,
          highlightElevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              graphTypeToIcon(graph.graphType, 14),
              defaultHalfWidthSizedBox,
              Text('€ ${model.graphPrice(graph)}'),
            ],
          ),
        ),
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton(HomeViewModel model) {
    return FloatingActionButton(
      onPressed:
          model.isSelecting ? model.deleteSelectedGraphs : model.addGraph,
      backgroundColor: model.isSelecting ? Colors.red : kPrimaryColor,
      tooltip: model.isSelecting
          ? 'general.deleteSelection'.tr()
          : 'home.addGraph'.tr(),
      child: Stack(
        children: [
          AnimatedScale(
            duration: const Duration(milliseconds: 300),
            scale: model.isSelecting ? 0 : 1,
            child: const Icon(Icons.add),
          ),
          AnimatedScale(
            duration: const Duration(milliseconds: 300),
            scale: model.isSelecting ? 1 : 0,
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: kPrimaryColor,
      leading: Builder(builder: (context) {
        return IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          color: kBackgroundColor,
          icon: const Icon(Icons.menu),
        );
      }),
    );
  }

  Widget _buildGraphsList(HomeViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          for (int i = 0; i < model.graphs.length; i++)
            Container(
              padding: const EdgeInsets.all(8.0),
              child: GraphCard(
                key: model.chartViewKeys[i],
                graph: model.graphs[i],
                isSelecting: model.isSelecting,
                isSelected: model.selectedGraphs[model.graphs[i]]!,
                onSelect: () => model.select(model.graphs[i]),
              ),
            ),
        ],
      ),
    );
  }
}
