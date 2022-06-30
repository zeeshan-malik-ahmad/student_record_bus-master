import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../secrets.dart';

class ViewRoot extends StatefulWidget {
  const ViewRoot({Key? key, required this.path, required this.busNo, required this.latLng}) : super(key: key);

  final String path;
  final String busNo;
  final List<LatLng> latLng;

  @override
  _ViewRootState createState() => _ViewRootState();
}

class _ViewRootState extends State<ViewRoot> {

  GoogleMapController? mapController;
  List<Marker> listMarker = <Marker>[];

  late PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData()async{

    for(int i=0; i < widget.latLng.length; i++)
    {
      print(widget.latLng[i].latitude);
      double lati = widget.latLng[i].latitude;
      double long = widget.latLng[i].longitude;
      getMarker(lati, long, "peshawar");
    }
  }

  getMarker(double fLati, double fLong, String location) async{
    Marker initialPointMarker = Marker(
      markerId: MarkerId(location),
      position: LatLng(fLati, fLong),
      icon: BitmapDescriptor.defaultMarker,
    );
    setState((){
      listMarker.add(initialPointMarker);
    });
    _createPolylines();
  }

  _createPolylines() async {
    polylinePoints = PolylinePoints();
    await polylinePoints
        .getRouteBetweenCoordinates(
      Secrets.kApiKey,
      PointLatLng(widget.latLng[widget.latLng.length - 1].latitude,
          widget.latLng[widget.latLng.length - 1].longitude), //Starting LATLANG
      PointLatLng(
          widget.latLng[0].latitude, widget.latLng[0].longitude), //End LATLANG

      travelMode: TravelMode.driving,
    )
        .then((value) {
      for (var point in value.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    });

    PolylineId id = const PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
    polylines.addAll(polylines);
    setState(() {});
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: GoogleMap(
        markers: listMarker.map((e) => e).toSet(),
        onMapCreated: (controller){
          mapController = controller;
        },
        initialCameraPosition:const CameraPosition(
          target: LatLng(34.16, 73.22),
          zoom: 10,
        ),
        polylines: Set<Polyline>.of(polylines.values),
      ),
    );
  }
}
