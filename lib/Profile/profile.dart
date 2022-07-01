import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = "";
  String regNo = "";
  String password = "";
  String route = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final data = await FirebaseDatabase.instance
        .ref()
        .child("Approve User")
        .child(uid)
        .get();

    Map val = data.value as Map;

    setState(() {
      name = val["Name"];
      regNo = val["Registeration No"];
      password = val["password"];
      route = val["route"];
      email = val["Email"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Student Information")),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Center(
          child: Column(
            children: [
              Card(
                child: ListTile(
                  title: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Name : " + name),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Roll No : " + regNo),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Email : " + email),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Routes : " + route),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Password : " + password),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                elevation: 8,
                shadowColor: Colors.blue,
                margin: const EdgeInsets.all(20),
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue, width: 1)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
