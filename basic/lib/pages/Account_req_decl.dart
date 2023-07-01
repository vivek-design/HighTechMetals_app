import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../Uitilities/auth.dart';
class Account_req_declined extends StatefulWidget {
  const Account_req_declined({super.key});

  @override
  State<Account_req_declined> createState() => _Account_req_declinedState();
}

class _Account_req_declinedState extends State<Account_req_declined> {
  @override


  void logouttheuser() async {
             await FirebaseAuth.instance.currentUser?.delete(); 

  }
    
    void initState() {
      // TODO: implement initState
      logouttheuser();
      super.initState();
    }
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
                    
                  ],
                ),
              ),

              50.heightBox,
              Container(
                child: Center(
                  child: ("Your account Verification is being rejected  \n ".text.bold.italic.make()),
                ),
              )
             
        
      ],
          ),),
      ),
    );
  }
}