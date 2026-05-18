import 'dart:io';

import 'package:farmsmart_flutter/ui/common/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as ImagePickerLib;

class PlaygroundTakeImageTester extends StatefulWidget {
  final ImagePickerLib.ImageSource imageSource;

  const PlaygroundTakeImageTester({Key? key, required this.imageSource})
      : super(key: key);

  @override
  _PlaygroundTakeImageTesterState createState() =>
      _PlaygroundTakeImageTesterState();
}

class _PlaygroundTakeImageTesterState extends State<PlaygroundTakeImageTester> {
  File? _file;

  @override
  void initState() {
    super.initState();

    ImagePicker.pickImage(
      imageSource: widget.imageSource,
      imageMaxHeight: 500,
      imageMaxWidth: 500,
      onSuccess: (imageFile) {
        setState(() {
          _file = imageFile;
        });
      },
      onCancel: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    if (_file != null) {
      _file!.delete();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          _file != null ? Image.file(_file!) : const Text('No image selected'),
    );
  }
}
