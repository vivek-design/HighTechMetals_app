import 'package:basic/DeliveryManagr/delivery_front.dart';
import 'package:basic/DeliveryManagr/update_order.dart';
import 'package:basic/InvoiceManager/invoicemanager.dart';
import 'package:basic/Uitilities/dispatchsuccess.dart';
import 'package:basic/Uitilities/ordersuccess.dart';

import 'package:basic/Uitilities/router.dart';
import 'package:basic/customer/customer_front.dart';
import 'package:basic/customer/showdetail.dart';
import 'package:basic/pages/EmailaVerification.dart';
import 'package:basic/pages/gettingstart.dart';
import 'package:basic/pages/login.dart';
import 'package:basic/pages/register.dart';
import 'package:basic/pages/registerfor_Inv.dart';
import 'package:basic/pages/registerfor_deli.dart';
import 'package:basic/pages/splash_screen.dart';
import 'package:basic/pages/startpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';
import '../Uitilities/col.dart';
import 'Uitilities/auth.dart';
import 'Uitilities/circularpro.dart';
import 'firebase_options.dart';
import 'owner/ownerfront.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // data();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'High tech',
      initialRoute: router.home,
      routes: {
        router.center: (context) => Center_page(),
        router.getting: (context) => gettingstarted(),
        router.loginroute: (context) => login_page(),
        router.registerr: (context) => registerview(),
        router.emailveri: (context) => emailverified(),
        router.home: (context) => HomePage(title: "this"),
        router.registercustomer: (context) => registerview(),
        router.registerdeliv: (context) => registerfordeli(),
        router.registerinve: (context) => registerforinv(),
        router.InvFront: (context) => Invoice_front(),
        router.customerfront: (context) => Customer_fornt(),
        router.delivfront: (context) => deliv_front(),
        router.show_detail:(context)=>Show_detail(),
        router.successordrer:(context)=>order_success(),
        router.dispatchsuccess:(context)=>MyDialogBox(),
        router.ownerfront:(context)=>Owner_front(),
        
      },
      debugShowCheckedModeBanner: false,
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({Key? key, required String title}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  @override
  var value;
  bool customer = false;
  bool inventorymanager = false;
  bool deliverymanager = false;
  bool owner = false;
  Future<bool> data() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print(user.uid);
    }

    await Future.delayed(Duration(seconds: (2)));
    if (user == null) {
      print(1);
      return false;
    }
    DatabaseReference databaseRefu = FirebaseDatabase.instance.ref('Customer');
    var dataSnapshot;
    await databaseRefu.child(user!.uid).once().then((Event) {
      dataSnapshot = Event.snapshot.exists;
    });

    if (dataSnapshot == true) {
      value = false;
      print(2);
      customer = true;
      return true;
    } else {
      databaseRefu = FirebaseDatabase.instance.ref('Inventory_manager');

      await databaseRefu.child(user!.uid).once().then((Event) {
        dataSnapshot = Event.snapshot.exists;
      });

      if (dataSnapshot == true) {
        inventorymanager = true;
        return true;
      } else {
        databaseRefu = FirebaseDatabase.instance.ref('deliveymanager');

        await databaseRefu.child(user!.uid).once().then((Event) {
          dataSnapshot = Event.snapshot.exists;
        });

        if (dataSnapshot == true) {
          deliverymanager = true;
          return true;
        } else {
          owner = true;
          return true;
        }
      }
    }

    value = true;
    return true;
  }

  

  Widget build(BuildContext context) {
    //scaffold class for structure building in flutter
    displaytoast(String s, BuildContext context) {
      Fluttertoast.showToast(msg: s);
    }

    return FutureBuilder(
        future: data(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            User? user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              print(1);
              return home();
            }

            if (user.emailVerified == false) {
              print(Auth().currentUser);

              return emailverified();
            }

            if (owner) {
              return Owner_front();
            }

            if (inventorymanager) {
              return Invoice_front();
            }

            if (deliverymanager) {
              return deliv_front();
            }

            if (customer) {
              return Customer_fornt();
            }



            return Center_page();
          } else {
            return spash_Screen();
          }
        });
  }
}

class home extends StatelessWidget {
  const home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/light-1.png'),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/light-2.png'),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/clock.png'),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        child: Container(
                      child: Center(
                          child: Text(
                        "Welcome",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.white),
                      )),
                    )),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Center(
                  child: Text("Don't have an account ? Have one ",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(143, 147, 225, 1),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: InkWell(
                  onTap: () => {Navigator.pushNamed(context, router.getting)},
                  child: Ink(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [
                          Color.fromRGBO(143, 148, 251, 1),
                          Color.fromRGBO(143, 148, 251, 6),
                        ])),
                    child: Center(
                      child: Text("Create account ",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                child: Center(
                  child: Text("Already have an account ",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(143, 148, 251, 1),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: InkWell(
                  child: InkWell(
                    onTap: () =>
                        {Navigator.pushNamed(context, router.loginroute)},
                    child: Ink(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(colors: [
                            Color.fromRGBO(143, 148, 251, 1),
                            Color.fromRGBO(143, 148, 251, 6),
                          ])),
                      child: Center(
                        child: Text("Login",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
