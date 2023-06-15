import 'package:flutter/material.dart';
import 'package:basic/Uitilities/auth.dart';
import 'package:basic/Uitilities/col.dart';
import 'package:basic/Uitilities/router.dart';
import 'package:basic/pages/login.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:basic/Uitilities/router.dart';
class Owner_front extends StatefulWidget {
  const Owner_front({super.key});

  @override
  State<Owner_front> createState() => _Owner_frontState();
}

class _Owner_frontState extends State<Owner_front> {
  @override
   DatabaseReference df = FirebaseDatabase.instance.ref().child('User');
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: "in ".text.make(),
        ),
        toolbarHeight: 90,
        backgroundColor: rang.always,
      ),
      body: SafeArea(
        child:

            // Container(
            //   padding: EdgeInsets.all(20),
            //   child: Center(
            //       child: "List of all the registered user is "
            //           .text
            //           .bold
            //           .black
            //           .make()),
            // ),

            Container(
          height: double.infinity,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              FirebaseAnimatedList(
                  query: df,
                  shrinkWrap: true,
                  itemBuilder: (context, snapshot, animation, index) {
                    return Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(6)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "  Email :  ${snapshot.child('Email').value.toString()}"),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              "  Name : ${snapshot.child('Name').value.toString()}"),
                          SizedBox(
                            height: 5,
                          ),
                          Text("  Age ${snapshot.child('Age').value.toString()}"),
                          SizedBox(
                            height: 5,
                          ),
                          Text("  Phone ${ snapshot.child('Phone').value.toString()}"),
                        ],
                      ),
                    );
                    
                  }),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        width: 200,
        child: Container(
          child: Column(children: [
            SizedBox(
              height: 125,
              child: Container(
                color: rang.always,
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: "Logout".text.make(),
              onTap: () => {
                Auth().signOut(),
                Navigator.of(context).pushNamedAndRemoveUntil(
                    router.loginroute, (route) => false),
              },
            )
          ]),
        ),
      ),
    );
  }
}