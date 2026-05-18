import 'package:flutter/material.dart';

class ErrorRetry extends StatelessWidget {
  final String errorMessage;
  final String retryActionLabel;
  final VoidCallback retryFunction;

  const ErrorRetry({
    Key? key,
    required this.retryActionLabel,
    required this.errorMessage,
    required this.retryFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AlertDialog(
            title: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                child: Text(retryActionLabel),
                onPressed: retryFunction,
              )
            ],
          )
        ],
      ),
    );
  }
}
