import 'package:flutter/material.dart';
import 'package:walewein/pages/home/components/graph_card.dart';
import 'package:walewein/pages/home/components/header_with_search_box.dart';
import 'package:walewein/pages/home/components/title_with_edit_button.dart';
import 'package:walewein/shared/components/constants.dart';
import 'package:walewein/shared/components/view_model_builder.dart';
import 'package:walewein/shared/constants.dart';
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

  Scaffold _view(HomeViewModel model) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWithSearchBox(size: model.size),
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

  FloatingActionButton _buildFloatingActionButton(HomeViewModel model) {
    return FloatingActionButton(
      onPressed: model.addGraph,
      backgroundColor: kPrimaryColor,
      tooltip: 'Add Graph',
      child: const Icon(Icons.add),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: kPrimaryColor,
      leading: IconButton(
        onPressed: () {},
        color: kBackgroundColor,
        icon: const Icon(Icons.menu),
      ),
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
