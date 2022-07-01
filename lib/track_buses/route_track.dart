import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:student_record_bus/track_buses/track_bus.dart';


class RouteTrack extends StatefulWidget {
  const RouteTrack({Key? key}) : super(key: key);

  @override
  _RouteTrackState createState() => _RouteTrackState();
}

class _RouteTrackState extends State<RouteTrack> {
  final db = FirebaseDatabase.instance.ref().child("Bus Routes");

  Logger log = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Routes"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FirebaseAnimatedList(
          defaultChild: const Center(
              child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: Colors.blue,
          )),
          query: db,
          itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index)
          {

            final data = snapshot.key.toString();
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TrackBuses(
                            path: data,
                          )));
                },
                child: Container(
                  color: Colors.grey.shade300,
                  child: ListTile(
                    leading: Text(
                      data,
                      style: const TextStyle(
                           fontSize: 18),
                    ),
                    trailing: const Icon(Icons.location_on_outlined),
                  ),
                ),
              ),
            );
          },

        ),
      ),
    );
  }
}
