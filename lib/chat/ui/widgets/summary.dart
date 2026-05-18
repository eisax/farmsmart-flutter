import 'package:flutter/material.dart';

class SummaryStyle {
  final EdgeInsetsGeometry mainContainerMargin;
  final EdgeInsetsGeometry titleLabelMargin;
  final TextStyle titleLabelStyle;
  final TextAlign titleLabelAlignment;
  final EdgeInsetsGeometry subtitleMargin;
  final TextStyle subtitleStyle;
  final TextAlign subtitleAlignment;
  final EdgeInsetsGeometry bodyMargin;
  final TextStyle bodyStyle;
  final TextAlign bodyAlignment;
  final Decoration actionButtonDecoration;
  final double actionButtonHeight;
  final TextStyle actionButtonTextStyle;
  final int defaultMaxLines;

  const SummaryStyle({
    required this.mainContainerMargin,
    required this.titleLabelMargin,
    required this.titleLabelStyle,
    required this.titleLabelAlignment,
    required this.subtitleMargin,
    required this.subtitleStyle,
    required this.subtitleAlignment,
    required this.bodyMargin,
    required this.bodyStyle,
    required this.bodyAlignment,
    required this.actionButtonDecoration,
    required this.actionButtonHeight,
    required this.actionButtonTextStyle,
    required this.defaultMaxLines,
  });

  SummaryStyle copyWith({
    EdgeInsetsGeometry? mainContainerMargin,
    EdgeInsetsGeometry? titleLabelMargin,
    TextStyle? titleLabelStyle,
    TextAlign? titleLabelAlignment,
    EdgeInsetsGeometry? subtitleMargin,
    TextStyle? subtitleStyle,
    TextAlign? subtitleAlignment,
    EdgeInsetsGeometry? bodyMargin,
    TextStyle? bodyStyle,
    TextAlign? bodyAlignment,
    Decoration? actionButtonDecoration,
    double? actionButtonHeight,
    TextStyle? actionButtonTextStyle,
    int? defaultMaxLines,
  }) {
    return SummaryStyle(
      mainContainerMargin: mainContainerMargin ?? this.mainContainerMargin,
      titleLabelMargin: titleLabelMargin ?? this.titleLabelMargin,
      titleLabelStyle: titleLabelStyle ?? this.titleLabelStyle,
      titleLabelAlignment: titleLabelAlignment ?? this.titleLabelAlignment,
      subtitleMargin: subtitleMargin ?? this.subtitleMargin,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      subtitleAlignment: subtitleAlignment ?? this.subtitleAlignment,
      bodyMargin: bodyMargin ?? this.bodyMargin,
      bodyStyle: bodyStyle ?? this.bodyStyle,
      bodyAlignment: bodyAlignment ?? this.bodyAlignment,
      actionButtonDecoration:
          actionButtonDecoration ?? this.actionButtonDecoration,
      actionButtonHeight: actionButtonHeight ?? this.actionButtonHeight,
      actionButtonTextStyle:
          actionButtonTextStyle ?? this.actionButtonTextStyle,
      defaultMaxLines: defaultMaxLines ?? this.defaultMaxLines,
    );
  }
}

