import 'package:flutter/material.dart';

class MessageBubbleStyle {
  final EdgeInsetsGeometry outerContainerMargin;
  final BorderRadiusGeometry textContainerBorderRadius;
  final EdgeInsetsGeometry textContainerPadding;
  final EdgeInsetsGeometry textContainerMargin;
  final Color textContainerBackgroundColor;
  final TextAlign textAlignment;
  final TextStyle textStyle;
  final CrossAxisAlignment rowCrossAxisAlignment;
  final MainAxisAlignment rowMainAxisAlignment;

  const MessageBubbleStyle({
    required this.outerContainerMargin,
    required this.textContainerBorderRadius,
    required this.textContainerPadding,
    required this.textContainerMargin,
    required this.textContainerBackgroundColor,
    required this.textAlignment,
    required this.textStyle,
    required this.rowCrossAxisAlignment,
    required this.rowMainAxisAlignment,
  });

  MessageBubbleStyle copyWith({
    EdgeInsetsGeometry? outerContainerMargin,
    BorderRadiusGeometry? textContainerBorderRadius,
    EdgeInsetsGeometry? textContainerPadding,
    EdgeInsetsGeometry? textContainerMargin,
    Color? textContainerBackgroundColor,
    TextAlign? textAlignment,
    TextStyle? textStyle,
    CrossAxisAlignment? rowCrossAxisAlignment,
    MainAxisAlignment? rowMainAxisAlignment,
  }) {
    return MessageBubbleStyle(
      outerContainerMargin: outerContainerMargin ?? this.outerContainerMargin,
      textContainerBorderRadius:
          textContainerBorderRadius ?? this.textContainerBorderRadius,
      textContainerPadding: textContainerPadding ?? this.textContainerPadding,
      textContainerMargin: textContainerMargin ?? this.textContainerMargin,
      textContainerBackgroundColor:
          textContainerBackgroundColor ?? this.textContainerBackgroundColor,
      textAlignment: textAlignment ?? this.textAlignment,
      textStyle: textStyle ?? this.textStyle,
      rowCrossAxisAlignment:
          rowCrossAxisAlignment ?? this.rowCrossAxisAlignment,
      rowMainAxisAlignment: rowMainAxisAlignment ?? this.rowMainAxisAlignment,
    );
  }
}

class _DefaultMessageBubbleStyle extends MessageBubbleStyle {
  const _DefaultMessageBubbleStyle()
      : super(
          outerContainerMargin: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          textContainerBorderRadius:
              const BorderRadius.all(Radius.circular(20.0)),
          textContainerPadding: const EdgeInsets.all(16.0),
          textContainerMargin: const EdgeInsets.only(
            left: 30.0,
            right: 0.0,
          ),
          textContainerBackgroundColor: const Color(0xFF00CD9F),
          textAlignment: TextAlign.start,
          textStyle: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 15.0,
          ),
          rowCrossAxisAlignment: CrossAxisAlignment.end,
          rowMainAxisAlignment: MainAxisAlignment.end,
        );
}

const MessageBubbleStyle _defaultStyle = _DefaultMessageBubbleStyle();

class MessageBubble extends StatelessWidget {
  final MessageBubbleViewModel _viewModel;
  final MessageBubbleStyle _style;
  final VoidCallback _onTap;

  MessageBubble({
    required MessageBubbleViewModel viewModel,
    MessageBubbleStyle style = _defaultStyle,
    VoidCallback? onTap,
    Key? key,
  })  : _viewModel = viewModel,
        _style = style,
        _onTap = onTap ?? (() => {}),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        margin: _style.outerContainerMargin,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: _style.rowCrossAxisAlignment,
          mainAxisAlignment: _style.rowMainAxisAlignment,
          children: <Widget>[_buildAvatar(), _buildContainer()],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return _viewModel.avatar;
  }

  Widget _buildContainer() {
    return Flexible(
      child: Container(
        padding: _style.textContainerPadding,
        margin: _style.textContainerMargin,
        decoration: BoxDecoration(
          color: _style.textContainerBackgroundColor,
          borderRadius: _style.textContainerBorderRadius,
        ),
        child: _buildItem(),
      ),
    );
  }

  Widget _buildItem() {
    return Column(
      children: <Widget>[_buildChild(), _buildText(_viewModel.message)],
    );
  }

  Widget _buildChild() {
    return _viewModel.messageChild;
  }

  Widget _buildText(String message) {
    if (message.isNotEmpty) {
      return Text(
        message,
        textAlign: _style.textAlignment,
        style: _style.textStyle,
      );
    }
    return const SizedBox.shrink();
  }
}

class MessageBubbleViewModel {
  final Widget messageChild;
  final Widget avatar;
  final String message;
  MessageType messageType;

  MessageBubbleViewModel({
    required this.message,
    required this.messageChild,
    required this.avatar,
    required this.messageType,
  });

  MessageBubbleViewModel copyWith({
    String? message,
    Widget? messageChild,
    Widget? avatar,
    MessageType? messageType,
  }) {
    return MessageBubbleViewModel(
      message: message ?? this.message,
      messageChild: messageChild ?? this.messageChild,
      avatar: avatar ?? this.avatar,
      messageType: messageType ?? this.messageType,
    );
  }
}

enum MessageType {
  sent,
  received,
  receivedStackTop,
  receivedStackBottom,
  receivedStackBetween,
  header,
  loading,
}
