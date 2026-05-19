import 'package:farmsmart_flutter/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

class _Constants {
  static const Color defaultCardBackgroundColor = Color(0xfff5f8fa);
  static final BorderRadius cardBorderRadius = BorderRadius.circular(12);
  static final EdgeInsets cardInnerPadding =
      EdgeInsets.only(left: 24, right: 30, top: 20, bottom: 22.5);
  static final EdgeInsets cardEdgePadding =
      EdgeInsets.only(left: 32, right: 32, top: 38.5);
  static final double imageLineSpace = 20;
  static final double titleLineSpace = 3;
  static final TextStyle titleTextStyle = AppTheme.bodyDark.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );
  static final int detailTextMaxLines = 2;
  static final TextStyle detailTextStyle = AppTheme.body.copyWith(
    fontSize: 13,
    color: AppTheme.grey,
  );
  static final double imageContainerSize = 40;
  static final EdgeInsets imageEdgePadding = EdgeInsets.all(6);
  static const Color imageContainerColor = Color(0xff25d366);
  static final double imageSize = 10;
}

class LinkBoxViewModel {
  final String titleText;
  final String detailText;
  final IconData icon;
  final VoidCallback onTap;
  final String image;

  LinkBoxViewModel({
    required this.titleText,
    required this.detailText,
    required this.icon,
    required this.onTap,
    required this.image,
  });
}

class LinkBoxStyle {
  final Color iconColor;
  final Color cardBackgroundColor;
  final Color imageContainerColor;

  const LinkBoxStyle({
    required this.iconColor,
    required this.cardBackgroundColor,
    required this.imageContainerColor,
  });

  LinkBoxStyle copyWith({
    Color? iconColor,
    Color? cardBackgroundColor,
    Color? imageContainerColor,
  }) {
    return LinkBoxStyle(
      iconColor: iconColor ?? this.iconColor,
      cardBackgroundColor: cardBackgroundColor ?? this.cardBackgroundColor,
      imageContainerColor: imageContainerColor ?? this.imageContainerColor,
    );
  }
}

class _DefaultStyle extends LinkBoxStyle {
  const _DefaultStyle()
      : super(
          iconColor: Colors.white,
          cardBackgroundColor: _Constants.defaultCardBackgroundColor,
          imageContainerColor: _Constants.imageContainerColor,
        );
}

const LinkBoxStyle _defaultStyle = _DefaultStyle();

class LinkBox extends StatelessWidget {
  final LinkBoxViewModel _viewModel;
  final LinkBoxStyle _style;

  const LinkBox({
    Key? key,
    required LinkBoxViewModel viewModel,
    LinkBoxStyle style = _defaultStyle,
  })  : this._viewModel = viewModel,
        this._style = style,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _Constants.cardEdgePadding,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _viewModel.onTap,
          borderRadius: _Constants.cardBorderRadius,
          child: Ink(
            decoration: BoxDecoration(
              color: _style.cardBackgroundColor,
              borderRadius: _Constants.cardBorderRadius,
              border: Border.all(color: AppTheme.border),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: _Constants.cardInnerPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ClipRRect(
                  borderRadius: _Constants.cardBorderRadius,
                  child: Container(
                    height: _Constants.imageContainerSize,
                    width: _Constants.imageContainerSize,
                    padding: _Constants.imageEdgePadding,
                    color: _style.imageContainerColor,
                    child: _buildImage(),
                  ),
                ),
                SizedBox(
                  width: _Constants.imageLineSpace,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _buildTitleText(),
                      SizedBox(
                        height: _Constants.titleLineSpace,
                      ),
                      _buildDetailText(),
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

  _buildImage() {
    return Image.asset(
      _viewModel.image,
      height: _Constants.imageSize,
      width: _Constants.imageSize,
    );
  }

  Text _buildTitleText() {
    return Text(
      _viewModel.titleText,
      style: _Constants.titleTextStyle,
    );
  }

  Text _buildDetailText() {
    return Text(
      _viewModel.detailText,
      maxLines: _Constants.detailTextMaxLines,
      overflow: TextOverflow.ellipsis,
      style: _Constants.detailTextStyle,
    );
  }
}
