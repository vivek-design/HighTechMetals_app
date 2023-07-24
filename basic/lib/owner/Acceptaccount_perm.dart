// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:basic/Uitilities/col.dart';
import 'package:basic/Uitilities/router.dart';
import 'package:basic/owner/ownerfront.dart';
import 'package:connectivity/connectivity.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../Uitilities/nointernet.dart';

class Accept_account_request extends StatefulWidget {
  const Accept_account_request({super.key});

  @override
  State<Accept_account_request> createState() => _Accept_account_requestState();
}

class _Accept_account_requestState extends State<Accept_account_request> {
  @override
  List<pending_request_model> ls = [];

  DatabaseReference pending_ref =
      FirebaseDatabase.instance.ref().child("Pending_register");

  Future<bool> get_Pending_request() async {
    pending_ref.onValue.listen((event) {
      ls.clear();
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? data =
            event.snapshot.value as Map<dynamic, dynamic>?;
        print(data);
        data?.forEach((orderKey, orderData) {
          var Name = orderData["Name"];
          var Age = orderData["Age"];
          var userid = orderKey;
          var Email = orderData["Email"];
          var role = orderData["role"];
          var gender = orderData["gender"];
          var phone = orderData["Phone"];
          var password = orderData["Password"];
          pending_request_model temp = pending_request_model(
              Role: role,
              Name: Name,
              Age: Age,
              gender: gender,
              phone: phone,
              Email: Email,
              User_id: userid,
              password: password);
          ls.add(temp);
        });
      }
    });

    await Future.delayed(Duration(seconds: 3));

    return true;
  }

  @override
  void initState() {

     Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        // Navigate to NoInternetPage if there is no internet connection
        print("IN there");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) {
          return No_internet();
        })));
      }
    });
    super.initState();
    get_Pending_request();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: get_Pending_request(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: "Pending account request".text.bold.white.make(),
              backgroundColor: rang.always,
            ),
            bottomNavigationBar: CurvedNavigationBar(
              color: rang.always,
              backgroundColor: Colors.white,
              index: 1,
              items: [
                Icon(Icons.home),
                Icon(Icons.manage_accounts),
              ],
              onTap: (index) async {
                if (index == 0) {
                  await Future.delayed(const Duration(seconds: 1));
                  index = 0;
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Owner_front()),
                      (Route<dynamic> route) => false);
                  setState(() {});
                }

                if (index == 1) {
                  await Future.delayed(const Duration(seconds: 1));
                  // index = 1;
                  // Navigator.pushNamed(context, router.accept_acc_req);
                  setState(() {});
                }
              },
            ),
            body: Container(
              child: Center(
                child: CircularProgressIndicator(
                  color: rang.always,
                ),
              ),
            ),
          );
        } else {
          if (ls.isEmpty) {
            // if the list is empty show the message
            return Scaffold(
              appBar: AppBar(
                title: "Pending account request".text.bold.white.make(),
                backgroundColor: rang.always,
              ),
              bottomNavigationBar: CurvedNavigationBar(
                color: rang.always,
                backgroundColor: Colors.white,
                index: 1,
                items: [
                  Icon(Icons.home),
                  Icon(Icons.manage_accounts),
                ],
                onTap: (index) async {
                  if (index == 0) {
                    await Future.delayed(const Duration(seconds: 1));
                    index = 0;
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Owner_front()),
                        (Route<dynamic> route) => false);
                    setState(() {});
                  }

                  if (index == 1) {
                    await Future.delayed(const Duration(seconds: 1));
                    // index = 1;
                    // Navigator.pushNamed(context, router.accept_acc_req);
                    setState(() {});
                  }
                },
              ),
              body: Container(
                child: Center(
                  child: "No Pending account requests".text.black.make(),
                ),
              ),
            );
          }

          // if the list is empty show the message
          return Scaffold(
            appBar: AppBar(
              title: "Pending account request".text.bold.white.make(),
              backgroundColor: rang.always,
            ),
            bottomNavigationBar: CurvedNavigationBar(
              color: rang.always,
              backgroundColor: Colors.white,
              index: 1,
              items: [
                Icon(Icons.home),
                Icon(Icons.manage_accounts),
              ],
              onTap: (index) async {
                if (index == 0) {
                  await Future.delayed(const Duration(seconds: 1));
                  index = 0;
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Owner_front()),
                      (Route<dynamic> route) => false);
                  setState(() {});
                }

                if (index == 1) {
                  await Future.delayed(const Duration(seconds: 1));
                  // index = 1;
                  // Navigator.pushNamed(context, router.accept_acc_req);
                  setState(() {});
                }
              },
            ),
            body: ListView.builder(
              itemCount: ls.length,
              itemBuilder: (BuildContext context, int index) {
                pending_request_model pending_request = ls[index];

                return Container(
                    padding: EdgeInsets.all(15),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(143, 148, 251, 1),
                                blurRadius: 20.0,
                                offset: Offset(0, 10))
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          'Username: ${pending_request.Name}'
                              .text
                              .bold
                              .red600
                              .make(),
                          10.heightBox,
                          Text('Role: ${pending_request.Role.toString()}'),
                          5.heightBox,
                          Text('Email: ${pending_request.Email.toString()}'),
                          5.heightBox,
                          Text('Gender: ${pending_request.gender.toString()}'),
                          5.heightBox,
                          Text('Age: ${pending_request.Age.toString()}'),
                          5.heightBox,
                          Text('Phone: ${pending_request.phone.toString()}'),
                          5.heightBox,
                          10.heightBox,
                          20.heightBox,
                          Row(
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    DatabaseReference _dbref =
                                        FirebaseDatabase.instance.ref();
                                    await _dbref
                                        .child(pending_request.Role)
                                        .child(pending_request.User_id)
                                        .set({
                                      'role': pending_request.Role,
                                      'Name': pending_request.Name,
                                      'Age': pending_request.Age,
                                      'gender': pending_request.gender,
                                      'Phone': pending_request.phone,
                                      'Email': pending_request.Email,
                                      'Password': pending_request.password,
                                      'userid': pending_request.User_id,
                                    });

                                    DatabaseReference _dbref2 =
                                        FirebaseDatabase.instance.ref();
                                    _dbref2
                                        .child("Pending_register")
                                        .child(pending_request.User_id)
                                        .remove();

                                    setState(() {
                                      ls.removeAt(index);
                                    });
                                  },
                                  child: "Approve".text.make(),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.green),
                                  )),
                              140.widthBox,
                              ElevatedButton(
                                  onPressed: () {
                                    DatabaseReference _dbref2 =
                                        FirebaseDatabase.instance.ref();
                                    _dbref2
                                        .child("Pending_register")
                                        .child(pending_request.User_id)
                                        .remove();

                                    setState(() {
                                      ls.removeAt(index);
                                    });
                                  },
                                  child: "Decline".text.make(),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll(rang.always),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ));
              },
            ),
          );
        }
      },
    );
  }
}

class pending_request_model {
  var Role;
  var Name;
  var Age;
  var gender;
  var phone;
  var Email;
  var User_id;
  var password;
  pending_request_model({
    required this.Role,
    required this.Name,
    required this.Age,
    required this.gender,
    required this.phone,
    required this.Email,
    required this.User_id,
    required this.password,
  });
}
