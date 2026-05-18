import 'package:farmsmart_flutter/chat/ui/viewmodel/SelectableOptionViewModel.dart';

class SelectableOptionsViewModel {
  final int maxSelection;
  final List<SelectableOptionViewModel> options;

  SelectableOptionsViewModel({
    required this.options,
    required this.maxSelection,
  });
}
