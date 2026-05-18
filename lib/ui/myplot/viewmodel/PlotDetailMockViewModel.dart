import 'package:farmsmart_flutter/model/bloc/article/ArticleDetailTransformer.dart';
import 'package:farmsmart_flutter/model/bloc/StaticViewModelProvider.dart';
import 'package:farmsmart_flutter/model/bloc/plot/StageToStageCardViewModel.dart';
import 'package:farmsmart_flutter/model/entities/mock/MockPlot.dart';
import 'package:farmsmart_flutter/model/entities/mock/MockString.dart';
import 'package:farmsmart_flutter/model/repositories/MockStrings.dart';
import 'package:farmsmart_flutter/model/repositories/image/implementation/MockImageEntity.dart';
import 'package:farmsmart_flutter/ui/common/stage_card.dart';
import 'package:farmsmart_flutter/ui/crop/viewmodel/CropDetailViewModel.dart';
import 'package:farmsmart_flutter/ui/myplot/viewmodel/PlotDetailViewModel.dart';

class MockPlotDetailViewModel {
  static PlotDetailViewModel build() {
    final plotEntity = MockPlotEntity().build();
    final stages = plotEntity.stages;
    final cardTransformer = StageToStageCardViewModel(
      plotEntity,
      (_, __) {},
      (_, __) {},
      (_, __) {},
    );
    final articleTransformer = ArticleDetailViewModelTransformer(
      relatedTitle: '',
      contentLinkTitle: '',
      contentLinkDescription: '',
      contentLinkIcon: '',
    );
    final List<StageCardViewModel> cardViewModels = stages.map((stage) {
      return cardTransformer.transform(from: stage);
    }).toList();
    final articleViewModels = stages.map((stage) {
      return articleTransformer.transform(from: stage.article);
    }).toList();
    final detailProvider = StaticViewModelProvider(
      CropDetailViewModel.fromArticle(
        articleViewModels.first,
        [],
      ),
    );

    return PlotDetailViewModel(
      title: mockTitleText.random(),
      detailText: _days.randomIndexed(text: "Day", limit: 365),
      progress: 0.5,
      imageProvider: MockImageEntity().build().urlProvider,
      stageCardViewModels: cardViewModels,
      stageArticleViewModels: articleViewModels,
      currentStage: 1,
      rename: (_) {},
      remove: () {},
      detailProvider: detailProvider,
    );
  }
}

MockString _days = MockString(library: ["Day 1", "Day 2", "Day 3", "Day 4"]);
