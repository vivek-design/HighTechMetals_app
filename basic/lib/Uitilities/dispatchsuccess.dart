import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:basic/InvoiceManager/invoicemanager.dart';
import 'package:basic/Uitilities/col.dart';
import 'package:basic/Uitilities/router.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class MyDialogBox extends StatefulWidget {
  @override
  _MyDialogBoxState createState() => _MyDialogBoxState();
}

class _MyDialogBoxState extends State<MyDialogBox> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
         decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80)
         ),
        height: 250,
        child: Column(children: [
          10.heightBox,
          Container(
            child: "Dispached".text.bold.xl2.make(),
          ),
          20.heightBox,
          Center(
              child: Image.asset(
            'assets/images/order-placed-purchased-icon.png',
            width: 130,
          )),
              20.heightBox,
          Container(child: ElevatedButton(onPressed:()=>{
         Navigator.of(context).pushNamedAndRemoveUntil(
                              router.delivfront, (route) => false)
          } , child: "Done".text.make(),style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(rang.always))),width: 100,)
        ]),
      ),
    );
  }
}

// Usage
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Screen'),
      ),
      body: Center(
        child: MyDialogBox(),
      ),
    );
  }
}
