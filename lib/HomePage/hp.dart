import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:student_record_bus/chat_bot/chatbot_screen.dart';
import 'dart:ui';

import '../Authentication/auth.dart';
import '../BusSchedule/bus_list.dart';
import '../BusSchedule/root_list.dart';
import '../Profile/profile.dart';
import '../track_buses/route_track.dart';

class MyCustomUI extends StatefulWidget {
  final Auth auth;

  const MyCustomUI({super.key, required this.auth});
  @override
  _MyCustomUIState createState() => _MyCustomUIState();
}

class _MyCustomUIState extends State<MyCustomUI>
    with SingleTickerProviderStateMixin {

  String regNo = "";
  String name = "";
  String firstLetter = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchEmail();
  }

  fetchEmail() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final data = await FirebaseDatabase.instance
        .ref()
        .child("Approve User")
        .child(uid)
        .get();

    Map values = data.value as Map;
    setState(() {
      regNo = values['Registeration No'];
      name = values['Name'];
      firstLetter = name[0];
    });
  }

  final db = FirebaseDatabase.instance.ref().child("User");
  goto() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const BusList()));
  }

  profile() {
    Navigator.push(
        context,
        PageTransition(
            child: const Profile(), type: PageTransitionType.rightToLeft));
  }

  busSchedule() {
    Navigator.push(
        context,
        PageTransition(
            child: const RoutList(), type: PageTransitionType.rightToLeft));
  }

  trackLocation() {
    Navigator.push(
        context,
        PageTransition(
            child: const RouteTrack(), type: PageTransitionType.rightToLeft));
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
        ),
        foregroundColor: Colors.white,
        title: const Text(
          "Home Page",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: const Icon(
        //       Icons.notifications,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       Navigator.of(context).push(MaterialPageRoute(
        //           builder: (context) => const Notifications()));
        //     },
        //     iconSize: 30,
        //   ),
        // ],
      ),
      drawer: Drawer(
        elevation: 0,
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
              decoration: const BoxDecoration(),
              child: UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Text(
                    firstLetter,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                accountName: Text(
                  regNo,
                  style: const TextStyle(fontSize: 20),
                ),
                accountEmail: Text(
                  name,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            // ListTile(
            //   title: const Text(
            //     "Profile",
            //     style: TextStyle(fontSize: 20),
            //   ),
            //   leading: const Icon(
            //     Icons.person,
            //     color: Colors.black,
            //   ),
            //   onTap: profile,
            // ),
            const Divider(),
            ListTile(
              title: const Text(
                "Log out",
                style: TextStyle(fontSize: 20),
              ),
              leading: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onTap: () async {
                await widget.auth.signOut();
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          /// ListView
          ListView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(_w / 17, _w / 50, 0, _w / 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'Home page',
                    //   style: TextStyle(
                    //     fontSize: 27,
                    //     color: Colors.black.withOpacity(.6),
                    //     fontWeight: FontWeight.w700,
                    //   ),
                    // ),
                    SizedBox(height: _w / 35),
                    Text(
                      '',
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.black.withOpacity(.5),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              homePageCardsGroup(
                color: const Color(0xfff37736),
                icon: Icons.analytics_outlined,
                color2: const Color(0xffFF6D6D),
                title: 'Track Bus',
                context: context,
                route: const RouteTrack(),
                icon2: Icons.all_inclusive,
                route2: const RoutList(),
                title2: 'Bus Schedule',
              ),
              homePageCardsGroup(
                color: Colors.lightGreen,
                icon: Icons.message_outlined,
                color2: const Color(0xffffa700),
                title: 'Chat Bot',
                context: context,
                route: const ChatBotScreen(),
                icon2: Icons.person,
                route2: const Profile(),
                title2: 'Student Profile',
              ),
            ],
          ),

          /// SETTING ICON
         
          // Blur the Status bar
          blurTheStatusBar(context),
        ],
      ),
    );
  }

  Widget homePageCardsGroup(
      {required Color color,
      required IconData icon,
      required String title,
      required BuildContext context,
      required Widget route,
      required Color color2,
      required IconData icon2,
      required String title2,
      required Widget route2}) {
    double _w = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(bottom: _w / 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          homePageCard(color, icon, title, context, route),
          homePageCard(color2, icon2, title2, context, route2),
        ],
      ),
    );
  }

  Widget homePageCard(Color color, IconData icon, String title,
      BuildContext context, Widget route) {
    double _w = MediaQuery.of(context).size.width;
    return Opacity(
      // opacity: _animation.value,
      opacity: .9,
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return route;
              },
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          height: _w / 2,
          width: _w / 2.4,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0xff040039).withOpacity(.15),
                blurRadius: 99,
              ),
            ],
            borderRadius: const BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(),
              Container(
                height: _w / 8,
                width: _w / 8,
                decoration: BoxDecoration(
                  color: color.withOpacity(.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color.withOpacity(.6),
                ),
              ),
              Text(
                title,
                maxLines: 4,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black.withOpacity(.5),
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget blurTheStatusBar(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
        child: Container(
          height: _w / 18,
          color: Colors.transparent,
        ),
      ),
    );
  }
}

class RouteWhereYouGo extends StatelessWidget {
  const RouteWhereYouGo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 50,
        centerTitle: true,
        shadowColor: Colors.black.withOpacity(.5),
        title: Text(
          'EXAMPLE  PAGE',
          style: TextStyle(
              color: Colors.black.withOpacity(.7),
              fontWeight: FontWeight.w600,
              letterSpacing: 1),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black.withOpacity(.8),
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
    );
  }
}
