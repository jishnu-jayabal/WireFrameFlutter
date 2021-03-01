import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share/share.dart';

class ShareScreen extends StatelessWidget {
  const ShareScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlineButton(
              child: Text("Share Text"),
              onPressed: () {
                Share.share("Hello world");
              },
            ),
            OutlineButton(
              child: Text("Share Image"),
              onPressed: () {
                ImagePicker().getImage(source: ImageSource.gallery)
                .then((value) {
                  Share.shareFiles([value.path],subject: "Image Subject",text: "Testing image sharing");
                } );
              },
            ),
            OutlineButton(
              child: Text("Share Video"),
              onPressed: () {
                  ImagePicker().getVideo(source: ImageSource.camera)
                .then((value) {
                  Share.shareFiles([value.path],subject: "Video Subject",text: "Testing video sharing");
                } );
              },
            ),
            OutlineButton(
              child: Text("Share Web Link"),
              onPressed: () {
                 Share.share("http://flutter.dev.com",subject:"Link");
              },
            )
          ],
        ),
      ),
    );
  }
}
