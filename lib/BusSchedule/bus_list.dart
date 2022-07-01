import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:student_record_bus/BusSchedule/root_list.dart';
import 'package:student_record_bus/BusSchedule/view_stations.dart';

// import '../HomePage/home_page.dart';



class BusList extends StatefulWidget {
  const BusList({Key? key,  this.path}) : super(key: key);

  final String? path;
  @override
  State<BusList> createState() => _BusListState();
}

class _BusListState extends State<BusList> {
  final db = FirebaseDatabase.instance.ref().child("Bus Routes");

  @override
  Widget build(BuildContext context){
    final reference = db.child(widget.path!).child("Buses");
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const RoutList()));
            },
            icon: const Icon(Icons.arrow_back)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.blue
          ),
        ),
        title:const Text("Bus Schedule"),
        centerTitle: true,
        
      ),

      body: Padding(
        padding:const EdgeInsets.symmetric(horizontal: 20.0),
        child: FirebaseAnimatedList(
          defaultChild: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: Colors.black,
            ),
          ),
          query: reference,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,Animation animation ,int index){

            String busName = snapshot.key.toString();
            // print(busName);
            return Container(
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Stations(busNo: busName, path: widget.path,) ));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20.0)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ListTile(
                        leading: Text(
                          "Bus No : " + busName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        trailing: const Icon(Icons.train_sharp),
                      ),
                    ),
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