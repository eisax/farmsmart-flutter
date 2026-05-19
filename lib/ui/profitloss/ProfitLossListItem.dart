import 'package:farmsmart_flutter/ui/common/Dogtag.dart';
import 'package:farmsmart_flutter/ui/profitloss/RecordTransaction.dart';
import 'package:farmsmart_flutter/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ProfitLossListItemViewModel {
  final String? title;
  final String? subtitle;
  final String? detail;

  final RecordTransactionViewModel? detailViewModel;
  final DogTagStyle? style;

  ProfitLossListItemViewModel(
      {this.title,
      this.subtitle,
      this.detail,
      this.style,
      this.detailViewModel});
}

class ProfitLossItemStyle {
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final EdgeInsets? edgePadding;
  final double? elevation;
  final double? detailLineSpace;
  final double? titleLineSpace;
  final int? maxLines;

  ProfitLossItemStyle(
      {this.titleStyle,
      this.subtitleStyle,
      this.edgePadding,
      this.elevation,
      this.detailLineSpace,
      this.titleLineSpace,
      this.maxLines});

  factory ProfitLossItemStyle.defaultStyle() {
    return ProfitLossItemStyle(
        titleStyle: AppTheme.caption
            .copyWith(fontWeight: FontWeight.w500, color: AppTheme.greyLight),
        subtitleStyle: AppTheme.bodyDark
            .copyWith(fontWeight: FontWeight.w600, color: AppTheme.black),
        edgePadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        elevation: 0.0,
        detailLineSpace: 14,
        maxLines: 1,
        titleLineSpace: 6);
  }

  ProfitLossItemStyle copyWith(
      {TextStyle? titleStyle,
      TextStyle? subtitleStyle,
      EdgeInsets? edgePadding,
      double? elevation,
      double? detailLineSpace,
      double? titleLineSpace,
      int? maxLines}) {
    return ProfitLossItemStyle(
        titleStyle: titleStyle ?? this.titleStyle,
        subtitleStyle: subtitleStyle ?? this.subtitleStyle,
        edgePadding: edgePadding ?? this.edgePadding,
        elevation: elevation ?? this.elevation,
        detailLineSpace: detailLineSpace ?? this.detailLineSpace,
        maxLines: maxLines ?? this.maxLines,
        titleLineSpace: titleLineSpace ?? this.titleLineSpace);
  }
}

class ProfitLossListItem extends StatelessWidget {
  final ProfitLossListItemViewModel _viewModel;
  final ProfitLossItemStyle _style;

  const ProfitLossListItem({
    Key? key,
    required ProfitLossListItemViewModel viewModel,
    required ProfitLossItemStyle style,
  })  : this._viewModel = viewModel,
        this._style = style,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToDetail(context, _viewModel.detailViewModel),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          child: Ink(
            decoration: AppTheme.whiteCard(radius: AppTheme.radiusMd),
            child: Padding(
              padding: _style.edgePadding ?? EdgeInsets.zero,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildMainTextView(_viewModel, _style),
                    SizedBox(width: _style.detailLineSpace ?? 0),
                    DogTag(
                      viewModel:
                          DogTagViewModel(number: _viewModel.detail ?? ''),
                      style: _viewModel.style,
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

void _navigateToDetail(
    BuildContext context, RecordTransactionViewModel? viewModel) {
  if (viewModel != null) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            RecordTransaction(viewModel: viewModel, key: UniqueKey()),
        settings: RouteSettings(name: RecordTransaction.analyticsName),
      ),
    );
  }
}

_buildMainTextView(
    ProfitLossListItemViewModel viewModel, ProfitLossItemStyle style) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(viewModel.title ?? '',
            style: style.titleStyle,
            maxLines: style.maxLines,
            overflow: TextOverflow.ellipsis),
        SizedBox(height: style.titleLineSpace ?? 0),
        Text(viewModel.subtitle ?? '',
            style: style.subtitleStyle,
            maxLines: style.maxLines,
            overflow: TextOverflow.ellipsis)
      ],
    ),
  );
}
