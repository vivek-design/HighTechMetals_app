// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';
import 'package:basic/Uitilities/auth.dart';
import 'package:basic/Uitilities/col.dart';
import 'package:basic/Uitilities/router.dart';
import 'package:basic/owner/Acceptaccount_perm.dart';
import 'package:basic/owner/filtereddispreport.dart';
import 'package:basic/owner/showpending.dart';
import 'package:connectivity/connectivity.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:excel/excel.dart' show Excel;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velocity_x/velocity_x.dart';

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

  Future<void> exportToCsv(List<List<dynamic>> rows) async {
    try {
      rows.clear();
      rows.add(["Dispatch report", " ${formatTimestamp(DateTime.now())}"]);
      rows.add([" ", " "]);
      rows.add([" ", " "]);
      rows.add([" ", " "]);
      rows.add([
        "S.NO.",
        "Customer",
        "Dispatch ID",
        "Dispatch Time",
        "Ordered Time",
        "Item Name",
        "Dispatched",
        "Ordered",
        "Remaining"
      ]);
      var count = 1;
      for (int i = 0; i < orders.length; i++) {
        Orderfordispatch temp = orders[i];

        var customer = temp.orderId;
        var dispatch_id = temp.dispatch_id;
        var dispatch_time = formatTimestamp(temp.timestamp);
        var ordered_time = formatTimestamp(temp.order_timestamp);

        // rows.add(["Customer:", temp.orderId]);
        // rows.add(["Dispatch ID:", temp.dispatch_id]);
        // rows.add(["Dispatch Time:", formatTimestamp(temp.timestamp)]);
        // rows.add(["Ordered Time:", formatTimestamp(temp.order_timestamp)]);
        // rows.add(["Items:", ""]);

        // rows.add(["S.No.", "Item Name", "Dispatched", "Ordered", "Remaining"]);

        List<Itemfordispatchsummry> items = temp.items;

        for (int j = 0; j < items.length; j++) {
          rows.add([
            count,
            customer,
            dispatch_id,
            dispatch_time,
            ordered_time,
            items[j].name,
            items[j].dispatchedquantity,
            items[j].orderedquantity,
            items[j].remainingquantity
          ]);
          count++;
        }
        // rows.add([" ", " "]);
        // rows.add([" ", " "]);
      }
      // List<List<dynamic>> csvData = List.from(rows);
      // String csv = ListToCsvConverter().convert(csvData);

      final String dir = (await getExternalStorageDirectory())!.path;
      // final String path = '$dir/data2.csv';
      var excel = Excel.createExcel();
      var sheet = excel['Sheet1'];

      // Insert CSV data into Excel
      for (var row in rows) {
        sheet.appendRow(row);
      }

      for (int i = 1; i <= sheet.maxCols; i++) {
        sheet.setColAutoFit(i);
      }

      // File file = File(path);
      // await file.writeAsString(csv);

      // Optionally, you can open the file using a file explorer app
      // on the device:
      // await OpenFile.open(path);

      // Set column width based on the maximum cell value length
      String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());

      final String excelPath = '$dir/dispatchreport{$timestamp}.xlsx';
      var excelFile = File(excelPath);
      print(excelPath);
      await excelFile.writeAsBytes(excel.encode() as List<int>);

      await OpenFile.open(excelPath);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> getCustomer() async {
    _orderRef = FirebaseDatabase.instance
        .ref()
        .child('AppData1nG3AefClW3j4Y5ZqwX76Ba9x2VV5axcOWlRMFflh8Hg');
    await _orderRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? data =
            event.snapshot.value as Map<dynamic, dynamic>?;
        data?.forEach((orderKey, orderData) {
          customerList2.customer.add(orderKey.toString());
        });
      }
    });

    return true;
  }

