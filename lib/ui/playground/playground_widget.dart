import 'package:flutter/widgets.dart';

class PlaygroundWidget extends StatelessWidget {
  const PlaygroundWidget({Key? key, required this.title, required this.child})
      : super(key: key);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
