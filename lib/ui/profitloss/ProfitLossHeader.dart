import 'package:farmsmart_flutter/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ProfitLossHeaderViewModel {
  String title;
  String detail;

  ProfitLossHeaderViewModel(this.title, this.detail);
}

class ProfitLossHeaderStyle {
  final TextStyle titleTextStyle;
  final TextStyle detailTextStyle;
  final TextStyle subtitleTextStyle;

  final EdgeInsets titleEdgePadding;
  final double detailTextSpacing;
  final int maxLines;

  ProfitLossHeaderStyle(
      {required this.titleTextStyle,
      required this.detailTextStyle,
      required this.subtitleTextStyle,
      required this.titleEdgePadding,
      required this.detailTextSpacing,
      required this.maxLines});

  factory ProfitLossHeaderStyle.defaultStyle() {
    return ProfitLossHeaderStyle(
        titleTextStyle: AppTheme.displayTitle.copyWith(fontSize: 32),
        detailTextStyle: AppTheme.bodyDark.copyWith(fontSize: 15),
        subtitleTextStyle: AppTheme.body.copyWith(
          color: AppTheme.accent,
          fontWeight: FontWeight.w600,
        ),
        titleEdgePadding: const EdgeInsets.all(24),
        detailTextSpacing: 16,
        maxLines: 2);
  }

  ProfitLossHeaderStyle copyWith(
      {TextStyle? titleTextStyle,
      TextStyle? detailTextStyle,
      TextStyle? subtitleTextStyle,
      EdgeInsets? titleEdgePadding,
      double? detailTextSpacing,
      int? maxLines}) {
    return ProfitLossHeaderStyle(
        titleTextStyle: titleTextStyle ?? this.titleTextStyle,
        detailTextStyle: detailTextStyle ?? this.detailTextStyle,
        subtitleTextStyle: subtitleTextStyle ?? this.subtitleTextStyle,
        titleEdgePadding: titleEdgePadding ?? this.titleEdgePadding,
        detailTextSpacing: detailTextSpacing ?? this.detailTextSpacing,
        maxLines: maxLines ?? this.maxLines);
  }
}

class ProfitLossHeader extends StatelessWidget {
  final ProfitLossHeaderViewModel _viewModel;
  final ProfitLossHeaderStyle _style;

  const ProfitLossHeader(
      {Key? key,
      required ProfitLossHeaderViewModel viewModel,
      required ProfitLossHeaderStyle style})
      : this._viewModel = viewModel,
        this._style = style,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 18),
      decoration: AppTheme.whiteCard(radius: AppTheme.radiusLg),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(_viewModel.title,
              style: _style.titleTextStyle,
              maxLines: _style.maxLines,
              overflow: TextOverflow.ellipsis),
          SizedBox(height: _style.detailTextSpacing),
          Text(_viewModel.detail,
              style: _style.detailTextStyle,
              maxLines: _style.maxLines,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  //FIXME: Out of scope for the moment
  /*
  static Widget _buildSubTitle(ProfitLossHeaderViewModel viewModel, ProfitLossHeaderStyle style) {
    return Container(
        child: GestureDetector(
          child: Text(
              viewModel.subtitle,
              style: style.subtitleTextStyle
          ),
          onTap: () {
            //FIXME: Add navigation to the next screen when finished
          },
        ));
  }
*/
}