Future<bool> getData() async {
  _orderRef = FirebaseDatabase.instance.ref().child('Dispatched');

  try {
    DatabaseEvent event = await _orderRef.once(); // Wait for the initial data load
    DataSnapshot snapshot = event.snapshot;
    orders.clear();

    Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;

    if (data != null) {
      for (var entry in data.entries) {
        var orderKey = entry.key;
        var orderData = entry.value;

        if (orderData != null) {
          for (var valueEntry in orderData.entries) {
            var key = valueEntry.key;
            var value = valueEntry.value;

            if (value != null) {
              List<dynamic> itemsData = value['items'] ?? [];
              List<Itemfordispatchsummry> items = [];

              for (var itemData in itemsData) {
                var name = itemData['name']?.toString() ?? '';
                var remainingQuantity = itemData['Remaining quantity']?.toString() ?? '';
                var dispatchedQuantity = itemData['Dispatched_quantity']?.toString() ?? '';
                var orderedQuantity = itemData['Ordered_quantity']?.toString() ?? '';

                var item = Itemfordispatchsummry(name, remainingQuantity, dispatchedQuantity, orderedQuantity);
                items.add(item);
              }

              var dispatch_id = value['dispatch_id']?.toString() ?? '';
              Orderfordispatch order = Orderfordispatch(
                orderKey.toString(),
                items,
                DateTime.parse(value['timestamp'].toString()),
                dispatch_id,
                DateTime.parse(value['order_timestamp'].toString()),
              );
              orders.add(order);
            }
          }
        }
      }
    }

    return true;
  } catch (e) {
    print("Error: $e");
    return false;
  }
}





  //  Future<bool> getData() async {
  //   _orderRef = await FirebaseDatabase.instance.ref().child('Dispatched');
  //   _orderRef.onValue.listen((event) async {
  //     orders.clear();
  //     if (event.snapshot.value != null) {
  //       Map<dynamic, dynamic>? data =
  //           await event.snapshot.value as Map<dynamic, dynamic>?;
            
  //     data?.forEach((orderKey, orderData) async {
  //         // var temp = orderKey;
  //         await orderData.forEach((key, value) async {
  //           List<dynamic> itemsData = value['items'];
  //           List<Itemfordispatchsummry> items = await itemsData
  //               .map((itemData) => Itemfordispatchsummry(
  //                   itemData['name'].toString(),
  //                   itemData['Remaining quantity'].toString(),
  //                   itemData['Dispatched_quantity'].toString(),
  //                   itemData['Ordered_quantity'].toString()))
  //               .toList();

  //           var dispatch_id = value['dipatch_id'];
  //           Orderfordispatch order = await Orderfordispatch(
  //               orderKey,
  //               items,
  //               DateTime.parse(value['timestamp']),
  //               dispatch_id,
  //               DateTime.parse(value['order_timestamp']));
  //           orders.add(order);
  //         });
  //       });
  //     }
  //   });

  //   await Future.delayed(Duration(seconds: 2));

  //   return true;
  // }

  @override
  void initState() {
    getCustomer();
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

  List<List<dynamic>> data = [
    // Add more rows as needed
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            orders.sort(mycomp);
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  exportToCsv(data);
                },
                backgroundColor: rang.always,
                child: Icon(Icons.file_open),
              ),
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
                  child: RefreshIndicator(
                    onRefresh: () {
                      return Future.delayed((Duration(milliseconds: 1)), () {
                        setState(() {});
                      });
                    },
                    child: Column(children: [
                      Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.all(10),
                          height: 50,
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return customedialog2(
                                    orders: orders,
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Apply Filters"),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(Icons.filter_list)
                                  ]),
                            ),
                          )),
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _currentItemCount <= orders.length
                              ? _currentItemCount
                              : orders.length,
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
                                            color: Color.fromRGBO(
                                                143, 148, 251, 1),
                                            blurRadius: 20.0,
                                            offset: Offset(0, 10))
                                      ]),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          'Dispatch Time: ${formatTimestamp(order.timestamp)}'),
                                      4.heightBox,
                                      Text(
                                          'Ordered Time: ${formatTimestamp(order.order_timestamp)}'),
                                      SizedBox(height: 4),
                                      Text('Items:'),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: FittedBox(
                                            child: DataTable(
                                              dataRowHeight: 70,
                                              columns: [
                                                DataColumn(
                                                    label: Text('Item Name')),
                                                DataColumn(
                                                    label: Text('Dispatched')),
                                                DataColumn(
                                                    label: Text('Ordered')),
                                                DataColumn(
                                                    label: Text('Remaining')),
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
                                                            iteme
                                                                .dispatchedquantity
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 10),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Text(
                                                            iteme
                                                                .orderedquantity
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 10),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Text(
                                                            iteme
                                                                .remainingquantity
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
                    ]),
                  )),
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
                        Navigator.pushNamed(
                            context, router.manage_account_owner),
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
                  Icon(Icons.pending_actions),
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
                        MaterialPageRoute(builder: (context) => showpending()),
                        (Route<dynamic> route) => false);
                    setState(() {
                      index = 0;
                    });
                  }

                  if (index == 2) {
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
                  child: Center(
                      child: CircularProgressIndicator(
                    color: rang.always,
                  )),
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
                        Navigator.pushNamed(
                            context, router.manage_account_owner),
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
                  Icon(Icons.pending_actions_rounded),
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
                  }

                  if (index == 2) {
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

            // return Scaffold(
            //   appBar: AppBar(
            //     title: Text('All dispatched Orders'),
            //     backgroundColor: rang.always,
            //   ),
            //   body: Container(
            //     child: Center(
            //       child: Center(
            //         child: Text(
            //           "No dispatches to show",
            //           style: TextStyle(fontWeight: FontWeight.bold),
            //         ),
            //       ),
            //     ),
            //   ),
            //   drawer: Drawer(
            //     width: 200,
            //     child: Container(
            //       child: Column(children: [
            //         SizedBox(
            //           height: 125,
            //           child: Container(
            //             color: rang.always,
            //           ),
            //         ),
            //         ListTile(
            //           leading: Icon(Icons.logout),
            //           title: "Logout".text.make(),
            //           onTap: () => {
            //             Auth().signOut(),
            //             Navigator.of(context).pushNamedAndRemoveUntil(
            //                 router.loginroute, (route) => false),
            //           },
            //         ),
            //         ListTile(
            //           leading: Icon(Icons.account_tree_sharp),
            //           title: "Manage account".text.make(),
            //           onTap: () => {
            //             Navigator.pushNamed(
            //                 context, router.manage_account_owner),
            //           },
            //         )
            //       ]),
            //     ),
            //   ),
            //   bottomNavigationBar: CurvedNavigationBar(
            //     color: rang.always,
            //     backgroundColor: Colors.white,
            //     index: 0,
            //     items: [
            //       Icon(Icons.home),
            //       Icon(Icons.pending_actions),
            //       Icon(Icons.manage_accounts),
            //     ],
            //     onTap: (index) async {
            //       if (index == 0) {
            //         await Future.delayed(const Duration(seconds: 1));
            //         index = 0;
            //         // Navigator.pushNamed(context, router.History);
            //         setState(() {
            //           index = 0;
            //         });
            //       }

            //       if (index == 1) {
            //         await Future.delayed(const Duration(seconds: 1));
            //         // index = 1;
            //         Navigator.of(context).pushAndRemoveUntil(
            //             MaterialPageRoute(builder: (context) => showpending()),
            //             (Route<dynamic> route) => false);
            //         setState(() {
            //           index = 0;
            //         });
            //       }

            //       if (index == 2) {
            //         await Future.delayed(const Duration(seconds: 1));
            //         // index = 1;
            //         Navigator.of(context).pushAndRemoveUntil(
            //             MaterialPageRoute(
            //                 builder: (context) => Accept_account_request()),
            //             (Route<dynamic> route) => false);
            //         setState(() {
            //           index = 0;
            //         });
            //       }
            //     },
            //   ),
            // );
          }
          //   } else {
          //     return Scaffold(
          //       appBar: AppBar(
          //         title: Text('All dispatched Orders'),
          //         backgroundColor: rang.always,
          //       ),
          //       body: Container(
          //         child: Center(
          //           child: Center(
          //               child: CircularProgressIndicator(
          //             color: rang.always,
          //           )),
          //         ),
          //       ),
          //       drawer: Drawer(
          //         width: 200,
          //         child: Container(
          //           child: Column(children: [
          //             SizedBox(
          //               height: 125,
          //               child: Container(
          //                 color: rang.always,
          //               ),
          //             ),
          //             ListTile(
          //               leading: Icon(Icons.logout),
          //               title: "Logout".text.make(),
          //               onTap: () => {
          //                 Auth().signOut(),
          //                 Navigator.of(context).pushNamedAndRemoveUntil(
          //                     router.loginroute, (route) => false),
          //               },
          //             ),
          //             ListTile(
          //               leading: Icon(Icons.account_tree_sharp),
          //               title: "Manage account".text.make(),
          //               onTap: () => {
          //                 Navigator.pushNamed(context, router.manage_account_owner),
          //               },
          //             )
          //           ]),
          //         ),
          //       ),
          //       bottomNavigationBar: CurvedNavigationBar(
          //         color: rang.always,
          //         backgroundColor: Colors.white,
          //         index: 0,
          //         items: [
          //           Icon(Icons.home),
          //           Icon(Icons.pending_actions_rounded),
          //           Icon(Icons.manage_accounts),
          //         ],
          //         onTap: (index) async {
          //           if (index == 0) {
          //             await Future.delayed(const Duration(seconds: 1));
          //             index = 0;
          //             // Navigator.pushNamed(context, router.History);
          //             setState(() {
          //               index = 0;
          //             });

          //             if (index == 1) {
          //               await Future.delayed(const Duration(seconds: 1));
          //               // index = 1;
          //               Navigator.of(context).pushAndRemoveUntil(
          //                   MaterialPageRoute(
          //                       builder: (context) => Accept_account_request()),
          //                   (Route<dynamic> route) => false);
          //               setState(() {
          //                 index = 0;
          //               });
          //             }
          //           }

          //           if (index == 2) {
          //             await Future.delayed(const Duration(seconds: 1));
          //             // index = 1;
          //             Navigator.of(context).pushAndRemoveUntil(
          //                 MaterialPageRoute(
          //                     builder: (context) => Accept_account_request()),
          //                 (Route<dynamic> route) => false);
          //             setState(() {
          //               index = 0;
          //             });
          //           }
          //         },
          //       ),
          //     );

          //   }
          // },
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

