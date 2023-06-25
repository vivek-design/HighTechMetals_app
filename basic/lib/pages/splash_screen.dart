import 'package:basic/Uitilities/circularpro.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class spash_Screen extends StatefulWidget {
  const spash_Screen({super.key});

  @override
  State<spash_Screen> createState() => _spash_ScreenState();
}

class _spash_ScreenState extends State<spash_Screen> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
      ),
      Positioned(
        top: 300,
        left: 105,
        child: Container(
          child: Image.asset("assets/images/logo.png"),
        ),
      ),
      Positioned(
          top: 400,
          left: 160,
          child: Container(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          ))
    ]);
  }
}
