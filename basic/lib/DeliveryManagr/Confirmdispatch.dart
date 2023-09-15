// ignore_for_file: public_member_api_docs, sort_constructors_first



import 'package:basic/Uitilities/router.dart';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../Uitilities/col.dart';
import '../Uitilities/nointernet.dart';
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
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        // Navigate to NoInternetPage if there is no internet connection
      
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) {
          return No_internet();
        })));
      }
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Confirm order summary".text.make(),
        backgroundColor: rang.always,
        toolbarHeight: 90,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: orders.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
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
                        5.heightBox,
                        Text(
                          'Timestamp: ${formatTimestamp(order.timestamp)}',
                          style: TextStyle(fontSize: 13),
                        ),
                        SizedBox(height: 4),
                        Text('Items:', style: TextStyle(fontSize: 13)),
                        FittedBox(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          // children: order.items
                          //     .map((item) =>
                          //         Text('- ${item.name}: \n Quantity: ${item.quantity} \n              '),)
                          //     .toList(),

                          child: DataTable(
                            dataRowHeight: 70,
                            columns: [
                              DataColumn(label: Text('Item Name')),
                              DataColumn(label: Text('Quantity')),
                              // DataColumn(label: Text('Remove'))
                            ],
                            rows: order.items
                                .map(
                                  (iteme) => DataRow(
                                    cells: [
                                      DataCell(Text(iteme.name,
                                          style: TextStyle(fontSize: 10))),
                                      DataCell(Text(iteme.quantity.toString())),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
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
                        Text('Timestamp: ${formatTimestamp(DateTime.now())}'),
                        SizedBox(height: 4),
                        Text('Items:'),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "--${ordred_item[index].name}    "
                                    .text
                                    .semiBold
                                    .make(),
                                5.heightBox,
                                " Ordered: ${ordred_item[index].quantity.toInt()}"
                                    .text
                                    .size(13)
                                    .make(),
                                5.heightBox,
                                " Dispatching: ${updated_quantity[index].toInt()}"
                                    .text
                                    .size(13)
                                    .make(),
                                5.heightBox,
                                " Remaining: ${(ordred_item[index].quantity - updated_quantity[index].toInt()) >= 0 ? (ordred_item[index].quantity - updated_quantity[index].toInt()) : 0}"
                                    .text
                                    .size(13)
                                    .make(),
                                25.heightBox
                              ],
                            ));
                          },
                          itemCount: ordred_item.length,
                        ),
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
                              hintText: "    Dispatch manager name ",
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
                      if (dispatch_id.text != "") {
                        var timestamp = widget.order.timestamp;
                        var order_id = widget.order.orderId;

                        //now delete the previous order

                        DatabaseReference ordersRef =
                            FirebaseDatabase.instance.ref().child('orders');

                        DatabaseEvent event = await ordersRef.once();
                        DataSnapshot dataSnapshot = event.snapshot;
                        dynamic orders = dataSnapshot.value;

                        orders.forEach((orderId, orderData) async {
                          dynamic useful = orders[orderId];
                          if (orderId == order_id) {
                            useful.forEach((id, value) async {
                           
                              if (value['timestamp'].toString() == timestamp.toString()) {
                           
                            
                                await ordersRef
                                    .child(orderId)
                                    .child(id)
                                    .remove();
                              }
                            });
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
                            'Dispatched_quantity': updated_quantity[i],
                            'Remaining quantity': ordred_item[i].quantity-updated_quantity[i]<0?0:ordred_item[i].quantity-updated_quantity[i],
                            'Ordered_quantity': ordred_item[i].quantity,
                            
                          });
                        }

                        if (dispatchedorderItems.isNotEmpty) {
                          _disorderRef.child(order_id).push().set({
                            'items': dispatchedorderItems,
                            'timestamp': DateTime.now().toString(),
                            'dipatch_id': dispatch_id.text,
                            'order_timestamp':timestamp.toString()
                          });
                        }

                        Navigator.of(context).pushNamedAndRemoveUntil(
                            router.dispatchsuccess, (route) => false);
                      } else {
                        displaytoast("Enter manager name first ", context);
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                                 rang.always,
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
      ),
    );
  }

  displaytoast(String s, BuildContext context) {
    Fluttertoast.showToast(msg: s);
  }

  String formatTimestamp(DateTime timestamp) {
    // Format the date
    String formattedDate = DateFormat('d MMMM yyyy').format(timestamp);

    // Format the time
    String formattedTime = DateFormat('h:mm a').format(timestamp);

    // Combine the formatted date and time
    String formattedDateTime = '$formattedDate ${formattedTime.toLowerCase()}';

    return formattedDateTime;
  }
}
