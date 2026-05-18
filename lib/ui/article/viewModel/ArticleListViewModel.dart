import 'package:flutter/material.dart';
import 'package:farmsmart_flutter/model/entities/loading_status.dart';
import 'package:farmsmart_flutter/ui/common/LoadableViewModel.dart';
import 'package:farmsmart_flutter/ui/common/RefreshableViewModel.dart';
import 'package:farmsmart_flutter/ui/article/viewModel/ArticleListItemViewModel.dart';

class ArticleListViewModel implements LoadableViewModel, RefreshableViewModel {
  final String title;
  final LoadingStatus loadingStatus;

  final List<ArticleListItemViewModel> articleListItemViewModels;
  final VoidCallback refresh;

  ArticleListViewModel({
    required this.title,
    required LoadingStatus status,
    required this.articleListItemViewModels,
    required this.refresh,
  }) : this.loadingStatus = status;
}
