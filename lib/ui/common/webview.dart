import 'package:farmsmart_flutter/ui/common/ContextualAppBar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart' as FlutterWebView;

class _Constants {
  static final loadingIndex = 0;
  static final webViewIndex = 1;
}

class WebView extends StatefulWidget {
  final String url;

  const WebView({Key? key, required this.url}) : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late int _stackToView;
  late final FlutterWebView.WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _stackToView = _Constants.loadingIndex;
    _controller = FlutterWebView.WebViewController()
      ..setJavaScriptMode(FlutterWebView.JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        FlutterWebView.NavigationDelegate(
          onPageFinished: _handlePageLoaded,
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _handlePageLoaded(String value) {
    setState(() {
      _stackToView = _Constants.webViewIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _stackToView,
      children: <Widget>[
        Column(
          children: <Widget>[_buildAppbar(context), _buildProgress()],
        ),
        Column(
          children: <Widget>[_buildAppbar(context), _buildWebView()],
        )
      ],
    );
  }

  Expanded _buildWebView() {
    return Expanded(
      child: FlutterWebView.WebViewWidget(controller: _controller),
    );
  }

  Widget _buildProgress() {
    return Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildAppbar(BuildContext context) =>
      ContextualAppBar().build(context);
}
