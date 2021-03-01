import 'package:WireFrameFlutter/platforms/barcode_scanner_screen.dart';
import 'package:WireFrameFlutter/platforms/file_selector_screen.dart';
import 'package:WireFrameFlutter/platforms/image_cropping_screen.dart';
import 'package:WireFrameFlutter/platforms/image_picker_screen.dart';
import 'package:WireFrameFlutter/platforms/local_authentication_screen.dart';
import 'package:WireFrameFlutter/platforms/local_notification_screen.dart';
import 'package:WireFrameFlutter/platforms/pdf_viewer_screen.dart';
import 'package:WireFrameFlutter/platforms/share_screen.dart';
import 'package:WireFrameFlutter/platforms/web_view_scren.dart';
import 'package:WireFrameFlutter/platforms/audio_record_screen.dart';
import 'package:WireFrameFlutter/platforms/camera_screen.dart';
import 'package:WireFrameFlutter/platforms/permission_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WireFrameApp"),
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            
              children: [
                OutlineButton(
                  child: Text("Image / Video / Video Player"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CameraScreen();
                    }));
                  },
                ),
                OutlineButton(
                  child: Text("Audio Play/Record"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AudioRecordScreen();
                    }));
                  },
                ),
                OutlineButton(
                  child: Text("Permission"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return PermissionScreen();
                    }));
                  },
                ),
                OutlineButton(
                  child: Text("Web View"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return WebViewScreen();
                    }));
                  },
                ),
                OutlineButton(
                  child: Text("File Selector"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return FileSelectorScreen();
                    }));
                  },
                ),
                OutlineButton(
                  child: Text("Image Picker [ Native Photo/Video & Galley ]"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ImagePickerScreen();
                    }));
                  },
                ),
                OutlineButton(
                  child: Text("Image Cropping"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ImageCroppingScreen();
                    }));
                  },
                ),
                OutlineButton(
                  child: Text("Share Things"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ShareScreen();
                    }));
                  },
                ),
                OutlineButton(
                  child: Text("Barcode"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return BarCodeScannerScreen();
                    }));
                  },
                ),
                OutlineButton(
                  child: Text("PDF VIEWER"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return PdfViewerScreen();
                    }));
                  },
                ),
                 OutlineButton(
                  child: Text("Local Authentication"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LocalAuthenticationScreen();
                    }));
                  },
                ),
               
                 OutlineButton(
                  child: Text("Local Notification"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LocalNotificationScreen();
                    }));
                  },
                ),
                OutlineButton(
                  child: Text("Rest API"),
                  onPressed: () {},
                ),
              ])),
    );
  }
}
