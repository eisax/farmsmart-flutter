import 'package:flutter/material.dart';
import 'package:farmsmart_flutter/model/bloc/ViewModelProvider.dart';
import 'package:farmsmart_flutter/model/entities/loading_status.dart';
import 'package:farmsmart_flutter/ui/common/LoadableViewModel.dart';
import 'package:farmsmart_flutter/ui/common/RefreshableViewModel.dart';
import 'package:farmsmart_flutter/ui/crop/viewmodel/CropDetailViewModel.dart';
import 'package:farmsmart_flutter/ui/recommendations/recommendation_card/recommendation_card_view_model.dart';

typedef BoolFunction = bool Function();
typedef DetailProviderFunction = ViewModelProvider<CropDetailViewModel>
    Function();

class RecommendationsListViewModel
    implements RefreshableViewModel, LoadableViewModel {
  static final error = RecommendationsListViewModel(
    title: '',
    loadingStatus: LoadingStatus.ERROR,
    items: [],
    refresh: () {},
    apply: () {},
    clear: () {},
    canApply: false,
  );

  final String title;
  final LoadingStatus loadingStatus;
  final List<RecommendationCardViewModel> items;
  final VoidCallback refresh;
  final VoidCallback apply;
  final VoidCallback clear;
  final bool canApply;

  RecommendationsListViewModel({
    required this.title,
    required this.loadingStatus,
    required this.items,
    required this.refresh,
    required this.apply,
    required this.clear,
    required this.canApply,
  });
}
