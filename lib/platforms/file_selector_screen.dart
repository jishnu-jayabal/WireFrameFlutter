import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'camera_screen.dart';

class FileSelectorScreen extends StatefulWidget {
  FileSelectorScreen({Key key}) : super(key: key);

  @override
  _FileSelectorScreenState createState() => _FileSelectorScreenState();
}

class _FileSelectorScreenState extends State<FileSelectorScreen> {
  File imageFile;
  File videoFile;

  void openSingleFilePicker() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg','mp4']
    );

    if (result != null) {
      print("skajksjakljskaksjakjs" + result.files.first.extension);
      if (result.files.first.extension == 'jpg') {
        this.imageFile = File(result.files.single.path);
        setState(() {});
      } else if(result.files.first.extension == 'mp4'){
        this.videoFile = File(result.files.single.path);
        setState(() {});
        var videoCtrl = VideoPlayerController.file(File(videoFile.path));
        print(videoFile.path);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoPreview(
                    videoPlayerController: videoCtrl,
                  )),);
      }
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            imageFile != null ? Image.file(imageFile) : SizedBox.shrink(),
           
            OutlineButton(
              child: Text("Select Files"),
              onPressed: () {
                openSingleFilePicker();
              },
            )
          ],
        ),
      ),
    );
  }
}
