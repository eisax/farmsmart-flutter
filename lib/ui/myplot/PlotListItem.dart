import 'package:farmsmart_flutter/model/bloc/ViewModelProvider.dart';
import 'package:farmsmart_flutter/model/entities/ImageURLProvider.dart';
import 'package:farmsmart_flutter/ui/common/CircularProgress.dart';
import 'package:farmsmart_flutter/ui/common/DogTagStyles.dart';
import 'package:farmsmart_flutter/ui/common/Dogtag.dart';
import 'package:farmsmart_flutter/ui/common/image_provider_view.dart';
import 'package:farmsmart_flutter/ui/myplot/viewmodel/PlotDetailViewModel.dart';
import 'package:farmsmart_flutter/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

class PlotListItemViewModel {
  final String title;
  final String subtitle;
  final String detail;
  final double progress;
  final ImageURLProvider imageProvider;
  final ViewModelProvider<PlotDetailViewModel> detailViewModelProvider;

  PlotListItemViewModel({
    required String title,
    required String subtitle,
    required String detail,
    required double progress,
    required ImageURLProvider imageProvider,
    required ViewModelProvider<PlotDetailViewModel> provider,
  })  : this.title = title,
        this.subtitle = subtitle,
        this.detail = detail,
        this.progress = progress,
        this.imageProvider = imageProvider,
        this.detailViewModelProvider = provider;
}

abstract class PlotListItemStyle {
  final Color primaryColor;
  final Color dividerColor;
  final Color detailTextBackgroundColor;
  final Color overlayColor;
  final EdgeInsets edgePadding;
  final EdgeInsets detailTextEdgePadding;
  final EdgeInsets dividerEdgePadding;
  final EdgeInsets cardEdgePadding;
  final BorderRadius detailTextBorderRadius;
  final TextStyle detailTextStyle;
  final TextStyle titleTextStyle;
  final TextStyle subtitleTextStyle;
  final double elevation;
  final double imageSize;
  final double headingLineSpace;
  final double detailLineSpace;
  final double imageLineSpace;
  final int maxLineText;
  final double circularSize;
  final double circularLineWidth;

  PlotListItemStyle(
    this.primaryColor,
    this.dividerColor,
    this.edgePadding,
    this.detailTextEdgePadding,
    this.dividerEdgePadding,
    this.detailTextBorderRadius,
    this.detailTextStyle,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.elevation,
    this.cardEdgePadding,
    this.imageSize,
    this.detailTextBackgroundColor,
    this.detailLineSpace,
    this.headingLineSpace,
    this.overlayColor,
    this.imageLineSpace,
    this.maxLineText,
    this.circularSize,
    this.circularLineWidth,
  );
}

class _DefaultStyle implements PlotListItemStyle {
  final Color primaryColor = AppTheme.accent;
  final Color dividerColor = AppTheme.border;
  final Color detailTextBackgroundColor = AppTheme.offWhite;
  final Color overlayColor = const Color(0x0A000000);

  final EdgeInsets detailTextEdgePadding =
      const EdgeInsets.symmetric(horizontal: 10, vertical: 4);
  final EdgeInsets dividerEdgePadding = EdgeInsets.zero;
  final EdgeInsets cardEdgePadding =
      const EdgeInsets.symmetric(horizontal: 20, vertical: 6);
  final EdgeInsets edgePadding =
      const EdgeInsets.symmetric(horizontal: 16, vertical: 16);

  final TextStyle subtitleTextStyle = AppTheme.body;
  final TextStyle detailTextStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppTheme.accent,
  );
  final TextStyle titleTextStyle = const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppTheme.black,
  );

  final BorderRadius detailTextBorderRadius =
      const BorderRadius.all(Radius.circular(12));

  final double elevation = 0.0;
  final double imageSize = 72.0;
  final double headingLineSpace = 4;
  final double detailLineSpace = 8;
  final double imageLineSpace = 16;
  final int maxLineText = 1;
  final double circularSize = 80;
  final double circularLineWidth = 2;

  const _DefaultStyle();
}

class PlotListItem {
  Widget buildListItem({
    required PlotListItemViewModel viewModel,
    required VoidCallback onTap,
    PlotListItemStyle itemStyle = const _DefaultStyle(),
    bool needDivider = true,
  }) {
    return Padding(
      padding: itemStyle.cardEdgePadding,
      child: Material(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          child: Ink(
            decoration: AppTheme.whiteCard(radius: AppTheme.radiusLg),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: itemStyle.edgePadding,
                    child: _buildMainTextView(viewModel, itemStyle),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _buildPlotImage(viewModel.imageProvider, itemStyle),
                      CircularProgress(
                        progress: viewModel.progress,
                        lineWidth: itemStyle.circularLineWidth,
                        size: itemStyle.circularSize,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainTextView(
      PlotListItemViewModel viewModel, PlotListItemStyle itemStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          viewModel.title,
          maxLines: itemStyle.maxLineText,
          overflow: TextOverflow.ellipsis,
          style: itemStyle.titleTextStyle,
        ),
        SizedBox(height: itemStyle.headingLineSpace),
        Text(
          viewModel.subtitle,
          maxLines: itemStyle.maxLineText,
          overflow: TextOverflow.ellipsis,
          style: itemStyle.subtitleTextStyle,
        ),
        SizedBox(height: itemStyle.detailLineSpace),
        DogTag(
          viewModel: DogTagViewModel(title: viewModel.detail),
          style: DogTagStyles.compactStyle(),
        ),
      ],
    );
  }

  ClipOval _buildPlotImage(
      ImageURLProvider imageProvider, PlotListItemStyle itemStyle) {
    return ClipOval(
      child: SizedBox(
        height: itemStyle.imageSize,
        width: itemStyle.imageSize,
        child: ImageProviderView(
          imageURLProvider: imageProvider,
          height: itemStyle.imageSize,
          width: itemStyle.imageSize,
        ),
      ),
    );
  }
}
