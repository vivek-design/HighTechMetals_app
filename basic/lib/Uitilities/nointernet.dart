import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

class No_internet extends StatefulWidget {
  const No_internet({super.key});

  @override
  State<No_internet> createState() => _No_internetState();
}

class _No_internetState extends State<No_internet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(children: [
          100.heightBox,
          Center(child: "  No internet \n Check connection and try again  ".text.bold.make()),
         Image.asset(
            "assets/images/No_Internet___Illustration-removebg-preview.png",
        
            height: 500,
            width: 500,
          )
        ]),
      ),
    );
  }
}
