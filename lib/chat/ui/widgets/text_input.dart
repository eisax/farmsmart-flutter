import 'package:flutter/material.dart';

class _Constants {
  static const defaultTextFormFieldContainerPadding =
      EdgeInsets.symmetric(horizontal: 16.0);
  static const defaultTextFormFieldStyle = TextStyle(
    color: Color(0xFF1A1B46),
    fontSize: 15.0,
  );
  static const defaultButtonColor = Color(0xFF00CD9F);
  static const defaultBoxDecorationBorderRadius =
      BorderRadius.all(Radius.circular(20.0));
  static const defaultBoxDecorationBorderColor = Color(0xFFE9EAF2);
  static const defaultBoxDecorationBorderWidth = 2.0;
}

class TextInputStyle {
  final EdgeInsetsGeometry textFormFieldContainerPadding;
  final TextStyle textFormFieldStyle;
  final Color buttonColor;
  final BorderRadiusGeometry boxDecorationBorderRadius;
  final Color boxDecorationBorderColor;
  final double boxDecorationBorderWidth;

  const TextInputStyle({
    this.textFormFieldContainerPadding =
        _Constants.defaultTextFormFieldContainerPadding,
    this.textFormFieldStyle = _Constants.defaultTextFormFieldStyle,
    this.buttonColor = _Constants.defaultButtonColor,
    this.boxDecorationBorderRadius =
        _Constants.defaultBoxDecorationBorderRadius,
    this.boxDecorationBorderColor = _Constants.defaultBoxDecorationBorderColor,
    this.boxDecorationBorderWidth = _Constants.defaultBoxDecorationBorderWidth,
  });

  TextInputStyle copyWith({
    EdgeInsetsGeometry? textFormFieldContainerPadding,
    TextStyle? textFormFieldStyle,
    Color? buttonColor,
    BorderRadiusGeometry? boxDecorationBorderRadius,
    Color? boxDecorationBorderColor,
    double? boxDecorationBorderWidth,
  }) {
    return TextInputStyle(
      textFormFieldContainerPadding:
          textFormFieldContainerPadding ?? this.textFormFieldContainerPadding,
      textFormFieldStyle: textFormFieldStyle ?? this.textFormFieldStyle,
      buttonColor: buttonColor ?? this.buttonColor,
      boxDecorationBorderRadius:
          boxDecorationBorderRadius ?? this.boxDecorationBorderRadius,
      boxDecorationBorderColor:
          boxDecorationBorderColor ?? this.boxDecorationBorderColor,
      boxDecorationBorderWidth:
          boxDecorationBorderWidth ?? this.boxDecorationBorderWidth,
    );
  }
}

const TextInputStyle _defaultStyle = TextInputStyle();

class TextInputState extends State<TextInput> {
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final form = Form(
      key: widget.formKey,
      child: _buildTextFormField(),
    );
    _manageFocus();
    return form;
  }

  void _manageFocus() {
    if (widget._isFocusedOnBuild) {
      FocusScope.of(context).autofocus(_focusNode);
    }
  }

  Widget _buildTextFormField() => Center(
        child: Container(
          padding: widget._style.textFormFieldContainerPadding,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: widget._style.boxDecorationBorderRadius,
            border: Border.all(
              color: widget._style.boxDecorationBorderColor,
              width: widget._style.boxDecorationBorderWidth,
            ),
          ),
          child: TextFormField(
            controller: widget._controller,
            decoration: widget._decoration,
            focusNode: _focusNode,
            validator: widget._formFieldValidatorFunction,
            style: widget._style.textFormFieldStyle,
          ),
        ),
      );
}

class TextInput extends StatefulWidget {
  final TextEditingController _controller;
  final InputDecoration _decoration;
  final String? Function(String?)? _formFieldValidatorFunction;
  final bool _isFocusedOnBuild;
  final TextInputStyle _style;
  final formKey = GlobalKey<FormState>();

  TextInput({
    Key? key,
    TextEditingController? controller,
    InputDecoration? decoration,
    String? Function(String?)? formFieldValidatorFunction,
    bool isFocusedOnBuild = false,
    TextInputStyle style = _defaultStyle,
  })  : _controller = controller ?? TextEditingController(),
        _decoration = decoration ?? const InputDecoration(),
        _formFieldValidatorFunction =
            formFieldValidatorFunction ?? ((_) => null),
        _isFocusedOnBuild = isFocusedOnBuild,
        _style = style,
        super(key: key);

  @override
  TextInputState createState() {
    return TextInputState();
  }
}
