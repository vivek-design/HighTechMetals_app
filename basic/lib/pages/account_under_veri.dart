import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../Uitilities/auth.dart';

class account_under_veri extends StatefulWidget {
  const account_under_veri({super.key});

  @override
  State<account_under_veri> createState() => _account_under_veriState();
}

class _account_under_veriState extends State<account_under_veri> {
  @override
  Widget build(BuildContext context) {
    @override
   void logouttheuser() async {
      await Auth().signOut();
    }

    void initState() {
      // TODO: implement initState
      logouttheuser();
      super.initState();
    }

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
                  child: ("Your account is still under verification \n Try contacting admin and try again ".text.bold.italic.make()),
                ),
              ),
             
             50.heightBox,
             Container(
              child: Center(
                child: Image.asset("assets/images/pngwing.com.png",height: 50, ),
              ),
             )

        
      ],
          ),),
      ),
    );
  }
}
