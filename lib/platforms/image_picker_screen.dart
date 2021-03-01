import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import 'camera_screen.dart';

class ImagePickerScreen extends StatefulWidget {
  ImagePickerScreen({Key key}) : super(key: key);

  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  final picker = ImagePicker();
  File _image;
  File _video;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _image != null ? Image.file(_image) : SizedBox.shrink(),
            OutlineButton(
              onPressed: () {
                this._openImageFromSource(ImageSource.camera);
              },
              child: Text("Open Native Camera Photo"),
            ),
            OutlineButton(
              onPressed: () {
                this._openImageFromSource(ImageSource.gallery);
              },
              child: Text("Open Gallery Pick Image"),
            ),
            OutlineButton(
              onPressed: () {
                this._openVideoFromSource(ImageSource.camera);
              },
              child: Text("Open Native Camera Video"),
            ),
            OutlineButton(
              onPressed: () {
                this._openVideoFromSource(ImageSource.gallery);
              },
              child: Text("Open Gallery Pick Video"),
            ),
          ],
        ),
      ),
    );
  }

  void _openImageFromSource(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    setState(() {});
  }

  void _openVideoFromSource(ImageSource source) async {
    final pickedFile = await picker.getVideo(source: source);
    if (pickedFile != null) {
      _video = File(pickedFile.path);
      var videoCtrl = VideoPlayerController.file(File(pickedFile.path));
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VideoPreview(
                  videoPlayerController: videoCtrl,
                )),
      );
    } else {
      print('No image selected.');
    }
    setState(() {});
  }
}
