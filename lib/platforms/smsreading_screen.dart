import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
// import 'package:sms/sms.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

class SmsReadingScreen extends StatefulWidget {
  SmsReadingScreen({Key key}) : super(key: key);

  @override
  _SmsReadingScreenState createState() => _SmsReadingScreenState();
}

class _SmsReadingScreenState extends State<SmsReadingScreen> {
  String signature;
  SmsQuery _smsQuery;
  
  List<SmsMessage> smsMessages;

  @override
  void initState() {
    super.initState();
    _smsQuery = SmsQuery();
    _startReadingSMS();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    
  }

  void _startReadingSMS() async {
    this.smsMessages = await this
        ._smsQuery
        .querySms(kinds: [SmsQueryKind.Inbox, SmsQueryKind.Sent]);
    setState(() {});
  }

  void _startListening() async {
    String signature = await SmsRetrieved.getAppSignature();
    print(signature);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SMS Listener App'),
        ),
        body: SingleChildScrollView(
                  child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 2,
                child: ListView.builder(
                    itemCount:
                        this.smsMessages != null ? this.smsMessages.length : 0,
                    itemBuilder: (context, index) {
                      return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.black)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(this.smsMessages[index].sender),
                              Text(this.smsMessages[index].body.toString()),
                            ],
                          ));
                    }),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                  height: MediaQuery.of(context).size.height / 2.6,
                color: Colors.blueGrey[100],
                  child: ListView(
                children: [
                  TextFieldPin(
                      filled: true,
                      filledColor: Colors.grey,
                      codeLength: 5,
                      boxSize: 46,
                      filledAfterTextChange: false,
                      textStyle: TextStyle(fontSize: 16),
                      borderStyle: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(34)),
                      onOtpCallback: (code, isAutofill) {
                        print(code);
                        setState(() {});
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  OutlineButton(
                    child: Text("Listen for code"),
                    onPressed: () {
                      this._startListening();
                    },
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
