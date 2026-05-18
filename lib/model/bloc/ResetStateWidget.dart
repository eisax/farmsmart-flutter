import 'package:flutter/widgets.dart';

class ResetStateWidget extends StatefulWidget {
  final Widget child;

  const ResetStateWidget({required this.child, super.key});

  static void resetState(BuildContext context) {
    final state = context.findAncestorStateOfType<_ResetStateWidgetState>();
    state?.restartApp();
  }

  @override
  State<ResetStateWidget> createState() => _ResetStateWidgetState();
}

class _ResetStateWidgetState extends State<ResetStateWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: widget.child,
    );
  }
}
