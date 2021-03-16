import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:android_intent/android_intent.dart';

class GeolocationScreen extends StatefulWidget {
  GeolocationScreen({Key key}) : super(key: key);

  @override
  _GeolocationScreenState createState() => _GeolocationScreenState();
}

class _GeolocationScreenState extends State<GeolocationScreen> {
  Position position;
  List<Placemark> placemarks = [];

  void openLocationSetting() async {
    final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
  }

  @override
  Widget build(BuildContext context) {
    var scoffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scoffoldKey,
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            placemarks.length > 0
                ? Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        itemCount: this.placemarks.length,
                        itemBuilder: (context, index) {
                          return Container(
                              margin: EdgeInsets.only(bottom:20),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 2)),
                              child: Column(
                                children: [
                                  Text(this.placemarks[index].name),
                                  Text(this.placemarks[index].locality),
                                  Text(this.placemarks[index].postalCode),
                                  Text(this.placemarks[index].subAdministrativeArea),
                                  Text(this.placemarks[index].administrativeArea),
                                  Text(this.placemarks[index].country),
                                ],
                              ));
                        }),
                  )
                : SizedBox.shrink(),
            position != null
                ? Container(
                    padding: const EdgeInsets.all(20.0),
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.black)),
                    child: Text(
                      position.latitude.toString() +
                          "," +
                          position.longitude.toString(),
                      textAlign: TextAlign.center,
                    ))
                : SizedBox(),
            OutlineButton(
              child: Text("Get Current Lat/Lon"),
              onPressed: () {
                this.getCurrentPosition().then((value) {
                  this.position = value;
                  this.getAddress();
                })
                .catchError((err){
                  scoffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text("Location Service is Disabled"),
                  ));
                  this.openLocationSetting();
                });
              },
            ),
              OutlineButton(
              child: Text("Open Location Settings"),
              onPressed: () {
               this.openLocationSetting();
              },
            )
          ],
        ),
      ),
    );
  }

  void getAddress() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        this.position.latitude, this.position.longitude);
    setState(() {
      print(placemarks);
      this.placemarks = placemarks;
    });
  }

  Future getCurrentPosition() async {
    LocationPermission permission;

    // Test if location services are enabled.
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
