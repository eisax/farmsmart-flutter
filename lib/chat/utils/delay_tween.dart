import 'dart:math' as math show sin, pi;
import 'package:flutter/widgets.dart';

class DelayTween extends Tween<double> {
  DelayTween({
    required double begin,
    required double end,
    required this.delay,
  }) : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) {
    return super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);
  }

  @override
  double evaluate(Animation<double> animation) {
    return lerp(animation.value);
  }
}
