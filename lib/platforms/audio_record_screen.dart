import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class AudioRecordScreen extends StatefulWidget {
  AudioRecordScreen({Key key}) : super(key: key);

  @override
  _AudioRecordScreenState createState() => _AudioRecordScreenState();
}

class _AudioRecordScreenState extends State<AudioRecordScreen> {
  Duration lastDuration;
  Duration playerDuration;
  Duration playerTotalDuration;
  StreamSubscription _recorderSubscription;
  FlutterSoundPlayer flutterSoundPlayer;
  FlutterSoundRecorder recorder;
  File lastFile;
  @override
  void initState() {
    super.initState();
    FlutterSoundRecorder().openAudioSession().then((value) {
      this.recorder = value;
    });
    FlutterSound().thePlayer.openAudioSession().then((value) {
      this.flutterSoundPlayer = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                lastDuration != null
                    ? Container(
                        alignment: Alignment.center,
                        height: 100,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 2.0)),
                        child: Text(
                          lastDuration.inSeconds.toString(),
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      )
                    : SizedBox.shrink(),
                OutlineButton(
                  child: Text("start"),
                  onPressed: () {
                    this.startRecording();
                  },
                ),
                OutlineButton(
                  child: Text("stop"),
                  onPressed: () {
                    this.stopRecording();
                  },
                ),
                OutlineButton(
                  child: Text("replay last"),
                  onPressed: () {
                    this.replayLast();
                  },
                ),
                playerDuration != null && playerTotalDuration != null
                    ? Container(
                        alignment: Alignment.center,
                        height: 100,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 2.0)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text(
                          playerDuration.inSeconds.toString(),
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Text(
                          playerTotalDuration.inSeconds.toString(),
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        ],)
                      )
                    : SizedBox.shrink(),
              ],
            )),
      ),
    );
  }

  startRecording() async {
    this.lastDuration = null;
    recorder.startRecorder(toFile: 'foo');
    this._recorderSubscription = recorder.onProgress.listen((event) {
      setState(() {
        this.lastDuration = event.duration;
      });
    });
  }

  stopRecording() async {
    _recorderSubscription.cancel();
    await flutterSoundPlayer
        .setSubscriptionDuration(Duration(milliseconds: 100));
    recorder.stopRecorder().then((value) {
      this.lastFile = File(value);
      this.startPlayer();
    });
  }

  startPlayer() {
     flutterSoundPlayer
          .startPlayer(fromURI: lastFile.path, whenFinished: () {})
          .then((value) {
        flutterSoundPlayer.onProgress.listen((event) {
          setState(() {
            this.playerDuration = event.position;
            this.playerTotalDuration = event.duration;
          });
        });
      });
      // file.readAsBytes()
      // .then((value) => print(value));
  }

  replayLast() {
    flutterSoundPlayer.startPlayer(fromURI: lastFile.path, whenFinished: () {});
  }

  @override
  void dispose() {
    super.dispose();
    flutterSoundPlayer.closeAudioSession();
    recorder.closeAudioSession();
  }
}
