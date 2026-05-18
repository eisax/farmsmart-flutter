import 'package:flutter/widgets.dart';

class CarouselView extends StatelessWidget {
  final List<Widget> _children;
  final ValueChanged<int>? _onPageChange;
  final PageController _pageController;

  const CarouselView({
    Key? key,
    required List<Widget> children,
    ValueChanged<int>? onPageChange,
    required PageController pageController,
  })  : this._children = children,
        this._onPageChange = onPageChange,
        this._pageController = pageController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: _children,
      onPageChanged: _onPageChange,
      controller: _pageController,
    );
  }
}
