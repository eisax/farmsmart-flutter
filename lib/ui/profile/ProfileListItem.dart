import 'package:farmsmart_flutter/ui/common/Alert.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class _LocalisedStrings {
  static cancelAction() => Intl.message('Cancel');
  static confirmAction() => Intl.message('Confirm');

  static dialogDescription() =>
      Intl.message('Are you sure you would like to complete this action?');
}

class _Constants {
  static final String arrowIcon = "assets/icons/chevron.png";

  static final EdgeInsets edgePadding = const EdgeInsets.only(
    top: 10.8,
    bottom: 10.8,
    left: 12.5,
    right: 31.5,
  );

  static final EdgeInsets simpleEdgePadding = const EdgeInsets.only(
    top: 10.8,
    bottom: 10.8,
    left: 33.5,
    right: 31.5,
  );

  static final double leadingWidth = 41;
  static final double leadingIconHeight = 20;
  static final double trailingWidth = 7.5;
  static final double trailingIconHeight = 13;
}

class ProfileListItemViewModel {
  final String? icon;
  final String title;
  final Function onTap;
  final bool isDestructive;

  ProfileListItemViewModel({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.isDestructive,
  });
}

class ProfileListItemStyle {
  final TextStyle titleTextStyle;
  final TextStyle destructiveTextStyle;

  final int maxLines;

  const ProfileListItemStyle({
    required this.titleTextStyle,
    required this.destructiveTextStyle,
    required this.maxLines,
  });

  ProfileListItemStyle copyWith({
    TextStyle? titleTextStyle,
    TextStyle? destructiveTextStyle,
    int? maxLines,
  }) {
    return ProfileListItemStyle(
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      destructiveTextStyle: destructiveTextStyle ?? this.destructiveTextStyle,
      maxLines: maxLines ?? this.maxLines,
    );
  }
}

class _DefaultStyle extends ProfileListItemStyle {
  const _DefaultStyle()
      : super(
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 17,
          ),
          destructiveTextStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            color: Color(0xffff6060),
            fontSize: 17,
          ),
          maxLines: 1,
        );
}

const ProfileListItemStyle _defaultStyle = _DefaultStyle();

class ProfileListItem extends StatelessWidget {
  final ProfileListItemViewModel _viewModel;
  final ProfileListItemStyle _style;

  const ProfileListItem({
    Key? key,
    required ProfileListItemViewModel viewModel,
    ProfileListItemStyle style = _defaultStyle,
  })  : this._viewModel = viewModel,
        this._style = style,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasIcon = _viewModel.icon != null && _viewModel.icon!.isNotEmpty;
    return ListTile(
      onTap: () => _actionTapped(context),
      contentPadding:
          hasIcon ? _Constants.edgePadding : _Constants.simpleEdgePadding,
      dense: true,
      leading: _buildLeading(),
      trailing: _buildTrailing(),
      title: _buildTitle(),
    );
  }

  Widget? _buildLeading() {
    if (_viewModel.icon == null || _viewModel.icon!.isEmpty) {
      return null;
    }
    return Container(
      alignment: Alignment.centerRight,
      width: _Constants.leadingWidth,
      child: Image.asset(
        _viewModel.icon!,
        height: _Constants.leadingIconHeight,
      ),
    );
  }

  Widget _buildTrailing() {
    return Container(
      width: _Constants.trailingWidth,
      child: Image.asset(
        _Constants.arrowIcon,
        height: _Constants.trailingIconHeight,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      _viewModel.title,
      style: !_viewModel.isDestructive
          ? _style.titleTextStyle
          : _style.destructiveTextStyle,
      maxLines: _style.maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }

  void _actionTapped(BuildContext context) {
    if (_viewModel.isDestructive) {
      Alert.present(
        Alert(
          viewModel: AlertViewModel(
            cancelActionText: _LocalisedStrings.cancelAction(),
            confirmActionText: _LocalisedStrings.confirmAction(),
            titleText: _viewModel.title,
            detailText: _LocalisedStrings.dialogDescription(),
            confirmAction: () {
              _viewModel.onTap();
              Navigator.of(context).pop();
            },
            isDestructive: true,
          ),
        ),
        context,
      );
    } else {
      _viewModel.onTap();
    }
  }
}
