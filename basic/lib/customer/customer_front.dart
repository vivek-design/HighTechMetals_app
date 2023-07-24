import 'package:basic/customer/showdetail.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import '../Uitilities/nointernet.dart';

class Customer_fornt extends StatefulWidget {
  const Customer_fornt({super.key});

  @override
  State<Customer_fornt> createState() => _Customer_forntState();
}

class _Customer_forntState extends State<Customer_fornt> {
  @override
  DateTimeRange dateRange =
      DateTimeRange(start: DateTime(2023, 01, 01), end: DateTime.now());
  late var Username;

  @override
  Future<bool> findUsername() async {
    User? user = await FirebaseAuth.instance.currentUser;
    DatabaseReference _dbref =
       await FirebaseDatabase.instance.ref().child("Customer").child(user!.uid);
    DatabaseEvent dbenvent = await _dbref.once();
    // print(dbenvent.snapshot.value);
    Map<dynamic, dynamic>? map = await dbenvent.snapshot.value as Map?;
    Username = await map!['Name'];
    return true;
  }

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
  }

  DatabaseReference df = FirebaseDatabase.instance.ref().child('Customer');
  Widget build(BuildContext context) {
    final start = dateRange.start;
    final end = dateRange.end;
    return 
    
    
    FutureBuilder(
        future: findUsername(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            
            return  Scaffold(
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
                  child: "Welcome  ${Username}".text.xl.bold.make(),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 70,
                width: double.infinity,
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
                          .italic
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
                    ]),
                child: Column(
                  children: [
                    20.heightBox,
                    Container(
                      child:
                          "Select the date range ".text.semiBold.italic.make(),
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
                                  child: CircleAvatar(
                                    child: Icon(Icons.calendar_today_outlined),
                                    backgroundColor: rang.always,
                                    radius: 5,
                                  ),
                                  // child: CircualrIcon(Icons.calendar_today_outlined,
                                  //     size: 35),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    30.heightBox,
                   
                          Row(
                            children:[ 
                              20.widthBox,
                              "From :          ".text.bold.make(),
                               Container(
                                width: 150,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(226, 53, 57, 1),
                                      Color.fromRGBO(226, 53, 57, 5),
                                    ])),
                                child: Center(
                                    child: Text(
                                  '${start.year}/${start.month}/${start.day}',
                                  style: TextStyle(color: Colors.white),
                                )),
                          
                                // / Background color
                              ),
                            
                            ]
                          ),

                          30.heightBox,

                           Row(
                            children:[ 
                              20.widthBox,
                              "To:               ".text.bold.make(),
                               Container(
                                width: 150,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(226, 53, 57, 1),
                                      Color.fromRGBO(226, 53, 57, 5),
                                    ])),
                                child: Center(
                                  child: Text(
                                '${end.year}/${end.month}/${end.day}',
                                style: TextStyle(color: Colors.white),
                              )),
                                // / Background color
                              ),
                            
                            ]
                          ),
                       

                        
                     
                    
                    
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              60.heightBox,
              InkWell(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Show_detail(
                              username: Username, dateTimeRange: dateRange))),
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(226, 53, 57, 1),
                        Color.fromRGBO(226, 53, 57, 5),
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
          }else{
            return Scaffold(
            body: Container(
                child: Center(
              child: CircularProgressIndicator(
                color: rang.always,
              ),
            )),
          );
        }
  });
          }

          
  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: rang.always, // header background color
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
  
  

