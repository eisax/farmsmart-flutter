import 'package:farmsmart_flutter/model/bloc/ViewModelProvider.dart';
import 'package:farmsmart_flutter/model/entities/ImageURLProvider.dart';
import 'package:farmsmart_flutter/ui/common/stage_card.dart';
import 'package:farmsmart_flutter/ui/crop/viewmodel/CropDetailViewModel.dart';
import 'package:farmsmart_flutter/ui/article/viewModel/ArticleDetailViewModel.dart';
import 'package:flutter/widgets.dart';

class PlotDetailViewModel {
  final String title;
  final String detailText;
  final double progress;
  final ImageURLProvider imageProvider;
  final List<StageCardViewModel> stageCardViewModels;
  final List<ArticleDetailViewModel> stageArticleViewModels;
  final int currentStage;
  final void Function(String) rename;
  final VoidCallback remove;
  final ViewModelProvider<CropDetailViewModel> detailProvider;

  PlotDetailViewModel({
    required this.title,
    required this.detailText,
    required this.progress,
    required this.imageProvider,
    required this.stageCardViewModels,
    required this.stageArticleViewModels,
    required this.currentStage,
    required this.rename,
    required this.remove,
    required this.detailProvider,
  });
}
