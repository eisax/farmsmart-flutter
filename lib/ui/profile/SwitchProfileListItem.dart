import 'package:farmsmart_flutter/model/bloc/ViewModelProvider.dart';
import 'package:farmsmart_flutter/model/entities/ImageURLProvider.dart';
import 'package:farmsmart_flutter/ui/common/ProfileAvatar.dart';
import 'package:farmsmart_flutter/ui/profile/Profile.dart';
import 'package:flutter/material.dart';

class _Icons {
  static final checkBox = "assets/icons/radio_button_default.png";
  static final activeCheckBox = "assets/icons/radio_button_active.png";
}

class _Constants {
  static final double imageSize = 48;
  static final double iconSize = 24;
  static final EdgeInsets iconEdgePadding =
      EdgeInsets.symmetric(horizontal: 32, vertical: 15);
}

class SwitchProfileListItemViewModel {
  final String title;
  final ImageURLProvider image;
  final String icon;
  final Function tapAction;
  final Function switchAction;
  bool isSelected;
  final ViewModelProvider<ProfileViewModel> avatarViewModelProvider;

  SwitchProfileListItemViewModel({
    required this.title,
    required this.image,
    required this.icon,
    required this.tapAction,
    required this.switchAction,
    required this.avatarViewModelProvider,
    this.isSelected = false,
  });
}

class SwitchProfileListItemStyle {
  final TextStyle titleTextStyle;

  const SwitchProfileListItemStyle({
    required this.titleTextStyle,
  });

  SwitchProfileListItemStyle copyWith({
    TextStyle? titleTextStyle,
  }) {
    return SwitchProfileListItemStyle(
        titleTextStyle: titleTextStyle ?? this.titleTextStyle);
  }
}

class _DefaultStyle extends SwitchProfileListItemStyle {
  const _DefaultStyle()
      : super(
          titleTextStyle: const TextStyle(
            color: Color(0xff1a1b46),
            fontSize: 17,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        );
}

const SwitchProfileListItemStyle _defaultStyle = _DefaultStyle();

class SwitchProfileListItem extends StatelessWidget {
  final SwitchProfileListItemViewModel _viewModel;
  final SwitchProfileListItemStyle _style;

  const SwitchProfileListItem({
    Key? key,
    required SwitchProfileListItemViewModel viewModel,
    SwitchProfileListItemStyle style = _defaultStyle,
  })  : this._viewModel = viewModel,
        this._style = style,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        _viewModel.title,
        style: _style.titleTextStyle,
      ),
      leading: ProfileAvatar(
        viewModelProvider: _viewModel.avatarViewModelProvider,
        width: _Constants.imageSize,
        height: _Constants.imageSize,
      ),
      trailing: Image.asset(
        _viewModel.isSelected ? _Icons.activeCheckBox : _Icons.checkBox,
        height: _Constants.iconSize,
      ),
      contentPadding: _Constants.iconEdgePadding,
      onTap: () => _viewModel.tapAction(),
    );
  }
}
