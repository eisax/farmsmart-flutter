import 'package:flutter/material.dart';

class CardViewStyle {
  final EdgeInsetsGeometry mainContainerMargin;
  final double borderRadius;
  final Color shadowColor;
  final double shadowRadius;
  final double cardElevation;

  const CardViewStyle({
    required this.borderRadius,
    required this.shadowColor,
    required this.shadowRadius,
    required this.cardElevation,
    required this.mainContainerMargin,
  });

  CardViewStyle copyWith({
    double? borderRadius,
    Color? shadowColor,
    double? shadowRadius,
    double? cardElevation,
    EdgeInsetsGeometry? mainContainerMargin,
  }) {
    return CardViewStyle(
      mainContainerMargin: mainContainerMargin ?? this.mainContainerMargin,
      cardElevation: cardElevation ?? this.cardElevation,
      shadowRadius: shadowRadius ?? this.shadowRadius,
      shadowColor: shadowColor ?? this.shadowColor,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
}

class _DefaultStyle extends CardViewStyle {
  const _DefaultStyle()
      : super(
          borderRadius: 10.0,
          shadowColor: const Color(0xFFBDBDBD),
          shadowRadius: 40.0,
          cardElevation: 0.0,
          mainContainerMargin: const EdgeInsets.all(20.0),
        );
}

const CardViewStyle _defaultStyle = _DefaultStyle();

class CardView extends StatelessWidget {
  final CardViewStyle _style;
  final Widget _child;

  const CardView({
    Key? key,
    CardViewStyle style = _defaultStyle,
    required Widget child,
  })  : _style = style,
        _child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: _style.mainContainerMargin,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            child: Card(
              elevation: _style.cardElevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_style.borderRadius),
              ),
              child: Center(
                child: _child,
              ),
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: _style.shadowColor,
                  blurRadius: _style.shadowRadius,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
