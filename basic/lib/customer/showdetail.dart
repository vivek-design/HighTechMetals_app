// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ffi';

import 'package:basic/Uitilities/auth.dart';
import 'package:basic/Uitilities/col.dart';
import 'package:basic/Uitilities/router.dart';
import 'package:basic/Uitilities/router.dart';
import 'package:basic/pages/login.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../DeliveryManagr/delivery_front.dart';

class Show_detail extends StatefulWidget {
  var username;
  DateTimeRange dateTimeRange;
  Show_detail({
    Key? key,
    required this.username,
    required this.dateTimeRange,
  }) : super(key: key);

  @override
  State<Show_detail> createState() => _Show_detailState();
}

class _Show_detailState extends State<Show_detail> {
  @override
  late DatabaseReference _orderRef;
  List<Order> orders = [];
  void initState() {
    super.initState();
  }

  Future<bool> getdetail() async {
    print(widget.username);
    _orderRef = FirebaseDatabase.instance
        .ref()
        .child('Dispatched')
        .child(widget.username);
    await _orderRef.onValue.listen((event) {
      orders.clear();

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? data =
            event.snapshot.value as Map<dynamic, dynamic>?;
        // data?.forEach((orderKey, orderData) {
        // orderData
        data?.forEach((key, value) async {
          print(value);
          List<dynamic> itemsData = value['items'];
          List<Item> items = await itemsData
              .map((itemData) => Item(itemData['name'], itemData['quantity']))
              .toList();

          DateTime? timestamp = DateTime.tryParse(value['timestamp']);
          var dipatch_id = value['dipatch_id'].toString();
          // print(timestamp);
          if (timestamp!.isAfter(widget.dateTimeRange.start) &&
              timestamp.isBefore(widget.dateTimeRange.end)) {
            Order order = Order(key, items, DateTime.parse(value['timestamp']),dipatch_id);
            orders.add(order);
          }
        });
      }

      print(orders);
    });
    await Future.delayed(Duration(seconds: 2));
    return true;
  }

  // );
  // }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   // animationController.dispose() instead of your controller.dispose
  // }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getdetail(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Center(
                  child: "Details".text.make(),
                ),
                toolbarHeight: 90,
                backgroundColor: rang.always,
              ),
              body: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (BuildContext context, int index) {
                  Order order = orders[index];

                  return Container(
                      padding: EdgeInsets.all(15),
                      child: Container(
                        padding: EdgeInsets.all(5),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            'Order ID: ${order.orderId}'
                                .text
                                .bold
                                .red600
                                .make(),
                                  4.heightBox,
                            'Dispatch ID: ${order.dispatch_id}'.text.bold.red600.make(),
                            Text('Timestamp: ${order.timestamp.toString()}'),
                            SizedBox(height: 4),
                            Text('Items:'),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: order.items
                                  .map((item) =>
                                      Text('- ${item.name}: ${item.quantity}'))
                                  .toList(),
                            ),
                            20.heightBox,
                          ],
                        ),
                      ));
                },
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
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Center(
                  child: "Details".text.make(),
                ),
                toolbarHeight: 90,
                backgroundColor: rang.always,
              ),
              body: Container(
                child: Center(
                    child: CircularProgressIndicator(color: rang.always)),
              ),
            );
          }
        });
  }
}
