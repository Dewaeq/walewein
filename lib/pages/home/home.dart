import 'package:flutter/material.dart';
import 'package:walewein/models/graph/graph_model.dart';
import 'package:walewein/pages/add_graph/add_graph_page.dart';
import 'package:walewein/pages/home/components/graph_card.dart';
import 'package:walewein/pages/home/components/header_with_search_box.dart';
import 'package:walewein/pages/home/components/title_with_edit_button.dart';
import 'package:walewein/shared/constants.dart';
import 'package:walewein/shared/services/isar_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _isarService = IsarService();

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
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<List<Graph>>(
          stream: _isarService.listenGraphs(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text(
                "Add your first graph",
              );
            }
            return Column(
              children: [
                for (var graph in snapshot.data!)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: GraphCard(graph: graph),
                  )
              ],
            );
          }),
    );
  }

  _addGraph() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddGraphPage()),
    );
  }
}
