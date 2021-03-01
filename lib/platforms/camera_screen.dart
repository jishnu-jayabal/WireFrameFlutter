import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class CameraScreen extends StatefulWidget {
  CameraScreen({Key key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;
  bool videoRecording = false;

  @override
  void initState() {
    super.initState();
    // 1
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras.length > 0) {
        setState(() {
          // 2
          selectedCameraIdx = 0;
        });

        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
      } else {
        print("No camera available");
      }
    }).catchError((err) {
      // 3
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  void _toggleCameraLens() {
    // get current lens direction (front / rear)
    final lensDirection = controller.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }

    if (newDescription != null) {
      _initCameraController(newDescription).then((void v) {});
    } else {
      print('Asked camera not available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _cameraPreviewWidget()),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                IconButton(
                  color: Colors.white,
                  iconSize: 50.0,
                  icon: Icon(Icons.camera),
                  onPressed: () {
                    _onCapturePressed(context);
                  },
                ),
                IconButton(
                  color: Colors.white,
                  iconSize: 50.0,
                  icon: Icon(Icons.camera_roll),
                  onPressed: () {
                    _onVideoCapturePressed(context);
                  },
                ),
                IconButton(
                  color: Colors.white,
                  iconSize: 50.0,
                  icon: Icon(controller.description.lensDirection ==
                          CameraLensDirection.front
                      ? Icons.camera_rear
                      : Icons.camera_front),
                  onPressed: () {
                    _toggleCameraLens();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _onCapturePressed(context) async {
    try {
      // 1
      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );
      // 2
      XFile imageFile = await controller.takePicture();
      print(imageFile.path);
      // 3
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Scaffold(body: Image.file(File(imageFile.path))),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  void _onVideoCapturePressed(context) async {
    XFile videoFile;
    try {
      if (!this.videoRecording) {
        // 2
        this.controller.startVideoRecording().then((_) {
          if (mounted)
            setState(() {
              this.videoRecording = true;
            });
        });
      } else {
        videoFile = await controller.stopVideoRecording();
        var videoCtrl = VideoPlayerController.file(File(videoFile.path));
        print(videoFile.path);

        this.videoRecording = false;
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoPreview(
                    videoPlayerController: videoCtrl,
                  )),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    // 3
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    // 4
    controller.addListener(() {
      // 5
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });
    // 6
    try {
      await controller.initialize();
    } on CameraException catch (e) {
      // _showCameraException(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }
    return CameraPreview(controller);
  }
}

class VideoPreview extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  VideoPreview({Key key, this.videoPlayerController}) : super(key: key);

  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  Future _videoPlayerInitialized;

  void initState() {
    super.initState();
    _videoPlayerInitialized =
        widget.videoPlayerController.initialize().then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: FutureBuilder(
        future: _videoPlayerInitialized,
        builder: (context, snapshot) {
          widget.videoPlayerController.play();
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return Column(children: [
               Container(
                 child: InkWell(
              onTap: () {
                  if (widget.videoPlayerController.value.isPlaying) {
                    widget.videoPlayerController.pause();
                  } else {
                    widget.videoPlayerController.play();
                  }
              },
              child: AspectRatio(
                  aspectRatio: widget.videoPlayerController.value.aspectRatio,
                  // Use the VideoPlayer widget to display the video.
                  child: VideoPlayer(widget.videoPlayerController),
              ),
            ),
               ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              IconButton(icon: Icon(Icons.play_arrow,),onPressed: (){
                  widget.videoPlayerController.play();
              },),
              IconButton(icon: Icon(Icons.pause,),onPressed: (){
                  widget.videoPlayerController.pause();
              },),
              IconButton(icon: Icon(Icons.replay_outlined,),onPressed: (){
                  widget.videoPlayerController.seekTo(Duration(seconds: 0));
              },)
            ])
            ]);
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.videoPlayerController.pause();
  }
}
