import 'package:flutter/material.dart';
import 'package:walewein/pages/add_graph/pages/finish/finish_page.dart';
import 'package:walewein/pages/add_graph/pages/graph_name/graph_name_page.dart';
import 'package:walewein/shared/components/constants.dart';
import 'package:walewein/shared/components/view_model_builder.dart';
import 'package:walewein/view_models/add_graph_view_model.dart';
import 'components/bottom_indicator.dart';
import 'pages/graph_type/select_graph_type_page.dart';

class AddGraphPage extends StatelessWidget {
  const AddGraphPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder(
      viewModel: AddGraphViewModel(context),
      view: _view,
    );
  }

  WillPopScope _view(AddGraphViewModel model) {
    return WillPopScope(
      onWillPop: model.willPop,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              if (model.page >= 1) {
                model.goToPreviousPage();
              } else {
                Navigator.of(model.context).pop();
              }
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: model.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SelectGraphTypePage(
                    onSelect: model.onGraphType,
                    selectedType: model.selectedType,
                  ),
                  GraphNamePage(
                    onChange: model.onGraphName,
                    value: model.graphName ?? "",
                  ),
                  FinishPage(
                    graphName: model.graphName,
                    graphType: model.selectedType,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 25,
              ),
              child: _continueButton(model),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: BottomIndicator(
                  numPages: AddGraphViewModel.numPages, page: model.page),
            ),
          ],
        ),
      ),
    );
  }

  Widget _continueButton(AddGraphViewModel model) {
    return GestureDetector(
      onTap: model.onPressContinueButton(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: defaultButtonBorderRadius,
          color: model.continueButtonColor(),
        ),
        alignment: Alignment.center,
        child: Text(
          model.isFinished() ? "Finish" : "Continue",
          style: Theme.of(model.context).textTheme.button?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
