import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:walewein/main.dart';
import 'package:walewein/models/graph/graph_model.dart';
import 'package:walewein/pages/add_graph/add_graph_page.dart';
import 'package:walewein/pages/graph/graph_page.dart';
import 'package:walewein/pages/home/components/graph_card.dart';
import 'package:walewein/pages/home/components/header_with_search_box.dart';
import 'package:walewein/pages/home/components/title_with_edit_button.dart';
import 'package:walewein/shared/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWithSearchBox(size: size),
            TitleWithEditButton(title: "Your graphs", onPress: () {}),
            _buildGraphsList(),
            const SizedBox(height: 15),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _addGraph,
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

  Widget _buildGraphsList() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 1,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 3,
        children: [
          for (var graph in graphs) GraphCard(graph: graph),
        ],
      ),
    );
  }

  _addGraph() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddGraphPage()),
    );
  }
}
