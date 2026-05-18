import 'package:cached_network_image/cached_network_image.dart';
import 'package:farmsmart_flutter/model/bloc/download/ApplicationCache.dart';

import 'dart:io';

import 'package:farmsmart_flutter/model/entities/ImageURLProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class _Constants {
  static final placeholderAsset = 'assets/raw/placeholder_color.png';
  static final defaultBorderRadius = BorderRadius.all(Radius.circular(0));
  static final defaultFadeDuration = 200;
  static const webPathPrefix = "http";
}

class ImageProviderView extends StatelessWidget {
  final ImageURLProvider? imageURLProvider;
  final double? height;
  final double? width;
  final BorderRadiusGeometry? imageBorderRadius;
  final Widget? placeholderWidget;

  ImageProviderView({
    this.imageURLProvider,
    this.height,
    this.width = double.infinity,
    this.imageBorderRadius,
    this.placeholderWidget,
  });

  @override
  Widget build(BuildContext context) {
    final placeholder =
        placeholderWidget ?? Image.asset(_Constants.placeholderAsset);
    Future<String?> future = (imageURLProvider != null)
        ? imageURLProvider!
            .urlToFit(
            width: width ?? double.infinity,
            height: height ?? double.infinity,
          )
            .then((url) {
            if (_isLocalImage(url)) {
              return File(url).exists().then((fileExisits) {
                return fileExisits ? url : null;
              });
            }
            return url;
          })
        : Future.value(null);
    final cachedURL = imageURLProvider?.cachedUrlToFit(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
    );
    if (cachedURL != null) {
      return buildImage(cachedURL);
    }

    return FutureBuilder<String?>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<String?> url) {
        if (!url.hasData || url.data == null) {
          return ClipRRect(
            borderRadius: imageBorderRadius as BorderRadius? ??
                _Constants.defaultBorderRadius,
            child: SizedBox(
              height: height ?? double.infinity,
              width: width ?? double.infinity,
              child: FittedBox(
                child: placeholder,
                fit: BoxFit.cover,
              ),
            ),
          );
        }

        return buildImage(url.data!);
      },
    );
  }

  Widget buildImage(String url) {
    final placeholder =
        placeholderWidget ?? Image.asset(_Constants.placeholderAsset);
    if (url.isEmpty) {
      return _boxedImage(placeholder);
    }

    if (url.startsWith('assets/')) {
      return _boxedImage(Image.asset(url, fit: BoxFit.cover));
    }

    final isLocal = _isLocalImage(url);
    final image = isLocal
        ? Image(image: FileImage(File(url)), fit: BoxFit.cover)
        : CachedNetworkImage(
            cacheManager: OfflineCacheManager(),
            width: width ?? double.infinity,
            height: height ?? double.infinity,
            fit: BoxFit.cover,
            fadeOutDuration:
                Duration(milliseconds: _Constants.defaultFadeDuration),
            fadeInDuration:
                Duration(milliseconds: _Constants.defaultFadeDuration),
            fadeInCurve: Curves.linear,
            fadeOutCurve: Curves.linear,
            placeholder: (context, url) =>
                Image(image: AssetImage(_Constants.placeholderAsset)),
            imageUrl: url,
            errorWidget: (context, url, error) =>
                Image(image: AssetImage(_Constants.placeholderAsset)),
          );
    return _boxedImage(image);
  }

  Widget _boxedImage(Widget image) {
    return ClipRRect(
      borderRadius:
          imageBorderRadius as BorderRadius? ?? _Constants.defaultBorderRadius,
      child: SizedBox(
        height: height ?? double.infinity,
        width: width ?? double.infinity,
        child: image,
      ),
    );
  }

  bool _isLocalImage(String uri) {
    return !uri.toLowerCase().startsWith(_Constants.webPathPrefix);
  }
}
