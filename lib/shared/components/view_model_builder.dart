import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ViewModelBuilder<T extends ViewModel> extends StatefulWidget {
  const ViewModelBuilder({
    super.key,
    required this.viewModel,
    required this.view,
  });

  final T viewModel;
  final Widget Function(T model) view;

  @override
  State<ViewModelBuilder<T>> createState() => _ViewModelBuilder();
}

class _ViewModelBuilder<T extends ViewModel> extends State<ViewModelBuilder<T>>
    with WidgetsBindingObserver {
  late T _vm;

  @override
  void initState() {
    super.initState();
    _vm = widget.viewModel;
    _vm.init();

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _vm.onMount());
  }

  @override
  void dispose() {
    super.dispose();
    _vm.onDisMount();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (_) => _vm,
      child: Consumer<T>(builder: (context, vm, _) => widget.view(vm)),
    );
  }
}

abstract class ViewModel<T> extends ChangeNotifier {
  final BuildContext context;

  bool loaded = false;

  ViewModel(this.context);

  /// Use this method to asynchronously load the required data
  Future<void> init();

  ///
  void onMount() {}

  /// Called
  void onDisMount() {}

  /// Use this method to set the models properties, after loading the data inside [init]
  ///
  /// super.setState sets [loading] to [true] and notifies listeners
  void setState([T? model]) {
    loaded = true;
    notifyListeners();
  }
}
