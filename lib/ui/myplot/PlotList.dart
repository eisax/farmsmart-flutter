import 'package:farmsmart_flutter/model/analytics_interface.dart';
import 'package:farmsmart_flutter/model/bloc/ViewModelProvider.dart';
import 'package:farmsmart_flutter/model/entities/loading_status.dart';
import 'package:farmsmart_flutter/ui/common/LoadableViewModel.dart';
import 'package:farmsmart_flutter/ui/common/RefreshableViewModel.dart';
import 'package:farmsmart_flutter/ui/common/ViewModelProviderBuilder.dart';
import 'package:farmsmart_flutter/ui/common/empty_view.dart';
import 'package:farmsmart_flutter/ui/common/headerAndFooterListView.dart';
import 'package:farmsmart_flutter/ui/common/modal_navigator.dart';
import 'package:farmsmart_flutter/ui/common/roundedButton.dart';
import 'package:farmsmart_flutter/ui/recommendations/RecommentationsList.dart';
import 'package:farmsmart_flutter/ui/recommendations/viewmodel/RecommendationsListViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import '../features/farm_tools_hub.dart';
import '../home/weather_forecast_card.dart';
import '../theme/app_theme.dart';
import 'PlotDetail.dart';
import 'PlotListItem.dart';
import 'viewmodel/PlotDetailViewModel.dart';

class _LocalisedStrings {
  static String getStartedAddingYourPlot() =>
      Intl.message('Get started by adding to your plot');

  static String addToYourPlot() => Intl.message('Add to your Plot');

  static String myPlotSubtitle() =>
      Intl.message('Track growth stages and manage your active crops.');
}

class _Strings {
  static const emptyImagePath = 'assets/raw/illustration_empty.png';
}

class _Constants {
  static const double bottomHeightSpaceForStickButton = 100;
}

class _AnalyticsNames {
  static const addToPlot = 'add_to_plot';
}

class PlotListViewModel implements LoadableViewModel, RefreshableViewModel {
  final String title;
  final String buttonTitle;
  final LoadingStatus loadingStatus;
  final List<PlotListItemViewModel> items;
  final VoidCallback refresh;
  final ViewModelProvider<RecommendationsListViewModel> recommendationsProvider;

  PlotListViewModel({
    required String title,
    required String buttonTitle,
    required LoadingStatus loadingStatus,
    required List<PlotListItemViewModel> items,
    required VoidCallback refresh,
    required ViewModelProvider<RecommendationsListViewModel>
        recommendationsProvider,
  })  : this.title = title,
        this.loadingStatus = loadingStatus,
        this.buttonTitle = buttonTitle,
        this.items = items,
        this.refresh = refresh,
        this.recommendationsProvider = recommendationsProvider;
}

abstract class PlotListStyle {
  final Color primaryColor;

  final EdgeInsets edgePadding;
  final EdgeInsets titleEdgePadding;
  final EdgeInsets largeButtonEdgePadding;

  final TextStyle titleTextStyle;

  PlotListStyle(
    this.primaryColor,
    this.edgePadding,
    this.titleEdgePadding,
    this.largeButtonEdgePadding,
    this.titleTextStyle,
  );
}

class _DefaultStyle implements PlotListStyle {
  final Color primaryColor = AppTheme.accent;

  final EdgeInsets edgePadding = const EdgeInsets.only(top: 8.0);
  final EdgeInsets titleEdgePadding =
      const EdgeInsets.fromLTRB(20, 24, 20, 8);
  final EdgeInsets largeButtonEdgePadding =
      const EdgeInsets.fromLTRB(20, 16, 20, 32);

  final TextStyle titleTextStyle = AppTheme.displayTitle;

  const _DefaultStyle();
}

class PlotList extends StatefulWidget {
  final ViewModelProvider<PlotListViewModel> _viewModelProvider;
  final PlotListStyle _style;

  const PlotList({
    Key? key,
    required ViewModelProvider<PlotListViewModel> provider,
    PlotListStyle style = const _DefaultStyle(),
  })  : this._viewModelProvider = provider,
        this._style = style,
        super(key: key);

  @override
  _PlotListState createState() => _PlotListState();
}

class _PlotListState extends State<PlotList> {
  GlobalKey<State> topActionButtonVisibilityKey = GlobalKey();
  double actionButtonOpacity = 0.0;

  @override
  Widget build(BuildContext context) {
    return ViewModelProviderBuilder(
      provider: widget._viewModelProvider,
      successBuilder: _buildPage,
    );
  }

  Widget _buildPage({
    required BuildContext context,
    required AsyncSnapshot<PlotListViewModel> snapshot,
  }) {
    final viewModel = snapshot.data!;
    return viewModel.items.isNotEmpty
        ? _buildList(
            viewModel,
            context,
          )
        : _buildEmptyView(
            viewModel,
            context,
          );
  }

