// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ffi';

import 'package:basic/Uitilities/dispatchsuccess.dart';
import 'package:basic/Uitilities/router.dart';
import 'package:basic/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../Uitilities/col.dart';
import 'delivery_front.dart';

class Confirm_order_update extends StatefulWidget {
  final Order order;
  final List<int> slider_values;
  const Confirm_order_update({
    Key? key,
    required this.order,
    required this.slider_values,
  }) : super(key: key);

  @override
  State<Confirm_order_update> createState() => _Confirm_order_updateState();
}

class _Confirm_order_updateState extends State<Confirm_order_update> {
  late List<Item> ordred_item = widget.order.items;
  late List<Order> orders = [widget.order];
  late final TextEditingController dispatch_id;
  late List<int> updated_quantity = widget.slider_values;
  @override
  void initState() {
    // TODO: implement initState
    dispatch_id = TextEditingController();

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Confirm order summary".text.make(),
        backgroundColor: rang.always,
        toolbarHeight: 90,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (BuildContext context, int index) {
            Order order = orders[index];

            return Container(
              padding: EdgeInsets.all(15),
              child: Column(children: [
                "Ordered summary".text.bold.lg.make(),
                10.heightBox,
                Container(
                  padding: EdgeInsets.all(5),
                  width: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(143, 148, 251, 1),
                        blurRadius: 20.0,
                        offset: Offset(0, 10),
                      )
                    ],
                  ),
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
                            .map(
                              (item) => Text(
                                '- ${item.name}:    ${item.quantity}',
                              ),
                            )
                            .toList(),
                      ),
                      20.heightBox,
                    ],
                  ),
                ),
                50.heightBox,

                "Updated Ordered summary".text.bold.lg.make(),
                10.heightBox,
                Container(
                  padding: EdgeInsets.all(5),
                  width: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(143, 148, 251, 1),
                        blurRadius: 20.0,
                        offset: Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      'Order ID: ${order.orderId}'.text.bold.red600.make(),
                      Text('Timestamp: ${DateTime.now().toString()}'),
                      SizedBox(height: 4),
                      Text('Items:'),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          //   // children: order.items
                          //   //     .map(
                          //   //       (item) => Text(
                          //   //         '- ${item.name}:    ${item.quantity}',
                          //   //       ),
                          //   //     )

                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Container(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    "--${ordred_item[index].name}    "
                                        .text
                                        .make(),
                                    5.heightBox,
                                    " quantity:${updated_quantity[index].toInt()}"
                                        .text
                                        .make(),
                                    5.heightBox,
                                    " Remaining:${(ordred_item[index].quantity - updated_quantity[index].toInt())>=0?(ordred_item[index].quantity - updated_quantity[index].toInt()):0}"
                                        .text
                                        .make(),
                                    25.heightBox
                                  ],
                                ));
                              },
                              itemCount: ordred_item.length,
                            )
                          ]),
                      20.heightBox,
                    ],
                  ),
                ),
                30.heightBox,

                Container(
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
                  child: Container(
                    padding: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(),
                    child: TextFormField(
                        controller: dispatch_id,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "    Dispatch id  ",
                            hintStyle: TextStyle(color: Colors.grey[400])),
                        validator: (value) {
                          if (value != null) if (value.isEmpty) {
                            return "Email or phone number cannot be empty ";
                          }
                          return null;
                        }),
                  ),
                ),
                50.heightBox,
                // Dispatch button
                InkWell(
                  onTap: () async {
                    //  first store the timestamp and order id
                    var timestamp = widget.order.timestamp;
                    var order_id = widget.order.orderId;

                    //now delete the previous order

                    DatabaseReference ordersRef =
                        FirebaseDatabase.instance.ref().child('orders');

                    DatabaseEvent event = await ordersRef.once();
                    DataSnapshot dataSnapshot = event.snapshot;
                    dynamic orders = dataSnapshot.value;

                    orders.forEach((orderId, orderData) async {
                      // DatabaseEvent event2 = await orders[orderId].once();
                      // DataSnapshot dataSnapshot = event.snapshot;
                      // dynamic useful = dataSnapshot.value;

                      dynamic useful = orders[orderId];
                      // print(useful[]);

                      // print(useful['items']);
                      if ( //useful['timestamp'] == timestamp.toString() &&
                          orderId == order_id) {
                        print("Yes");
                        print(order_id);
                        await ordersRef.child(orderId).remove();
                      }
                    });

                    //  now update the new one order if the something is remaining in there
                    DatabaseReference _orderRef =
                        FirebaseDatabase.instance.ref().child('orders');
                    List<Map<String, dynamic>> updateorderItems = [];
                    for (int i = 0; i < ordred_item.length; i++) {
                      if (!(updated_quantity[i] >= ordred_item[i].quantity))
                        updateorderItems.add({
                          'name': ordred_item[i].name,
                          'quantity':
                              ordred_item[i].quantity - updated_quantity[i],
                        });
                    }

                    if (updateorderItems.isNotEmpty) {
                      _orderRef.child(order_id).push().set({
                        'items': updateorderItems,
                        'timestamp': timestamp.toString(),
                      });
                    }

                    //now add into dispatched section now from here user can get the required data of the dispatched item
                    DatabaseReference _disorderRef =
                        FirebaseDatabase.instance.ref().child('Dispatched');
                    List<Map<String, dynamic>> dispatchedorderItems = [];
                    for (int i = 0; i < ordred_item.length; i++) {
                      dispatchedorderItems.add({
                        'name': ordred_item[i].name,
                        'quantity': updated_quantity[i],
                      });
                    }

                    if (dispatchedorderItems.isNotEmpty) {
                      _disorderRef.child(order_id).push().set({
                        'items': dispatchedorderItems,
                        'timestamp': DateTime.now().toString(),
                        'dipatch_id': dispatch_id.text,
                      });
                    }

                    Navigator.of(context).pushNamedAndRemoveUntil(
                        router.dispatchsuccess, (route) => false);
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(226, 53, 57, 1),
                          Color.fromRGBO(226, 53, 57, 5),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Dispatch',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            );
          },
        ),
      ),
    );
  }
}
