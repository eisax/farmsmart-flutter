import 'package:flutter/material.dart';
import 'package:farmsmart_flutter/chat/ui/widgets/bubble_message.dart';

import 'styles/bubble_message_styles.dart';

class _Constants {
  static const defaultPadding = 32.0;
}

class ChatListStyle {
  final bool shrinkWrap;
  final bool reverse;
  final EdgeInsetsGeometry listPadding;

  const ChatListStyle({
    this.shrinkWrap = true,
    this.reverse = true,
    this.listPadding = const EdgeInsets.all(_Constants.defaultPadding),
  });

  ChatListStyle copyWith({
    bool? shrinkWrap,
    bool? reverse,
    EdgeInsetsGeometry? listPadding,
  }) {
    return ChatListStyle(
      shrinkWrap: shrinkWrap ?? this.shrinkWrap,
      reverse: reverse ?? this.reverse,
      listPadding: listPadding ?? this.listPadding,
    );
  }
}

const ChatListStyle _defaultStyle = ChatListStyle();

class ChatList extends StatelessWidget {
  final ChatListStyle _style;
  final ScrollController _scrollController;
  final VoidCallback _onTapMessage;
  final List<MessageBubbleViewModel> _messages;

  ChatList({
    Key? key,
    ChatListStyle style = _defaultStyle,
    VoidCallback? onTapMessage,
    required List<MessageBubbleViewModel> messages,
    required ScrollController scrollController,
  })  : _style = style,
        _onTapMessage = onTapMessage ?? _defaultOnTap,
        _messages = messages,
        _scrollController = scrollController,
        super(key: key);

  static void _defaultOnTap() {}

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        shrinkWrap: _style.shrinkWrap,
        itemCount: _messages.length,
        reverse: _style.reverse,
        padding: _style.listPadding,
        itemBuilder: (BuildContext context, int index) {
          return _buildMessage(index);
        },
      ),
    );
  }

  Widget _buildMessage(int index) {
    if (_messages.isNotEmpty) {
      final MessageBubbleViewModel message = _messages[index];
      return MessageBubble(
        viewModel: message,
        style: _getStyleByMessageType(message),
        onTap: _onTapMessage,
      );
    }
    return const SizedBox.shrink();
  }

  MessageBubbleStyle _getStyleByMessageType(MessageBubbleViewModel message) {
    switch (message.messageType) {
      case MessageType.sent:
        return MessageBubbleStyles.buildStyleSent();
      case MessageType.header:
        return MessageBubbleStyles.buildStyleHeader();
      case MessageType.loading:
        return MessageBubbleStyles.buildStyleLoading();
      case MessageType.received:
        return MessageBubbleStyles.buildStyleReceived();
      case MessageType.receivedStackTop:
        return MessageBubbleStyles.buildStyleReceivedStackTop();
      case MessageType.receivedStackBottom:
        return MessageBubbleStyles.buildStyleReceivedStackBottom();
      case MessageType.receivedStackBetween:
        return MessageBubbleStyles.buildStyleReceivedStackBetween();
    }
  }
}
