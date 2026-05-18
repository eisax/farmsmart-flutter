import 'package:farmsmart_flutter/model/bloc/ViewModelProvider.dart';
import 'package:farmsmart_flutter/ui/common/ContextualAppBar.dart';
import 'package:farmsmart_flutter/ui/common/SectionListView.dart';
import 'package:farmsmart_flutter/ui/common/ViewModelProviderBuilder.dart';
import 'package:farmsmart_flutter/ui/crop/viewmodel/CropDetailViewModel.dart';
import 'package:farmsmart_flutter/ui/article/ArticleDetail.dart';
import 'package:flutter/material.dart';
import 'CropInfoList.dart';

class CropDetail extends StatelessWidget {
  static const analyticsName = 'crop_detail';
  final ViewModelProvider<CropDetailViewModel> _viewModelProvider;
  final Widget? _header;

  CropDetail({
    Key? key,
    required ViewModelProvider<CropDetailViewModel> provider,
    Widget? header,
  })  : this._viewModelProvider = provider,
        this._header = header,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final builder = ViewModelProviderBuilder(
      provider: _viewModelProvider,
      successBuilder: _buildSuccess,
    );
    return builder.build(context);
  }

  Widget _buildSuccess(
      {required BuildContext context,
      required AsyncSnapshot<CropDetailViewModel> snapshot}) {
    final viewModel = snapshot.data!;
    final article = ArticleDetail(
      viewModel: viewModel,
      articleHeader: _header,
      shouldShowArticleImage: (_header == null),
    );
    final infoItems = CropInfoList(items: viewModel.infoItems);
    final listBuilder = SectionedListView(
        sections: [ListViewWidgetSection(article), infoItems]);
    return Scaffold(
      appBar: _buildAppBar(context),
      body: listBuilder.build(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return ContextualAppBar(
      shareAction: null,
    );
  }
}
