import 'package:basic/InvoiceManager/invoicemanager.dart';
import 'package:basic/Uitilities/col.dart';
import 'package:basic/Uitilities/router.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class order_success extends StatefulWidget {
  const order_success({super.key});

  @override
  State<order_success> createState() => _order_successState();
}

class _order_successState extends State<order_success> {
  @override
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
            child: "Ordered".text.bold.xl2.make(),
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
                              router.InvFront, (route) => false)
          } , child: "Done".text.make(),style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(rang.always))),width: 100,)
        ]),
      ),
    );
  }
}
