import 'package:flutter/material.dart';
import 'package:farmsmart_flutter/chat/bloc/provider/ChatProvider.dart';
import 'package:farmsmart_flutter/chat/ui/widgets/bubble_message.dart';
import 'package:farmsmart_flutter/chat/ui/widgets/chat_list.dart';

class ChatStyle {
  final Color mainContainerColor;
  final CrossAxisAlignment crossAxisAlignment;

  const ChatStyle({
    required this.mainContainerColor,
    required this.crossAxisAlignment,
  });

  ChatStyle copyWith({
    Color? mainContainerColor,
    CrossAxisAlignment? crossAxisAlignment,
  }) {
    return ChatStyle(
      mainContainerColor: mainContainerColor ?? this.mainContainerColor,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
    );
  }
}

class _DefaultStyle extends ChatStyle {
  const _DefaultStyle()
      : super(
          mainContainerColor: const Color(0xFFFFFFFF),
          crossAxisAlignment: CrossAxisAlignment.start,
        );
}

const ChatStyle _defaultStyle = _DefaultStyle();

class Chat extends StatelessWidget {
  final ChatProvider _chatProvider;
  final ChatStyle _style;

  const Chat({
    Key? key,
    required ChatProvider chatProvider,
    ChatStyle style = _defaultStyle,
  })  : _chatProvider = chatProvider,
        _style = style,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChatViewModel>(
      initialData: _chatProvider.initial(),
      stream: _chatProvider.observe().stream,
      builder: (BuildContext context,
          AsyncSnapshot<ChatViewModel> chatProviderSnapshot) {
        final chatViewModel = chatProviderSnapshot.data;
        return Container(
          color: _style.mainContainerColor,
          child: Column(
            crossAxisAlignment: _style.crossAxisAlignment,
            children: <Widget>[
              if (chatViewModel != null) _buildList(chatViewModel),
              if (chatViewModel != null) _buildInteractiveWidget(chatViewModel),
            ],
          ),
        );
      },
    );
  }

  Widget _buildList(ChatViewModel chatViewModel) {
    return ChatList(
      messages: chatViewModel.messageViewModels,
      scrollController: chatViewModel.scrollController,
    );
  }

  Widget _buildInteractiveWidget(ChatViewModel chatViewModel) {
    return chatViewModel.interactiveWidget;
  }
}

class ChatViewModel {
  final List<MessageBubbleViewModel> messageViewModels;
  final ScrollController scrollController;
  Widget interactiveWidget;

  ChatViewModel({
    List<MessageBubbleViewModel>? messageViewModels,
    Widget? interactiveWidget,
    ScrollController? scrollController,
  })  : messageViewModels = messageViewModels ?? [],
        interactiveWidget = interactiveWidget ?? const SizedBox.shrink(),
        scrollController = scrollController ?? ScrollController();
}
