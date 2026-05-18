import 'dart:io';

import 'package:flutter/material.dart';
import 'package:farmsmart_flutter/chat/bloc/provider/ChatProvider.dart';
import 'package:farmsmart_flutter/chat/repository/form/implementation/JSONFileFormRepository.dart';
import 'package:farmsmart_flutter/chat/ui/viewmodel/ChatResponseViewModel.dart';
import 'package:farmsmart_flutter/chat/ui/widgets/chat.dart';

import '../ChatFlow.dart';

class ChatFlowFromFile implements ChatFlow {
  final BuildContext _context;

  ChatFlowFromFile(BuildContext context) : this._context = context;

  @override
  Widget start({
    required File file,
    required Function(Map<String, ChatResponseViewModel>) onSuccess,
    required Function(String) onError,
  }) {
    // ignore: unused_local_variable
    final _onSuccess = onSuccess;
    // ignore: unused_local_variable
    final _onError = onError;
    return Chat(
      chatProvider: ChatProvider(
        repository: JSONFileFormRepository(
          context: _context,
          file: file,
        ),
      ),
    );
  }
}
