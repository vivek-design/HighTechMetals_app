import 'package:basic/Uitilities/router.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class gettingstarted extends StatefulWidget {
  const gettingstarted({super.key});

  @override
  State<gettingstarted> createState() => _gettingstartedState();
}

class _gettingstartedState extends State<gettingstarted> {
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
                        top: 225,
                        left: 90,
                        child: Container(
                          child: Center(
                              child: Text(
                            "Getting started",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: Colors.white),
                          )),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(height: 30),
              Container(
                child: Center(
                  child: Text("Register as a Inventory manager  ",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(226, 53, 57, 1),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: InkWell(
                  child: InkWell(
                    onTap: () =>
                        {Navigator.pushNamed(context, router.registerinve)},
                    child: Ink(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(colors: [
                            Color.fromRGBO(226, 53, 57, 1),
                            Color.fromRGBO(226, 53, 57, 5),
                          ])),
                      child: Center(
                        child: Text("Register as invantory manager",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Center(
                  child: Text("Register as a  Delivery manager ",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(226, 53, 57, 1),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: InkWell(
                  child: InkWell(
                    onTap: () =>
                        {Navigator.pushNamed(context, router.registerdeliv)},
                    child: Ink(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(colors: [
                            Color.fromRGBO(226, 53, 57, 1),
                            Color.fromRGBO(226, 53, 57, 5),
                          ])),
                      child: Center(
                        child: Text("Register as Delivery manager",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Center(
                  child: Text("Register as a customer  ",
                      style: TextStyle(
                        fontSize: 15,
                        color:   Color.fromRGBO(226, 53, 57, 1),
                          
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: InkWell(
                  child: InkWell(
                    onTap: () =>
                        {Navigator.pushNamed(context, router.registerr)},
                    child: Ink(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(colors: [
                            Color.fromRGBO(226, 53, 57, 1),
                            Color.fromRGBO(226, 53, 57, 5),
                          ])),
                      child: Center(
                        child: Text("Register as Customer",
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
