import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';


import 'package:basic/Uitilities/auth.dart';
import 'package:basic/Uitilities/col.dart';
import 'package:basic/Uitilities/router.dart';

import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/cupertino.dart';

import 'package:velocity_x/velocity_x.dart';

import 'package:intl/intl.dart';

import '../Uitilities/nointernet.dart';

class Previoushistory extends StatefulWidget {
  const Previoushistory({super.key});

  @override
  State<Previoushistory> createState() => _PrevioushistoryState();
}

class _PrevioushistoryState extends State<Previoushistory> {
 late DatabaseReference _orderRef;
  List<Order> orders = [];
  int mycomp(Order o1, Order o2) {
    if (o1.timestamp.isAfter(o2.timestamp)) {
      return -1;
    }

    return 1;
  }

  @override
  void initState() {

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
    _orderRef = FirebaseDatabase.instance.ref().child('orders');
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
            Order order = Order(
                orderKey, items, DateTime.parse(value['timestamp']), "gjhgh");
            orders.add(order);
          });
        });
      }

      orders.sort(mycomp);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order List'),
        backgroundColor:Color.fromARGB(255, 142, 10, 10),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: orders.length,
        itemBuilder: (BuildContext context, int index) {
          Order order = orders[index];

          return Container(
              padding: EdgeInsets.all(15),
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.all(10),
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
                    5.heightBox,
                    Text(
                      'Timestamp: ${formatTimestamp(order.timestamp)}',
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(height: 4),
                    Text('Items:', style: TextStyle(fontSize: 13)),
                    FittedBox(
                   

                      child: DataTable(
                        dataRowHeight: 70,
                        columns: [
                          DataColumn(label: Text('Item Name')),
                          DataColumn(label: Text('Quantity')),
                        
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

class Order {
  final String orderId;
  final List<Item> items;
  final DateTime timestamp;
  final String dispatch_id;
  Order(this.orderId, this.items, this.timestamp, this.dispatch_id);
}

class Item {
  final String name;
  final int quantity;

  Item(this.name, this.quantity);

  toInt() {}
}
