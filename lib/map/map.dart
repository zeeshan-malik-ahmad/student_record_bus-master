import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Track extends StatefulWidget {
  const Track({Key? key, required this.busNo}) : super(key: key);

  final String busNo;

  @override
  _TrackState createState() => _TrackState();
}

class _TrackState extends State<Track> {

  String latitude = "";
  String longitude = "";
  Completer<GoogleMapController> mapController = Completer();
  List<Marker> listMarker = <Marker>[];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPoints();
  }

  getPoints() async{
    final initialPoints =await FirebaseDatabase.instance.ref().child("Bus").child(widget.busNo).get();

    Map data = initialPoints.value as Map;

    setState(() {
      latitude = data['Latitude'];
      longitude = data['Longitude'];
    });

    double lati = double.parse(latitude);
    double long = double.parse(longitude);

    getMarker(lati, long, "peshawar");
  }

  getMarker(double fLati, double fLong, String location) async{
    Marker initialPointMarker = Marker(
      markerId: MarkerId(location),
      position: LatLng(fLati, fLong),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    );
    setState((){
      listMarker.add(initialPointMarker);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          myLocationEnabled: true,
          tiltGesturesEnabled: true,
          compassEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          markers: listMarker.map((e) => e).toSet(),
          onMapCreated: (GoogleMapController controller){
            mapController.complete(controller);
            getPoints();
          }, initialCameraPosition:const CameraPosition(
          target: LatLng(34.19 , 73.24),
          zoom: 10,
        ),
        ),
      ),
    );
  }

}


