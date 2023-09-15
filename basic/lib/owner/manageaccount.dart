// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:basic/Uitilities/col.dart';
import 'package:basic/Uitilities/router.dart';


import 'package:connectivity/connectivity.dart';

import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:velocity_x/velocity_x.dart';

import '../Uitilities/nointernet.dart';

class manage_account_owner extends StatefulWidget {
  const manage_account_owner({super.key});

  @override
  State<manage_account_owner> createState() => _manage_account_ownerState();
}

class _manage_account_ownerState extends State<manage_account_owner> {
  @override
  List<AppUserDummy> customers = [];
  List<AppUserDummy> Employee = [];

  Future<bool> GetData() async {
    customers.clear();
    Employee.clear();
    DatabaseReference databaseReference =
        await FirebaseDatabase.instance.ref().child('Customer');
    await databaseReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
       
        data.forEach((key, value) => {
              //  print(value),
              customers.add(new AppUserDummy(
                name: value['Name'].toString(),
                email: value['Email'].toString(),
                phone: value['Phone'].toString(),
                gender: value['gender'],
                age: value['Age'],
                userid: value['userid'],
                role: "Customer".toString(),
              )),
            });
    
      }
    });

    DatabaseReference databaseReference2 =
        await FirebaseDatabase.instance.ref().child('Delivery_manager');
    await databaseReference2.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) => {
              //  print(value),
              Employee.add(new AppUserDummy(
                name: value['Name'].toString(),
                email: value['Email'].toString(),
                phone: value['Phone'].toString(),
                gender: value['gender'],
                age: value['Age'],
                userid: value['userid'],
                role: "Delivery Manager",
              )),
            });
       
      }
    });

    DatabaseReference databaseReference3 =
        await FirebaseDatabase.instance.ref().child('Inventory_manager');
    await databaseReference3.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) => {
              //  print(value),
              Employee.add(new AppUserDummy(
                name: value['Name'].toString(),
                email: value['Email'].toString(),
                phone: value['Phone'].toString(),
                gender: value['gender'],
                age: value['Age'],
                userid: value['userid'],
                role: "Invoice Manager",
              )),
            });
        
      }
    });
    await Future.delayed(Duration(seconds: 1));

    return true;
  }

  bool coloforcustomer = true;

  @override
  void initState() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        // Navigate to NoInternetPage if there is no internet connection
       
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) {
          return No_internet();
        })));
      }
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Accounts"),
        backgroundColor: rang.always,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            25.heightBox,
            Row(
              children: [
                30.widthBox,
                InkWell(
                  onTap: () {
                    setState(() {
                      coloforcustomer = !coloforcustomer;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 130,
                    child: Center(child: Text("Customers")),
                    decoration: BoxDecoration(
                      color: coloforcustomer ? rang.always : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(),
                    ),
                  ),
                ),
                20.widthBox,
                InkWell(
                  onTap: () {
                    setState(() {
                      coloforcustomer = !coloforcustomer;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 130,
                    child: Center(child: Text("Employee")),
                    decoration: BoxDecoration(
                      color: coloforcustomer ? Colors.white : rang.always,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(),
                    ),
                  ),
                ),
              ],
            ),
            50.heightBox,
            FutureBuilder(
              future: GetData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (coloforcustomer) {
                    return Expanded(
                      child: Container(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Container(
                                padding: EdgeInsets.all(15),
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromRGBO(
                                                143, 148, 251, 1),
                                            blurRadius: 20.0,
                                            offset: Offset(0, 10))
                                      ]),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      'Username: ${customers[index].name}'
                                          .text
                                          .bold
                                          .red600
                                          .make(),
                                      10.heightBox,
                                      Text(
                                          'Email: ${customers[index].email.toString()}'),
                                      5.heightBox,
                                      Text(
                                          'Gender: ${customers[index].gender.toString()}'),
                                      5.heightBox,
                                      Text(
                                          'Age: ${customers[index].age.toString()}'),
                                      5.heightBox,
                                      Text(
                                          'Phone: ${customers[index].phone.toString()}'),
                                      5.heightBox,
                                      Text(
                                          'Role: ${customers[index].role.toString()}'),
                                      10.heightBox,
                                      20.heightBox,
                                      Row(
                                        children: [
                                          190.widthBox,
                                          ElevatedButton(
                                              onPressed: () {
                                                DatabaseReference
                                                    databaseReference =
                                                    FirebaseDatabase.instance
                                                        .ref()
                                                        .child("Customer")
                                                        .child(customers[index]
                                                            .userid);
                                                databaseReference.remove();
                                                customers.removeAt(index);
                                                setState(() {
                                                  Navigator.pushNamed(
                                                      context,
                                                      router
                                                          .deltecompleteforowner);
                                                });
                                              },
                                              child: "Delete ".text.make(),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        rang.always),
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                ));
                          },
                          itemCount: customers.length,
                        ),
                      ),
                    );
                  }

                  if (!coloforcustomer) {
                    return Expanded(
                      child: Container(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Container(
                                padding: EdgeInsets.all(15),
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromRGBO(
                                                143, 148, 251, 1),
                                            blurRadius: 20.0,
                                            offset: Offset(0, 10))
                                      ]),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      'Username: ${Employee[index].name}'
                                          .text
                                          .bold
                                          .red600
                                          .make(),
                                      10.heightBox,
                                      Text(
                                          'Email: ${Employee[index].email.toString()}'),
                                      5.heightBox,
                                      Text(
                                          'Gender: ${Employee[index].gender.toString()}'),
                                      5.heightBox,
                                      Text(
                                          'Age: ${Employee[index].age.toString()}'),
                                      5.heightBox,
                                      Text(
                                          'Phone: ${Employee[index].phone.toString()}'),
                                      5.heightBox,
                                      Text(
                                          'Role: ${Employee[index].role.toString()}'),
                                      10.heightBox,
                                      20.heightBox,
                                      Row(
                                        children: [
                                          190.widthBox,
                                          ElevatedButton(
                                              onPressed: () {
                                                DatabaseReference
                                                    databaseReference =
                                                    FirebaseDatabase.instance
                                                        .ref()
                                                        .child(Employee[index]
                                                            .role)
                                                        .child(Employee[index]
                                                            .userid);
                                                databaseReference.remove();
                                                Employee.removeAt(index);
                                                setState(() {});
                                              },
                                              child: "Delete ".text.make(),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        rang.always),
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                ));
                          },
                          itemCount: Employee.length,
                        ),
                      ),
                    );
                  }
                }
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: rang.always,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AppUserDummy {
  String name;
  String email;
  String phone;
  String gender;
  String age;
  String userid;
  String role;
  AppUserDummy({
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.age,
    required this.userid,
    required this.role,
  });
}
