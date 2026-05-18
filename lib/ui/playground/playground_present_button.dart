import 'package:farmsmart_flutter/ui/common/modal_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PlaygroundPresentButton extends StatelessWidget {
  final Widget child;
  final void Function(Widget, BuildContext)? listener;

  const PlaygroundPresentButton({
    Key? key,
    this.listener,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text("Press Me"),
        onPressed: () {
          if (listener != null) {
            listener!(child, context);
          } else {
            NavigationScope.presentModal(context, child);
          }
        },
      ),
    );
  }
}
