import 'package:basic/DeliveryManagr/update_order.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:intl/intl.dart';

import '../Uitilities/nointernet.dart';

class deliv_front extends StatefulWidget {
  const deliv_front({super.key});

  @override
  State<deliv_front> createState() => _deliv_frontState();
}

class _deliv_frontState extends State<deliv_front> {
  late DatabaseReference _orderRef;
  late List<dynamic> helper;
  List<String> helper2 = [""];
  late List<Order> orders = [];
  int mycomp(Order o1, Order o2) {
    if (o1.timestamp.isAfter(o2.timestamp)) {
      return -1;
    }

    return 1;
  }

  Future<bool> cal() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? ema = user?.email;
    DatabaseReference dbref =
        await FirebaseDatabase.instance.ref().child("Delivery_responsibility");
    dbref.onValue.listen((event) async{
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? data =
           await event.snapshot.value as Map<dynamic, dynamic>?;
      data?.forEach((key, value) async{
          if (value["Email"].toString() == ema.toString()) {
            helper = value["Customers"];
            print(ema);

         helper.forEach((element) {
              helper2.add(element.toString().trim());
            });
            print(helper2);
          }
        });
      }
    });
    
    await Future.delayed(Duration(seconds: 1));

    _orderRef = await FirebaseDatabase.instance.ref().child('orders');
    _orderRef.onValue.listen((event) {
      orders.clear();
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? data =
           event.snapshot.value as Map<dynamic, dynamic>?;
        data?.forEach((orderKey, orderData) async {
         await orderData.forEach((key, value)async {
            print(orderKey);
            // print(helper);
            print(helper2.contains(orderKey.toString().trim()));
            if (helper2.contains(orderKey.toString().trim())) {
              List<dynamic> itemsData = value['items'];
              List<Item> items = itemsData
                  .map((itemData) =>
                      Item(itemData['name'], itemData['quantity']))
                  .toList();
              Order order = Order(
                  orderKey, items, DateTime.parse(value['timestamp']), "gjhgh");
              orders.add(order);
            }
          });
        });
      }

      orders.sort(mycomp);
    });
    await Future.delayed(Duration(seconds: 1));
    return true;
  }

  @override
  void initState() {
    super.initState();

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
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: cal(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (orders.length != 0) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Order List'),
                  backgroundColor: rang.always,
                ),
                body: RefreshIndicator(
                  onRefresh: () {
                  return Future.delayed(
                    (Duration(milliseconds: 1)),(){
                             setState(() {});
                    }
                  );
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: orders.length,
                    itemBuilder: (BuildContext context, int index) {
                      Order order = orders[index];
                
                      return Container(
                          padding: EdgeInsets.all(15),
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
                                'Order ID: ${order.orderId}'
                                    .text
                                    .bold
                                    .red600
                                    .make(),
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
                                                  style:
                                                      TextStyle(fontSize: 10))),
                                              DataCell(Text(
                                                  iteme.quantity.toString())),
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                                20.heightBox,
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  update_orderdetail(
                                                      order: order)));
                                    },
                                    child: "Dispatch".text.make(),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll(rang.always),
                                    )),
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
                  title: Text('Order List'),
                  backgroundColor: rang.always,
                ),
                body: 
                RefreshIndicator(
                  onRefresh: () {
                  return Future.delayed(
                    (Duration(milliseconds: 1)),(){
                             setState(() {});
                    }
                  );
                  },
                  child:
                Container(
                  child: Center(
                    child: Center(
                      child: Text(
                        "No orders to dispatch",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
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
            }
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('Order List'),
                backgroundColor: rang.always,
              ),
              body: RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(
                    (Duration(milliseconds: 1)),(){
                             setState(() {});
                    }
                  );
                
                },
                child: Container(
                  child: Center(child: CircularProgressIndicator()),
                ),
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
