import 'package:flutter/material.dart';
import '../add_entry/add_entry_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            backgroundColor: const Color(0xff0b9768),
            expandedHeight: MediaQuery.of(context).size.height * 0.2,
            pinned: false,
            floating: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(38),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: EdgeInsets.zero,
              title: Container(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Container(),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
            // title:
          ),
          _graphsList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddEntryPage()),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _graphsList() {
    return SliverPadding(
      padding: const EdgeInsets.all(8),
      sliver: SliverGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.4,
        children: const [
          GraphCard(
            title: "My First Graph",
          ),
          GraphCard(
            title: "My Second Graph",
          ),
          GraphCard(
            title: "My Third Graph",
          ),
          GraphCard(
            title: "My First Graph",
          ),
          GraphCard(
            title: "My Second Graph",
          ),
          GraphCard(
            title: "My Third Graph",
          ),
          GraphCard(
            title: "My First Graph",
          ),
          GraphCard(
            title: "My Second Graph",
          ),
          GraphCard(
            title: "My Third Graph",
          ),
          GraphCard(
            title: "My First Graph",
          ),
          GraphCard(
            title: "My Second Graph",
          ),
          GraphCard(
            title: "My Third Graph",
          ),
          GraphCard(
            title: "My First Graph",
          ),
          GraphCard(
            title: "My Second Graph",
          ),
          GraphCard(
            title: "My Third Graph",
          ),
          GraphCard(
            title: "My First Graph",
          ),
          GraphCard(
            title: "My Second Graph",
          ),
          GraphCard(
            title: "My Third Graph",
          ),
        ],
      ),
    );
  }
}

class GraphCard extends StatelessWidget {
  const GraphCard({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {},
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color.fromARGB(255, 239, 239, 210),
      elevation: 4,
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(
              "Description",
              style: TextStyle(
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
