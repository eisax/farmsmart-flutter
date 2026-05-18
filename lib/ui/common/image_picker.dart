import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart' as ImagePickerLib
    show ImagePicker, ImageSource;
import 'package:intl/intl.dart';

class _Constants {
  static final Color cropStatusBarColor = const Color(0xffffffff);
  static final Color cropToolbarBarColor = const Color(0xffffffff);
  static const double defaultImageRatioX = 1.0;
  static const double defaultImageRatioY = 1.0;
}

class _LocalisedStrings {
  static String editPhoto() => Intl.message('Edit Photo');

  static String noImagePickedError() => Intl.message('No image picked');

  static String noCroppedImageError() => Intl.message('No cropped image');
}

class ImagePicker {
  static Future<bool> pickImage({
    required ValueChanged<File> onSuccess,
    required ValueChanged<String> onCancel,
    required ImagePickerLib.ImageSource imageSource,
    required int imageMaxHeight,
    required int imageMaxWidth,
    bool circleShapeOnCrop = true,
    double imageRatioX = _Constants.defaultImageRatioX,
    double imageRatioY = _Constants.defaultImageRatioY,
  }) async {
    final _picker = ImagePickerLib.ImagePicker();
    final file = await _picker.pickImage(
      source: imageSource,
      maxHeight: imageMaxHeight.toDouble(),
      maxWidth: imageMaxWidth.toDouble(),
    );

    if (file == null) {
      onCancel(_LocalisedStrings.noImagePickedError());
      return false;
    }

    final cropStyle =
        circleShapeOnCrop ? CropStyle.circle : CropStyle.rectangle;
    final androidSettings = AndroidUiSettings(
      toolbarTitle: _LocalisedStrings.editPhoto(),
      toolbarColor: _Constants.cropToolbarBarColor,
      toolbarWidgetColor: Colors.black,
      statusBarColor: _Constants.cropStatusBarColor,
      cropStyle: cropStyle,
    );
    final iosSettings = IOSUiSettings(
      title: _LocalisedStrings.editPhoto(),
      cropStyle: cropStyle,
    );

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: CropAspectRatio(ratioX: imageRatioX, ratioY: imageRatioY),
      maxWidth: imageMaxWidth,
      maxHeight: imageMaxHeight,
      uiSettings: [androidSettings, iosSettings],
    );

    await File(file.path).delete();

    if (croppedFile == null) {
      onCancel(_LocalisedStrings.noCroppedImageError());
      return false;
    }

    onSuccess(File(croppedFile.path));
    return true;
  }
}
