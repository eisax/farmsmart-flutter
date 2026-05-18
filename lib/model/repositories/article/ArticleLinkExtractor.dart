import 'package:farmsmart_flutter/model/entities/ImageURLProvider.dart';
import 'package:farmsmart_flutter/model/repositories/image/implementation/PathImageProvider.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class _Fields {
  static const imageTag = "img";
  static const sourceTag = "src";
}

class HTMLLinkExtractor {
  final String content;

  HTMLLinkExtractor(this.content);

  List<ImageURLProvider> imageProviders() {
    dom.Document document = parser.parse(content);
    dom.Element? body = document.body;
    if (body == null) {
      return [];
    }
    return _findImageLinks(body).map((link) => PathImageProvider(link)).toList();
  }

  List<String> imagePaths() {
    dom.Document document = parser.parse(content);
    dom.Element? body = document.body;
    if (body == null) {
      return [];
    }
    return _findImageLinks(body).toList();
  }

  List<String> _findImageLinks(dom.Node node) {
    final List<String> links = [];
    if (node is dom.Element) {
      if (node.localName == _Fields.imageTag) {
        final src = node.attributes[_Fields.sourceTag];
        if (src != null && src.isNotEmpty) {
          links.add(src);
        }
      }
    }
    for (var child in node.nodes) {
      _findImageLinks(child).forEach((image) => links.add(image));
    }
    return links;
  }
}
