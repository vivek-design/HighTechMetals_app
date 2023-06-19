import 'package:flutter/material.dart';
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

import '../DeliveryManagr/delivery_front.dart';
class Owner_front extends StatefulWidget {
  const Owner_front({super.key});

  @override
  State<Owner_front> createState() => _Owner_frontState();
}

class _Owner_frontState extends State<Owner_front> {
   late DatabaseReference _orderRef;
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    _orderRef = FirebaseDatabase.instance.ref().child('Dispatched');
    _orderRef.onValue.listen((event) {
      orders.clear();
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? data =
            event.snapshot.value as Map<dynamic, dynamic>?;
        data?.forEach((orderKey, orderData) {
          orderData.forEach((key, value) {
            List<dynamic> itemsData = value['items'];
            List<Item> items = itemsData
                .map((itemData) => Item(itemData['name'], itemData['quantity']))
                .toList();
            Order order =
                Order(orderKey, items, DateTime.parse(value['timestamp']));
            orders.add(order);
          });
        });
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All dispatched Orders'),
        backgroundColor: rang.always,
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (BuildContext context, int index) {
          Order order = orders[index];
          // return ListTile(
          //   title: Text('Order ID: ${order.orderId}'),
          //   subtitle: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text('Timestamp: ${order.timestamp.toString()}'),
          //       SizedBox(height: 4),
          //       Text('Items:'),
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: order.items
          //             .map((item) => Text('- ${item.name}: ${item.quantity}'))
          //             .toList(),
          //       ),
          //     ],
          //   ),
          // );

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
                    'Order ID: ${order.orderId}'.text.bold.red600.make(),
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
  }
}