import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
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
import '../Uitilities/auth.dart';

class Customer_fornt extends StatefulWidget {
  const Customer_fornt({super.key});

  @override
  State<Customer_fornt> createState() => _Customer_forntState();
}

class _Customer_forntState extends State<Customer_fornt> {
  @override
  DateTimeRange dateRange =
      DateTimeRange(start: DateTime(2023, 01, 01), end: DateTime.now());

  DatabaseReference df = FirebaseDatabase.instance.ref().child('Customer');
  Widget build(BuildContext context) {
    final start = dateRange.start;
    final end = dateRange.end;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: "Customer".text.make(),
        ),
        toolbarHeight: 90,
        backgroundColor: rang.always,
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                child: Center(
                  child: "Welcome".text.xl.bold.make(),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 70,
                width: 300,
                 decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(143, 148, 251, 1),
                          blurRadius: 20.0,
                          offset: Offset(0, 10))
                    ]),
                child: Center(
                  child:
                      "    As a customer you have authority to review \n    previous  orders "
                          .text
                          .semiBold
                          .make(),
                ),
              ),
              SizedBox(
                height: 30,
              ),

              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(143, 148, 251, 1),
                          blurRadius: 20.0,
                          offset: Offset(0, 10))
                    ]
                ),
                child: Column(
                children: [
                             Container(
                child: "Select the date range ".text.semiBold.make(),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 86,
                  ),
                  Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        InkWell(
                          onTap: () {
                            pickDateRange();
                          },
                          child: Container(
                            height: 80,
                            width: 80,
                            child:
                                Icon(Icons.calendar_today_outlined, size: 35),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                child: Row(
                  children: [
                    SizedBox(
                      width: 33,
                    ),
                    InkWell(
                      child: Container(
                        width: 100,
                        height: 40,
                       decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(143, 148, 251, 1),
                      Color.fromRGBO(143, 148, 251, 6),
                    ])),
                        child: Center(
                            child: Text(
                          '${start.year}/${start.month}/${start.day}',
                          style: TextStyle(color: Colors.white),
                        )),

                        // / Background color
                      ),
                    ),
                    SizedBox(width: 50),
                    InkWell(
                      child: Container(
                        width: 100,
                        height: 40,
                         decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(143, 148, 251, 1),
                      Color.fromRGBO(143, 148, 251, 6),
                    ])),
                        child: Center(
                            child: Text(
                          '${end.year}/${end.month}/${end.day}',
                          style: TextStyle(color: Colors.white),
                        )),

                        // / Background color
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 86,
                  ),
                  Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        Container(
                          height: 80,
                          width: 80,
                          child: Image.asset(
                            'assets/images/8726176_slider_h_range_icon.png',
                            height: 200,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
                ],
              ),),
            
              InkWell(
              onTap: () => {
                       Navigator.pushNamed(context, router.show_detail),
              },
              child:Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(143, 148, 251, 1),
                      Color.fromRGBO(143, 148, 251, 6),
                    ])),
                child: Center(
                  child: Text("View",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
              ),
              ),
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

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
        context: context,
        builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:rang.always, // header background color
              onPrimary: Colors.black, // header text color
              onSurface: Colors.green, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // button text color
              ),
            ),
          ),
          child: child!,
        );
        },
        initialDateRange: dateRange,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));

    if (newDateRange == null) {
      return;
    }

    setState(() {
      dateRange = newDateRange;
    });
  }
}