  Widget _buildEmptyView(PlotListViewModel viewModel, BuildContext context) {
    return Container(
      color: AppTheme.white,
      child: Column(
      children: <Widget>[
        _buildTitle(viewModel, widget._style, context: context),
        const WeatherForecastCard(),
        const FarmToolsHub(),
        Expanded(
          child: EmptyView(
            viewModel: EmptyViewViewModel(
              imagePath: _Strings.emptyImagePath,
              description: _LocalisedStrings.getStartedAddingYourPlot(),
              actionText: _LocalisedStrings.addToYourPlot(),
              action: () => _tappedAdd(
                context: context,
                provider: viewModel.recommendationsProvider,
              ),
            ),
          ),
        ),
      ],
    ),
    );
  }

  Widget _buildList(PlotListViewModel viewModel, BuildContext context) {
    return Container(
      color: AppTheme.white,
      child: Stack(
      children: <Widget>[
        NotificationListener<ScrollEndNotification>(
          onNotification: _onScrollNotification,
          child: HeaderAndFooterListView(
            itemCount: viewModel.items.length,
            itemBuilder: (BuildContext context, int index) {
              final itemViewModel = viewModel.items[index];
              final tapFunction = () {
                AnalyticsInterface.implementation().interaction(
                    PlotDetail.analyticsName,
                    context: itemViewModel.title);
                _tappedListItem(
                  context: context,
                  provider: itemViewModel.detailViewModelProvider,
                );
              };
              return PlotListItem().buildListItem(
                viewModel: viewModel.items[index],
                onTap: tapFunction,
              );
            },
            physics: ScrollPhysics(),
            shrinkWrap: true,
            headers: [
              _buildTitle(
                viewModel,
                widget._style,
                context: context,
              ),
              const WeatherForecastCard(),
              const FarmToolsHub(),
            ],
            footers: [
              SizedBox(
                height: _Constants.bottomHeightSpaceForStickButton,
              )
            ],
          ),
        ),
        _buildBottomActionButton(viewModel, context)
      ],
    ),
    );
  }

  bool _onScrollNotification(ScrollEndNotification scroll) {
    final topActionButtonCurrentContext =
        topActionButtonVisibilityKey.currentContext;

    if (topActionButtonCurrentContext == null) return false;

    final RenderObject? topActionRenderObject =
        topActionButtonCurrentContext.findRenderObject();
    if (topActionRenderObject == null) return false;

    final RenderAbstractViewport? viewport =
        RenderAbstractViewport.of(topActionRenderObject);
    if (viewport == null) return false;

    var offsetToRevealBottom =
        viewport.getOffsetToReveal(topActionRenderObject, 1.0);
    var offsetToRevealTop =
        viewport.getOffsetToReveal(topActionRenderObject, 0.0);

    if (offsetToRevealBottom.offset > scroll.metrics.pixels ||
        scroll.metrics.pixels > offsetToRevealTop.offset) {
      if (actionButtonOpacity == 0.0) {
        setState(() {
          actionButtonOpacity = 1.0;
        });
      }
    } else {
      if (actionButtonOpacity != 0.0) {
        setState(() {
          actionButtonOpacity = 0.0;
        });
      }
    }
    return false;
  }

  Container _buildBottomActionButton(
      PlotListViewModel viewModel, BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: widget._style.largeButtonEdgePadding,
        child: Row(
          children: <Widget>[
            Expanded(
              child: AnimatedOpacity(
                opacity: actionButtonOpacity,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeIn,
                child: RoundedButton(
                  viewModel: RoundedButtonViewModel(
                    title: viewModel.buttonTitle,
                    onTap: () => _tappedAdd(
                      context: context,
                      provider: viewModel.recommendationsProvider,
                    ),
                  ),
                  style: RoundedButtonStyle.largeRoundedButtonStyle(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(
    PlotListViewModel viewModel,
    PlotListStyle myPlotStyle, {
    required BuildContext context,
  }) {
    return Padding(
      padding: myPlotStyle.titleEdgePadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(viewModel.title, style: myPlotStyle.titleTextStyle),
                const SizedBox(height: 4),
                Text(_LocalisedStrings.myPlotSubtitle(), style: AppTheme.body),
              ],
            ),
          ),
          Material(
            color: AppTheme.black,
            borderRadius: BorderRadius.circular(AppTheme.radiusPill),
            child: InkWell(
              key: topActionButtonVisibilityKey,
              onTap: () => _tappedAdd(
                context: context,
                provider: viewModel.recommendationsProvider,
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusPill),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.add, color: AppTheme.white, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _tappedAdd({
    required BuildContext context,
    required ViewModelProvider<RecommendationsListViewModel> provider,
  }) {
    AnalyticsInterface.implementation().interaction(_AnalyticsNames.addToPlot);
    NavigationScope.presentModal(
      context,
      RecommendationsList(provider: provider),
    );
  }

  void _tappedListItem({
    required BuildContext context,
    required ViewModelProvider<PlotDetailViewModel> provider,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => PlotDetail(provider: provider),
          settings: RouteSettings(name: PlotDetail.analyticsName)),
    );
  }
}
