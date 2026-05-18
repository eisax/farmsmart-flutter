import 'package:farmsmart_flutter/model/bloc/article/ArticleListProvider.dart';
import 'package:farmsmart_flutter/model/bloc/home/HomeViewModelProvider.dart';
import 'package:farmsmart_flutter/model/bloc/plot/PlotListProvider.dart';
import 'package:farmsmart_flutter/model/bloc/profile/ProfileDetailProvider.dart';
import 'package:farmsmart_flutter/model/bloc/recommendations/RecommendationListProvider.dart';
import 'package:farmsmart_flutter/model/bloc/transactions/ProfitLossListProvider.dart';
import 'package:farmsmart_flutter/model/repositories/article/ArticleRepositoryInterface.dart';
import 'package:farmsmart_flutter/model/repositories/repository_provider.dart';
import 'package:farmsmart_flutter/ui/article/ArticleList.dart';
import 'package:farmsmart_flutter/ui/bottombar/persistent_bottom_navigation_bar.dart';
import 'package:farmsmart_flutter/ui/bottombar/tab_navigator.dart';
import 'package:farmsmart_flutter/ui/common/ViewModelProviderBuilder.dart';
import 'package:farmsmart_flutter/ui/playground/data/playground_datasource_impl.dart';
import 'package:farmsmart_flutter/ui/playground/playground_view.dart';
import 'package:farmsmart_flutter/ui/profile/Profile.dart';
import 'package:farmsmart_flutter/ui/profitloss/ProfitLossList.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'article/ArticleListStyles.dart';
import 'theme/app_theme.dart';
import 'common/ProfileAvatar.dart';
import 'myplot/PlotList.dart';

class _Constants {
  static final double bottomBarIconSize = 24;
  static final double iconSize = 28;
  static final Color bottomBarColor = AppTheme.white;

  static final myPlotSelectedIcon = 'assets/icons/my_plot_selected.png';
  static final myPlotIcon = 'assets/icons/my_plot.png';
  static final profitLossSelectedIcon = 'assets/icons/profit_loss_selected.png';
  static final profitLossIcon = 'assets/icons/profit_loss.png';
  static final discoverSelectedIcon = 'assets/icons/discover_selected.png';
  static final discoverIcon = 'assets/icons/discover.png';
  static final communitySelectedIcon = 'assets/icons/community_selected.png';
  static final communityIcon = 'assets/icons/community.png';
}

class _LocalisedStrings {
  static relatedArticles() => Intl.message('Related articles');

  static relatedGroups() => Intl.message('Related groups');

  static recommendations() => Intl.message('Recommendations');

  static myPlot() => Intl.message('My Plot');

  static discover() => Intl.message('Discover');

  static community() => Intl.message('Community');

  static viewMore() => Intl.message('Read full article');

  static discoverMuchMore() =>
      Intl.message('Practical guides for Zimbabwe natural regions and markets.');

  static joinWhatsAppGroup() =>
      Intl.message('Tap a group to connect with farmers in your province.');
}

class _AnalyticsNames {
  static const myPlot = 'my_plot_tab';
  static const profitAndLoss = 'profit_and_loss_tab';
  static const discover = 'discover_tab';
  static const community = 'community_tab';
  static const profile = 'profile_tab';
  static const debug = 'debug_tab';
}

class _Icons {
  static final whatsApp = 'assets/icons/WhatsApp_Logo_short.png';
}

class Home extends StatelessWidget {
  final RepositoryProvider repositoryProvider;
  final HomeViewModelProvider homeViewModelProvider;

