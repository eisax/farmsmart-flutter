import 'package:flutter/material.dart';

class MessageCircleAvatarStyle {
  final double circleRadius;
  final Color backgroundColor;

  const MessageCircleAvatarStyle({
    required this.backgroundColor,
    required this.circleRadius,
  });

  MessageCircleAvatarStyle copyWith({
    double? circleRadius,
    Color? backgroundColor,
  }) {
    return MessageCircleAvatarStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      circleRadius: circleRadius ?? this.circleRadius,
    );
  }
}

class _DefaultStyle extends MessageCircleAvatarStyle {
  final double circleRadius = 20.0;
  final Color backgroundColor = const Color(0xFF00CD9F);

  const _DefaultStyle()
      : super(
          circleRadius: 20.0,
          backgroundColor: const Color(0xFF00CD9F),
        );
}

const MessageCircleAvatarStyle _defaultStyle = _DefaultStyle();

class MessageCircleAvatar extends StatelessWidget {
  final MessageCircleAvatarViewModel _messageCircleAvatarViewModel;
  final MessageCircleAvatarStyle _style;

  MessageCircleAvatar({
    required MessageCircleAvatarViewModel messageCircleAvatarViewModel,
    MessageCircleAvatarStyle style = _defaultStyle,
  })  : this._messageCircleAvatarViewModel = messageCircleAvatarViewModel,
        this._style = style;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: _style.circleRadius,
      backgroundImage:
          AssetImage(_messageCircleAvatarViewModel.backgroundAssetImageSource),
      backgroundColor: _style.backgroundColor,
    );
  }
}

class MessageCircleAvatarViewModel {
  final String backgroundAssetImageSource;

  MessageCircleAvatarViewModel({
    this.backgroundAssetImageSource = '',
  });
}
