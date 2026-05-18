import 'package:farmsmart_flutter/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'ArticleList.dart';

class ArticleListStyles {
  static ArticleListStyle buildForCommunity() =>
      buildForDiscover().copyWith(heroEnabled: false);

  static ArticleListStyle buildForDiscover() {
    return ArticleListStyle(
      titleTextStyle: AppTheme.displayTitle.copyWith(fontSize: 26),
      titleEdgePadding: const EdgeInsets.fromLTRB(20, 28, 20, 16),
      heroEnabled: true,
    );
  }
}
