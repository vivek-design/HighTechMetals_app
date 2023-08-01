import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:basic/Uitilities/router.dart';
import '../Uitilities/auth.dart';

class fakeloged extends StatefulWidget {
  const fakeloged({super.key});

  @override
  State<fakeloged> createState() => _fakelogedState();
}

class _fakelogedState extends State<fakeloged> {
  @override

  displaytoast(String s, BuildContext context) {
    Fluttertoast.showToast(msg: s);
  }

  void navigateuser() async{
    
                        final user = Auth().currentUser;
      DatabaseReference databaseRefu = FirebaseDatabase
                              .instance
                              .ref("Inventory_manager");
                          var dataSnapshot;
                          await databaseRefu
                              .child(user!.uid)
                              .once()
                              .then((Event) {
                            dataSnapshot = Event.snapshot.exists;
                          });

                          DatabaseReference databaseRefu2 = FirebaseDatabase
                              .instance
                              .ref()
                              .child("Delivery_manager");

                          var datasnapshot2;
                          await databaseRefu2
                              .child(user.uid)
                              .once()
                              .then((Event) {
                            datasnapshot2 = Event.snapshot.exists;
                          });

                          DatabaseReference databaseRefu3 =
                              FirebaseDatabase.instance.ref().child("Owner");
                          var dataSnapshot3;
                          await databaseRefu3
                              .child(user.uid)
                              .once()
                              .then((Event) {
                            dataSnapshot3 = Event.snapshot.exists;
                          });

                          DatabaseReference databaseRefu4 =
                              FirebaseDatabase.instance.ref().child("Customer");
                          var dataSnapshot4;
                          await databaseRefu4
                              .child(user.uid)
                              .once()
                              .then((Event) {
                            dataSnapshot4 = Event.snapshot.exists;
                          });

                          if (dataSnapshot) {
                            displaytoast("loggin in ", context);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                router.InvFront, (route) => false);
                          } else if (datasnapshot2) {
                            displaytoast("loggin in ", context);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                router.delivfront, (route) => false);
                          } else if (dataSnapshot3) {
                            displaytoast("loggin in ", context);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                router.ownerfront, (route) => false);
                          } else if (dataSnapshot4) {
                            displaytoast("loggin in ", context);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                router.customerfront, (route) => false);
                          } else {
                            DatabaseReference databaseRefu5 = FirebaseDatabase
                                .instance
                                .ref()
                                .child("Pending_register");
                            var dataSnapshot5;
                            await databaseRefu5
                                .child(user.uid)
                                .once()
                                .then((Event) {
                              dataSnapshot5 = Event.snapshot.exists;
                            });

                            if (dataSnapshot5) {
                              Navigator.pushNamed(
                                  context, router.account_req_veri);
                              print("pending");
                            await  Auth().signOut();
                            } else {
                              Navigator.pushNamed(
                                  context, router.account_req_declined);
                              print("declined");
                            }
                          }
  }
  void initState() {
    // TODO: implement initState
    super.initState();
    navigateuser();
  }

  Widget build(BuildContext context) {
    return Scaffold(body:Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
          child: Lottie.network(
        "https://lottie.host/91c2aa90-5b11-4fc8-abb9-eed260bb1f7a/YyF1ubl5e6.json",
        repeat: true,
        height: 250,
        width: 250,
      )),
    ),
    );
  }
}
