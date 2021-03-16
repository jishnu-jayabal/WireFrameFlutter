import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketioScreen extends StatefulWidget {
  SocketioScreen({Key key}) : super(key: key);

  @override
  _SocketioScreenState createState() => _SocketioScreenState();
}

class _SocketioScreenState extends State<SocketioScreen> {
  List<String> messages = [];
  Socket socket;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
            Expanded(
              child: OutlineButton(
                child: Text("Send Message"),
                onPressed: () {
                  this.sendMessage("messageskl;sklsklklk");
                },
              ),
            ),
            SizedBox(width: 20,),
            Expanded(
                          child: OutlineButton(
                child: Text("Connect to server"),
                onPressed: () {
                  this.connectToServer();
                },
              ),
            )
        ],
      ),
          )),
      body: Container(
        
        padding: EdgeInsets.all(20),
        child: ListView.builder(
            itemCount: this.messages.length,
            itemBuilder: (context, i) {
              return Container(
                child: Text(messages[i],
                // textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,),
              );
            }),
      ),
    );
  }

  void connectToServer() {
    try {
      this.socket = io('http://localhost:3000',OptionBuilder()
      .setTransports(['websocket']) // for Flutter or Dart VM
      .setExtraHeaders({'foo': 'bar'}) // optional
      .build());
      socket.onConnect((data) => print("connected>>>>>>>>>>>>>>>"));
      socket.on('event', (data) => print(data));
      socket.on('errur', (data) => print(data));
       socket.on('message', (data) {
         setState(() {
           this.messages.add(data);
         });
       });
      socket.on('disconnect', (_) => print('disconnect'));
      socket.on('fromServer', (_) => print(_));
    } catch (e) {
      print(e);
    }
  }

  sendMessage(String message) {
    socket.emit(
      "message",
      {
        "id": socket.id,
        "message": message, // Message to be sent
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    this.socket.close();
  }
}