  Home({
    Key? key,
    required this.repositoryProvider,
    required this.homeViewModelProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProviderBuilder(
      provider: homeViewModelProvider,
      successBuilder: _buildSuccess,
    );
  }

  Widget _buildSuccess(
      {required BuildContext context,
      required AsyncSnapshot<HomeViewModel> snapshot}) {
    return PersistentBottomNavigationBar(
      backgroundColor: _Constants.bottomBarColor,
      selectedItemColor: AppTheme.accent,
      unselectedItemColor: AppTheme.greyLight,
      tabs: tabs(snapshot.data!),
    );
  }

  List<TabNavigator> tabs(HomeViewModel viewModel) {
    final tabList = [
      _buildTabNavigator(
        _buildMyPlot(viewModel),
        _Constants.myPlotSelectedIcon,
        _Constants.myPlotIcon,
        _AnalyticsNames.myPlot,
        _LocalisedStrings.myPlot(),
      ),
      _buildTabNavigator(
        _buildProfitAndLoss(viewModel),
        _Constants.profitLossSelectedIcon,
        _Constants.profitLossIcon,
        _AnalyticsNames.profitAndLoss,
        'P&L',
      ),
      _buildTabNavigator(
        _buildDiscover(),
        _Constants.discoverSelectedIcon,
        _Constants.discoverIcon,
        _AnalyticsNames.discover,
        _LocalisedStrings.discover(),
      ),
      _buildTabNavigator(
        _buildCommunity(),
        _Constants.communitySelectedIcon,
        _Constants.communityIcon,
        _AnalyticsNames.community,
        _LocalisedStrings.community(),
      ),
      _buildTabNavigatorWithCircleImageWidget(
          _buildUserProfile(viewModel), viewModel),
    ];

    if (viewModel.debugMenuVisible) {
      tabList.add(
        _buildDebugTabNavigator(
          _buildPlayground(),
        ),
      );
    }

    return tabList;
  }

  Widget _buildMyPlot(HomeViewModel viewModel) {
    final recommendationsProvider = RecommendationListProvider(
      title: _LocalisedStrings.recommendations(),
      heroThreshold: 0.8,
      plotRepo:
          repositoryProvider.getMyPlotRepository(viewModel.currentProfile),
      cropRepo: repositoryProvider.getCropRepository(),
      profileRepo: viewModel.currentProfile,
      ratingRepo: repositoryProvider.getRatingsRepository(),
    );
    return PlotList(
        provider: PlotListProvider(
            title: _LocalisedStrings.myPlot(),
            plotRepository: repositoryProvider
                .getMyPlotRepository(viewModel.currentProfile),
            recommendationsProvider: recommendationsProvider));
  }

  _buildProfitAndLoss(HomeViewModel viewModel) {
    return ProfitLossPage(
      key: const Key('profit_loss'),
      viewModelProvider: ProfitLossListProvider(
        transactionsRepository: repositoryProvider
            .getTransactionRepository(viewModel.currentProfile),
        plotRepository:
            repositoryProvider.getMyPlotRepository(viewModel.currentProfile),
      ),
    );
  }

  _buildDiscover() {
    return ArticleList(
      style: ArticleListStyles.buildForDiscover(),
      viewModelProvider: ArticleListProvider(
        title: _LocalisedStrings.discover(),
        repository: repositoryProvider.getArticleRepository(),
        group: ArticleCollectionGroup.discovery,
        relatedTitle: _LocalisedStrings.relatedArticles(),
        contentLinkTitle: _LocalisedStrings.viewMore(),
        contentLinkDescription: _LocalisedStrings.discoverMuchMore(),
        contentLinkIcon: '',
      ),
    );
  }

  _buildCommunity() {
    return ArticleList(
      style: ArticleListStyles.buildForCommunity(),
      viewModelProvider: ArticleListProvider(
        title: _LocalisedStrings.community(),
        repository: repositoryProvider.getArticleRepository(),
        group: ArticleCollectionGroup.chatGroups,
        relatedTitle: _LocalisedStrings.relatedGroups(),
        contentLinkTitle: _LocalisedStrings.community(),
        contentLinkDescription: _LocalisedStrings.joinWhatsAppGroup(),
        contentLinkIcon: _Icons.whatsApp,
      ),
    );
  }

  _buildUserProfile(HomeViewModel viewModel) {
    return Profile(
      provider: ProfileDetailProvider(
        accountRepo: viewModel.currentAccount,
        plotRepo:
            repositoryProvider.getMyPlotRepository(viewModel.currentProfile),
        localeRepo: repositoryProvider.getLocaleRepository(),
        downloader: repositoryProvider.getDownloader(),
      ),
    );
  }

  _buildPlayground() {
    return PlaygroundView(
      widgetList: PlaygroundDataSourceImpl().getList(),
    );
  }

  TabNavigator _buildTabNavigator(
    Widget page,
    String activeIconPath,
    String iconPath,
    String analyticsName,
    String label,
  ) {
    return TabNavigator(
      child: page,
      barItem: BottomNavigationBarItem(
        activeIcon: Image.asset(
          activeIconPath,
          height: _Constants.bottomBarIconSize,
        ),
        icon: Image.asset(
          iconPath,
          height: _Constants.bottomBarIconSize,
        ),
        label: label,
      ),
      analyticsName: analyticsName,
    );
  }

  TabNavigator _buildDebugTabNavigator(
    Widget page,
  ) {
    return TabNavigator(
      child: page,
      barItem: BottomNavigationBarItem(
        activeIcon: Text(
          'Debug',
          style: TextStyle(color: AppTheme.accent),
        ),
        icon: Text('Debug'),
        label: '',
      ),
      analyticsName: _AnalyticsNames.debug,
    );
  }

  Widget _buildProfileIcon(HomeViewModel viewModel) {
    return ProfileAvatar(
      viewModelProvider: ProfileDetailProvider(
          accountRepo: viewModel.currentAccount,
          plotRepo:
              repositoryProvider.getMyPlotRepository(viewModel.currentProfile),
          localeRepo: repositoryProvider.getLocaleRepository(),
          downloader: repositoryProvider.getDownloader()),
      width: _Constants.iconSize,
      height: _Constants.iconSize,
    );
  }

  TabNavigator _buildTabNavigatorWithCircleImageWidget(
      Widget page, HomeViewModel viewModel) {
    final profileIcon = _buildProfileIcon(viewModel);
    return TabNavigator(
      child: page,
      barItem: BottomNavigationBarItem(
        activeIcon: Container(
          decoration: BoxDecoration(
            color: AppTheme.black,
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.accent, width: 2),
          ),
          padding: const EdgeInsets.all(2),
          height: _Constants.iconSize,
          width: _Constants.iconSize,
          child: profileIcon,
        ),
        icon: Container(
          height: _Constants.iconSize,
          width: _Constants.iconSize,
          child: profileIcon,
        ),
        label: 'Profile',
      ),
      analyticsName: _AnalyticsNames.profile,
    );
  }
}
