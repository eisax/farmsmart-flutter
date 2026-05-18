import 'dart:async';

import 'package:farmsmart_flutter/model/bloc/ViewModelProvider.dart';
import 'package:farmsmart_flutter/model/bloc/plot/PlotDetailProvider.dart';
import 'package:farmsmart_flutter/model/bloc/recommendations/RecommendationListProvider.dart';
import 'package:farmsmart_flutter/model/entities/PlotEntity.dart';
import 'package:farmsmart_flutter/model/entities/loading_status.dart';
import 'package:farmsmart_flutter/model/repositories/plot/PlotRepositoryInterface.dart';
import 'package:farmsmart_flutter/ui/myplot/PlotList.dart';
import 'package:farmsmart_flutter/ui/myplot/PlotListItem.dart';
import 'package:intl/intl.dart';

import 'PlotToPlotListItemViewModel.dart';

/*
       [Model]    ->               [Bloc]             -> [View]  
   [repo , model] -> [ViewModelProvider, Transformer] -> [viewModel, widget]
*/

class _LocalisedStrings {
  static String addCrop() => Intl.message('Add Another Crop');
}

class PlotListProvider implements ViewModelProvider<PlotListViewModel> {
  final PlotRepositoryInterface _plotRepo;
  final RecommendationListProvider _recommendationsProvider;
  final String _title;
  PlotListViewModel? _snapshot;

  PlotListProvider({
    required String title,
    required PlotRepositoryInterface plotRepository,
    required RecommendationListProvider recommendationsProvider,
  })  : _title = title,
        _plotRepo = plotRepository,
        _recommendationsProvider = recommendationsProvider;

  final StreamController<PlotListViewModel> _controller =
      StreamController<PlotListViewModel>.broadcast();

  @override
  Stream<PlotListViewModel> stream() {
    return _controller.stream;
  }

  @override
  PlotListViewModel snapshot() {
    return _snapshot!;
  }

  void dispose() {
    _controller.sink.close();
    _controller.close();
  }

  @override
  PlotListViewModel initial() {
    if (_snapshot == null) {
      _plotRepo.observeFarm().listen((articles) {
        _snapshot = _modelFromPlots(_controller, articles);
        _controller.sink.add(_snapshot!);
      });
      _snapshot = _viewModel(status: LoadingStatus.LOADING);
      _snapshot!.refresh();
    }
    return _snapshot!;
  }

  PlotListViewModel _modelFromPlots(
      StreamController controller, List<PlotEntity> plots) {
    final items = <PlotListItemViewModel>[];
    for (final plot in plots) {
      if (plot.stages.isEmpty) {
        continue;
      }
      final transformer =
          PlotToPlotListItemViewModel(PlotDetailProvider(plot, _plotRepo));
      items.add(transformer.transform(from: plot));
    }
    return _viewModel(
      status: LoadingStatus.SUCCESS,
      items: items,
    );
  }

  void _update(StreamController controller) {
    _signalLoading(controller);
    _plotRepo.getFarm();
  }

  void _signalLoading(StreamController controller) {
    controller.sink.add(_viewModel(status: LoadingStatus.LOADING));
  }

  PlotListViewModel _viewModel(
      {required LoadingStatus status, List<PlotListItemViewModel> items = const []}) {
    return PlotListViewModel(
      title: _title,
      buttonTitle: _LocalisedStrings.addCrop(),
      loadingStatus: status,
      items: items,
      refresh: () => _update(_controller),
      recommendationsProvider: _recommendationsProvider,
    );
  }
}
