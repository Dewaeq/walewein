import 'package:flutter/material.dart';
import 'package:walewein/models/data/graph_model.dart';
import 'package:walewein/pages/home/components/drawer.dart';
import 'package:walewein/pages/home/components/graph_card.dart';
import 'package:walewein/pages/home/components/title_with_edit_button.dart';
import 'package:walewein/shared/components/constants.dart';
import 'package:walewein/shared/components/view_model_builder.dart';
import 'package:walewein/shared/constants.dart';
import 'package:walewein/shared/services/graph_service.dart';
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
      drawer: const HomeDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            priceContainer(model),
            TitleWithEditButton(
              title: "Your graphs",
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

  Widget priceContainer(HomeViewModel model) {
    return Container(
      margin: const EdgeInsets.only(bottom: kDefaultPadding * 2.5),
      height: model.size.height * 0.2,
      child: Stack(
        children: [
          Container(
            height: model.size.height * 0.2 - 27,
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
                  "Hello!",
                  style: Theme.of(model.context).textTheme.headline5?.copyWith(
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
          ),
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
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    const Text(
                      "Costs this month",
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 16,
                      ),
                    ),
                    defaultHalfHeightSizedBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _priceCard(model.graphs[0]),
                        _priceCard(model.graphs[1]),
                        _priceCard(model.graphs[2]),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceCard(Graph graph) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: RawMaterialButton(
          onPressed: () {},
          fillColor: Colors.grey.shade100,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          padding: const EdgeInsets.symmetric(vertical: 5),
          elevation: 0,
          focusElevation: 0,
          highlightElevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GraphService.graphTypeToIcon(graph.graphType, 14),
              defaultHalfWidthSizedBox,
              const Text("€ 15"),
            ],
          ),
        ),
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton(HomeViewModel model) {
    return FloatingActionButton(
      onPressed: model.addGraph,
      backgroundColor: kPrimaryColor,
      tooltip: 'Add Graph',
      child: const Icon(Icons.add),
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
    if (!model.loaded) {
      return const Text("Add your first graph");
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          for (final graph in model.graphs)
            Container(
              padding: const EdgeInsets.all(8.0),
              child: GraphCard(graph: graph),
            ),
        ],
      ),
    );
  }
}
