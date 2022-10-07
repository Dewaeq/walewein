import 'package:flutter/material.dart';
import 'package:walewein/pages/add_graph/pages/finish/finish_page.dart';
import 'package:walewein/pages/add_graph/pages/graph_name/graph_name_page.dart';
import 'package:walewein/pages/graph/graph_page.dart';
import 'package:walewein/shared/services/graph_service.dart';
import 'package:walewein/shared/services/isar_service.dart';
import '../../models/graph/graph_model.dart';
import 'components/bottom_indicator.dart';
import 'pages/graph_type/select_graph_type_page.dart';

const numPages = 3;

class AddGraphPage extends StatefulWidget {
  const AddGraphPage({super.key});

  @override
  State<AddGraphPage> createState() => _AddGraphPageState();
}

class _AddGraphPageState extends State<AddGraphPage> {
  final _pageController = PageController();
  double _page = 0;
  double _lastCompletedPage = -1;

  GraphType? _selectedType;
  String? _graphName;

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() => _page = _pageController.page ?? 0);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_page >= 1) {
          _goToPreviousPage();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SelectGraphTypePage(
                    onSelect: _onGraphType,
                    selectedType: _selectedType,
                  ),
                  GraphNamePage(
                    onSubmit: _onGraphName,
                    value: _graphName ?? "",
                  ),
                  FinishPage(
                    graphName: _graphName,
                    graphType: _selectedType,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 25,
              ),
              child: _continueButton(),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: BottomIndicator(numPages: numPages, page: _page),
            ),
          ],
        ),
      ),
    );
  }

  Widget _continueButton() {
    final finished = _page == numPages - 1;
    final enabled = _lastCompletedPage >= _page || finished;
    final onPressed = enabled ? _goToNextPage : null;

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: enabled
              ? const Color(0xff424ce4)
              : const Color(0xff424ce4).withOpacity(0.6),
        ),
        alignment: Alignment.center,
        child: Text(
          finished ? "Finish" : "Continue",
          style: Theme.of(context).textTheme.button?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }

  _goToNextPage() {
    if (_page == numPages - 1) {
      final graph = GraphService.graphFromType(_selectedType!, _graphName);
      final isarService = IsarService();
      isarService.saveGraph(graph).then(
            (_) => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => GraphPage(id: graph.id!)),
            ),
          );
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.decelerate,
      );
    }
  }

  _goToPreviousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.decelerate,
    );
  }

  _onGraphType(GraphType type) {
    setState(() {
      _selectedType = type;
      _lastCompletedPage = 0;
    });
  }

  _onGraphName(String name) {
    if (name.isNotEmpty) {
      setState(() {
        _graphName = name;
        _lastCompletedPage = 1;
      });
    }
  }
}