class _DefaultStyle extends SummaryStyle {
  final EdgeInsetsGeometry mainContainerMargin = const EdgeInsets.all(20.0);
  final EdgeInsetsGeometry titleLabelMargin = const EdgeInsets.only(top: 10);
  final TextStyle titleLabelStyle = const TextStyle(
    color: Color(0xFF9B9BAD),
    fontSize: 12.0,
  );
  final TextAlign titleLabelAlignment = TextAlign.center;
  final EdgeInsetsGeometry subtitleMargin = const EdgeInsets.only(top: 13);
  final TextStyle subtitleStyle = const TextStyle(
    color: Color(0xFF00CD9F),
    fontSize: 27,
    fontWeight: FontWeight.bold,
  );
  final TextAlign subtitleAlignment = TextAlign.center;
  final EdgeInsetsGeometry bodyMargin = const EdgeInsets.only(
    top: 27,
    bottom: 30,
  );
  final TextStyle bodyStyle = const TextStyle(
    fontSize: 15,
    color: Color(0xFF4C4C6D),
  );
  final TextAlign bodyAlignment = TextAlign.center;
  final Decoration actionButtonDecoration = const BoxDecoration(
    color: Color(0xFF00CD9F),
    borderRadius: BorderRadius.all(Radius.circular(9)),
  );
  final double actionButtonHeight = 50.0;
  final TextStyle actionButtonTextStyle = const TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 15,
  );
  final int defaultMaxLines = 1;

  const _DefaultStyle()
      : super(
          mainContainerMargin: const EdgeInsets.all(20.0),
          titleLabelMargin: const EdgeInsets.only(top: 10),
          titleLabelStyle: const TextStyle(
            color: Color(0xFF9B9BAD),
            fontSize: 12.0,
          ),
          titleLabelAlignment: TextAlign.center,
          subtitleMargin: const EdgeInsets.only(top: 13),
          subtitleStyle: const TextStyle(
            color: Color(0xFF00CD9F),
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
          subtitleAlignment: TextAlign.center,
          bodyMargin: const EdgeInsets.only(
            top: 27,
            bottom: 30,
          ),
          bodyStyle: const TextStyle(
            fontSize: 15,
            color: Color(0xFF4C4C6D),
          ),
          bodyAlignment: TextAlign.center,
          actionButtonDecoration: const BoxDecoration(
            color: Color(0xFF00CD9F),
            borderRadius: BorderRadius.all(Radius.circular(9)),
          ),
          actionButtonHeight: 50.0,
          actionButtonTextStyle: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 15,
          ),
          defaultMaxLines: 1,
        );
}

const SummaryStyle _defaultStyle = _DefaultStyle();

class Summary extends StatelessWidget {
  final SummaryStyle _style;
  final SummaryViewModel _viewModel;
  final VoidCallback _onTap;

  Summary({
    required SummaryViewModel viewModel,
    SummaryStyle style = _defaultStyle,
    VoidCallback? onTap,
  })  : this._viewModel = viewModel,
        this._style = style,
        this._onTap = onTap ?? (() => {});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: _style.mainContainerMargin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildTitle(),
          _buildSubtitle(),
          _buildBodyText(),
          _buildButton()
        ],
      ),
    );
  }

  _buildTitle() {
    return Container(
      margin: _style.titleLabelMargin,
      child: Text(
        _viewModel.titleText,
        textAlign: _style.titleLabelAlignment,
        maxLines: _style.defaultMaxLines,
        style: _style.titleLabelStyle,
      ),
    );
  }

  _buildSubtitle() {
    return Container(
      margin: _style.subtitleMargin,
      child: Text(
        _viewModel.titleValue,
        textAlign: _style.subtitleAlignment,
        maxLines: _style.defaultMaxLines,
        style: _style.subtitleStyle,
      ),
    );
  }

  _buildBodyText() {
    return Container(
      margin: _style.bodyMargin,
      child: Text(
        _viewModel.bodyText,
        textAlign: _style.bodyAlignment,
        style: _style.bodyStyle,
      ),
    );
  }

  _buildButton() {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        decoration: _style.actionButtonDecoration,
        height: _style.actionButtonHeight,
        child: Center(
          child: Text(
            _viewModel.actionText,
            style: _style.actionButtonTextStyle,
          ),
        ),
      ),
    );
  }
}

class SummaryViewModel {
  final String titleText;
  final String titleValue;
  final String bodyText;
  final String actionText;

  SummaryViewModel({
    this.titleText = '',
    this.titleValue = '',
    this.bodyText = '',
    this.actionText = '',
  });
}