class customerList2 {
  static List<String> customer = [
    "All",
  ];

  static DateTimeRange dateTimeRange =
      new DateTimeRange(start: DateTime(2023, 1, 1), end: DateTime.now());
}

class customedialog2 extends StatefulWidget {
  List<Orderfordispatch> orders = [];
  customedialog2({
    Key? key,
    required this.orders,
  }) : super(key: key);

  @override
  State<customedialog2> createState() => _customedialog2State();
}

class _customedialog2State extends State<customedialog2> {
  List<String> customer = customerList2.customer;
  String selected_customer = "All";
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Apply Filters',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.all(10),
              child: Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty ||
                      textEditingValue.selection.baseOffset == 0) {
                    // Return the full customer list if the field is empty or focused
                    return customer;
                  }
                  // Filter the customer list based on the user's input
                  return customer.where((String option) {
                    return option
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selectedValue) {
                  setState(() {
                    selected_customer = selectedValue;

                    // products.add('Select Item');
                  });
                },
                fieldViewBuilder: (context, textEditingController, focusNode,
                    onFieldSubmitted) {
                  // You can use the next snip of code if you dont want the initial text to come when you use setState((){});
                  return Container(
                    child: TextFormField(
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        labelText: 'Select customer',
                        fillColor: rang.always,
                        focusColor: rang.always,
                        suffixIcon: IconButton(
                          padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                          onPressed: textEditingController.clear,
                          icon: Icon(
                            Icons.clear,
                            size: 20,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select customer ';
                        }
                        return null;
                      },

                      controller:
                          textEditingController, //uses fieldViewBuilder TextEditingController
                      focusNode: focusNode,
                    ),
                  );
                },
                // optionsMaxHeight: 400,
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      child: Container(
                        width: 250,
                        height: 500,
                        // color: Colors.cyan,
                        child: ListView.builder(
                          padding: EdgeInsets.all(10.0),
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String option = options.elementAt(index);

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  onSelected(option);
                                });
                              },
                              child: ListTile(
                                title: Text(
                                  option,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 10),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text("From:  "),
                Container(
                    child: Text(
                        "${customerList2.dateTimeRange.start.day}-${customerList2.dateTimeRange.start.month}-${customerList2.dateTimeRange.start.year}")),
                SizedBox(
                  width: 50,
                ),
                Text("TO:  "),
                Container(
                    child: Text(
                        "${customerList2.dateTimeRange.end.day}-${customerList2.dateTimeRange.end.month}-${customerList2.dateTimeRange.end.year}")),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                pickDateRange2();
              },
              child: Container(
                child: Icon(Icons.edit_calendar),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return filteredispres(
                      orders: widget.orders,
                      selected_customer: selected_customer,
                      dateTimeRange: customerList2.dateTimeRange);
                }));
              },
              child: Container(
                height: 50,
                width: 100,
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20),
                    color: rang.always),
                child: Center(
                    child: Text(
                  "Apply",
                  style: TextStyle(color: Colors.white),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future pickDateRange2() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: rang.always, // header background color
                onPrimary: Colors.black, // header text color
                onSurface: Colors.green, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: rang.always, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
        initialDateRange: customerList.dateTimeRange,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));

    if (newDateRange == null) {
      return;
    }

    setState(() {
      customerList2.dateTimeRange = newDateRange;
    });
  }
}
