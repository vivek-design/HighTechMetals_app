// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:basic/Uitilities/auth.dart';
import 'package:basic/Uitilities/col.dart';
import 'package:basic/Uitilities/router.dart';
import 'package:basic/Uitilities/router.dart';
import 'package:basic/owner/Acceptaccount_perm.dart';
import 'package:basic/pages/login.dart';
import 'package:connectivity/connectivity.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../DeliveryManagr/delivery_front.dart';
import '../Uitilities/nointernet.dart';

class Owner_front extends StatefulWidget {
  const Owner_front({super.key});

  @override
  State<Owner_front> createState() => _Owner_frontState();
}

class _Owner_frontState extends State<Owner_front> {
  late DatabaseReference _orderRef;

  List<Orderfordispatch> orders = [];

  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _currentItemCount = 5;

  int mycomp(Orderfordispatch p1, Orderfordispatch p2) {
    if (p1.timestamp.isBefore(p2.timestamp)) {
      return 1;
    }

    return -1;
  }

  Future<bool> getData() async {
    _orderRef = await FirebaseDatabase.instance.ref().child('Dispatched');
    _orderRef.onValue.listen((event) async {
      orders.clear();
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? data =
            await event.snapshot.value as Map<dynamic, dynamic>?;
        data?.forEach((orderKey, orderData) async {
          await orderData.forEach((key, value) async {
            List<dynamic> itemsData = value['items'];
            List<Itemfordispatchsummry> items = await itemsData
                .map((itemData) => Itemfordispatchsummry(
                    itemData['name'].toString(),
                    itemData['Remaining quantity'].toString(),
                    itemData['Dispatched_quantity'].toString(),
                    itemData['Ordered_quantity'].toString()))
                .toList();

            var dispatch_id = value['dipatch_id'];
            Orderfordispatch order = await Orderfordispatch(orderKey, items,
                DateTime.parse(value['timestamp']), dispatch_id,value['order_timestamp']);
            orders.add(order);
          });
        });
      }
    });

    await Future.delayed(Duration(seconds: 1));

    orders.sort(mycomp);
    await Future.delayed(Duration(seconds: 2));
    return true;
  }

  @override
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Container(
                  child: Row(
                children: [
                  Text('All dispatched Orders'),
                ],
              )),
              backgroundColor: rang.always,
              actions: [],
            ),
            body: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (!_isLoading &&
                    scrollNotification.metrics.pixels ==
                        scrollNotification.metrics.maxScrollExtent &&
                    orders.length > _currentItemCount) {
                  // Reached the end of the list, trigger loading more data
                  // print(scrollNotification.metrics.pixels);
                  _loadMoreData();
                }
                return true;
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _currentItemCount,
                //  orders.length,
                // itemCount: orders.length,
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
                            'Order ID: ${order.orderId}'
                                .text
                                .bold
                                .red600
                                .make(),
                            4.heightBox,
                            'Dispatch ID: ${order.dispatch_id}'
                                .text
                                .bold
                                .red600
                                .make(),
                            Text(
                                'Timestamp: ${formatTimestamp(order.timestamp)}'),
                                4.heightBox,
                                 Text(
                                'Timestamp: ${formatTimestamp(order.order_timestamp)}'),
                            SizedBox(height: 4),
                            Text('Items:'),
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
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  iteme.dispatchedquantity
                                                      .toString(),
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  iteme.orderedquantity
                                                      .toString(),
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  iteme.remainingquantity
                                                      .toString(),
                                                  style:
                                                      TextStyle(fontSize: 10),
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
                  ),
                  ListTile(
                    leading: Icon(Icons.account_tree_sharp),
                    title: "Manage account".text.make(),
                    onTap: () => {
                      Navigator.pushNamed(context, router.manage_account_owner),
                    },
                  )
                ]),
              ),
            ),
            bottomNavigationBar: CurvedNavigationBar(
              color: rang.always,
              backgroundColor: Colors.white,
              index: 0,
              items: [
                Icon(Icons.home),
                Icon(Icons.manage_accounts),
              ],
              onTap: (index) async {
                if (index == 0) {
                  await Future.delayed(const Duration(seconds: 1));
                  index = 0;
                  // Navigator.pushNamed(context, router.History);
                  setState(() {
                    index = 0;
                  });
                }

                if (index == 1) {
                  await Future.delayed(const Duration(seconds: 1));
                  // index = 1;
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => Accept_account_request()),
                      (Route<dynamic> route) => false);
                  setState(() {
                    index = 0;
                  });
                }
              },
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('All dispatched Orders'),
              backgroundColor: rang.always,
            ),
            body: Container(
              child: Center(
                child: CircularProgressIndicator(
                  color: rang.always,
                ),
              ),
            ),
          );
        }
      },
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

  void _loadMoreData() {
    // Simulate loading more data by fetching it from an API or other source
    // Add your logic here to fetch the next batch of data

    // After loading the new data, update the itemCount and set isLoading to false
    setState(() {
      if (_currentItemCount + 5 >= orders.length) {
        // Reached the end of the list
        _currentItemCount = orders.length;
      } else {
        // Increase the number of items to load
        _currentItemCount += 5;
      }
      _isLoading = false;

      // Sort the orders list
      // orders.sort(mycomp);
    });
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
