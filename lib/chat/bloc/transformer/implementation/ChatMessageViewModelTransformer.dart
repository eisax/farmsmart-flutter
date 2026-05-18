import 'package:flutter/material.dart';
import 'package:farmsmart_flutter/chat/bloc/transformer/Transformer.dart';
import 'package:farmsmart_flutter/chat/model/form/form_item_entity.dart';
import 'package:farmsmart_flutter/chat/ui/widgets/bubble_message.dart';

class ChatMessageViewModelTransformer
    implements ObjectTransformer<FormItemEntity, MessageBubbleViewModel> {
  @override
  MessageBubbleViewModel transform({required FormItemEntity from}) {
    return MessageBubbleViewModel(
      message: from.text,
      messageChild: const SizedBox.shrink(),
      avatar: const SizedBox.shrink(),
      messageType: MessageType.received,
    );
  }
}
