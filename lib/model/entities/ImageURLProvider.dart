
class _Strings {
  static const prefix  = "_";
  static const divider = "x";
}
abstract class ImageURLProvider {
    String cachedUrlToFit({double width,double height});
    Future<String> urlToFit({double width,double height});
    String cacheIdentifier({double width, double height});

    static String sizeIdentifier({double width=0, double height=0}) {
      final widthString = width.toString();
      final heightString = height.toString();
      return _Strings.prefix + widthString + _Strings.divider + heightString;
    }
}