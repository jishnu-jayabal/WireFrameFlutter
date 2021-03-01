import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageCroppingScreen extends StatefulWidget {
  ImageCroppingScreen({Key key}) : super(key: key);

  @override
  _ImageCroppingScreenState createState() => _ImageCroppingScreenState();
}

class _ImageCroppingScreenState extends State<ImageCroppingScreen> {

  File _imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _imageFile != null?Image.file(_imageFile):SizedBox(),
            OutlineButton(
              child: Text("Select Image and Crop"),
              onPressed: () {
                  ImagePicker().getImage(source: ImageSource.camera)
                .then((value) {
                  ImageCropper.cropImage(sourcePath: value.path).then((value) {
                    setState(() {
                      _imageFile=value;
                    });
                  });
                } );
              },
            ),
          ],
        ),
      ),
    );
  }
}
