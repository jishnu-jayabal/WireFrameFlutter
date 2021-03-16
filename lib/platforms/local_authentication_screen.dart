import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthenticationScreen extends StatefulWidget {
  LocalAuthenticationScreen({Key key}) : super(key: key);

  @override
  _LocalAuthenticationScreenState createState() =>
      _LocalAuthenticationScreenState();
}

class _LocalAuthenticationScreenState extends State<LocalAuthenticationScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  @override
  void initState() {
    super.initState();
    this._checkBiometrics();
    this._getAvailableBiometrics();
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
            OutlineButton(
              child: Text("Authenticate FingerPrint"),
              onPressed: () {
                this.auth.authenticateWithBiometrics(
                    localizedReason: 'Scan your fingerprint to authenticate',
                    useErrorDialogs: true,
                    stickyAuth: true);
                // Android does'nt allow using screenlock and system pin
                // its only available in latest version of this package
              },
            )
          ],
        ),
      ),
    );
  }
}
