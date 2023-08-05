// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ffi';

import 'package:basic/Uitilities/auth.dart';
import 'package:basic/Uitilities/col.dart';
import 'package:basic/Uitilities/router.dart';
import 'package:basic/Uitilities/router.dart';
import 'package:basic/pages/login.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../DeliveryManagr/delivery_front.dart';
import '../Uitilities/nointernet.dart';

class Show_detail extends StatefulWidget {
  var username;
  bool is_today;
  DateTimeRange dateTimeRange;
  Show_detail({
    Key? key,
    required this.username,
    required this.is_today,
    required this.dateTimeRange,
  }) : super(key: key);

  @override
  State<Show_detail> createState() => _Show_detailState();
}

class _Show_detailState extends State<Show_detail> {
  @override
  late DatabaseReference _orderRef;
  List<Orderfordispatch> orders = [];
  void initState() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        // Navigate to NoInternetPage if there is no internet connection
        print("IN there");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) {
          return No_internet();
        })));
      }
    });
    super.initState();
  }

  int mycomp(Orderfordispatch d1, Orderfordispatch d2) {
    if (d1.timestamp.isBefore(d2.timestamp)) {
      return 1;
    }

    return -1;
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
          List<Itemfordispatchsummry> items = await itemsData
              .map((itemData) => Itemfordispatchsummry(
                  itemData['name'].toString(),
                  itemData['Remaining quantity'].toString(),
                  itemData['Dispatched_quantity'].toString(),
                  itemData['Ordered_quantity'].toString()))
              .toList();

          DateTime? timestamp = DateTime.tryParse(value['timestamp']);
          var dipatch_id = value['dipatch_id'].toString();
          // print(timestamp);

          if (widget.is_today == false) {
            if (timestamp!.isAfter(
                    widget.dateTimeRange.start.subtract(Duration(days: 1))) &&
                timestamp.isBefore(
                    widget.dateTimeRange.end.add(Duration(days: 1)))) {
              Orderfordispatch order = Orderfordispatch(
                  key,
                  items,
                  DateTime.parse(value['timestamp']),
                  dipatch_id,
                  DateTime.parse(value['order_timestamp']));
              orders.add(order);
            }
          } else {
            DateTime temp = DateTime.now();

            if(timestamp!.day ==temp.day && timestamp.month==temp.month && timestamp.year==temp.year ){
                         Orderfordispatch order = Orderfordispatch(
                  key,
                  items,
                  DateTime.parse(value['timestamp']),
                  dipatch_id,
                  DateTime.parse(value['order_timestamp']));
              orders.add(order);
            }
          }
        });
      }

      // print(orders);
    });
    await Future.delayed(Duration(seconds: 1));
    orders.sort(mycomp);
    await Future.delayed(Duration(seconds: 1));
    return true;
  }

  // );
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    // animationController.dispose() instead of your controller.dispose
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getdetail(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (orders.length != 0) {
              return Scaffold(
                appBar: AppBar(
                  title: Center(
                    child: "Details".text.make(),
                  ),
                  toolbarHeight: 90,
                  backgroundColor: rang.always,
                ),
                body: Container(
                  child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (BuildContext context, int index) {
                      Orderfordispatch order = orders[index];

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
                                // 'Order ID: ${order.orderId}'
                                //     .text
                                //     .bold
                                //     .red600
                                //     .make(),
                                // 4.heightBox,
                                'Dispatch ID: ${order.dispatch_id}'
                                    .text
                                    .bold
                                    .red600
                                    .make(),
                                Text(
                                  'Dispatched Time: ${formatTimestamp(order.timestamp)}',
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                                4.heightBox,
                                Text(
                                  'Ordered Time: ${formatTimestamp(order.order_timestamp)}',
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text('Items:'),
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: order.items
                                //       .map((item) =>
                                //           Text('- ${item.name}: ${item.dispatchedquantity}'))
                                //       .toList(),
                                // ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: FittedBox(
                                      child: DataTable(
                                        dataRowHeight: 70,
                                        columns: [
                                          DataColumn(label: Text('Item Name')),
                                          DataColumn(label: Text('Dispatched')),
                                          DataColumn(label: Text('Ordered')),
                                          DataColumn(label: Text('Remaining')),
                                        ],
                                        rows: order.items
                                            .map(
                                              (iteme) => DataRow(
                                                cells: [
                                                  DataCell(
                                                    Text(
                                                      iteme.name,
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                      iteme.dispatchedquantity
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                      iteme.orderedquantity
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                      iteme.remainingquantity
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ), // ),

                                20.heightBox,
                              ],
                            ),
                          ));
                    },
                  ),
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
                      child: Text(
                    "No dispatches in the selected date range",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                ),
              );
            }
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

class Itemfordispatchsummry {
  final String name;
  final String remainingquantity;
  final String dispatchedquantity;
  final String orderedquantity;

  Itemfordispatchsummry(this.name, this.remainingquantity,
      this.dispatchedquantity, this.orderedquantity);
}

class Orderfordispatch {
  final String orderId;
  final List<Itemfordispatchsummry> items;
  final DateTime timestamp;
  final String dispatch_id;
  final DateTime order_timestamp;

  Orderfordispatch(
    this.orderId,
    this.items,
    this.timestamp,
    this.dispatch_id,
    this.order_timestamp,
  );
}
