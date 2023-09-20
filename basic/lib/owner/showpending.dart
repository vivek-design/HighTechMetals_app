// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:basic/DeliveryManagr/delivery_front.dart';
import 'package:basic/Uitilities/auth.dart';
import 'package:basic/Uitilities/col.dart';
import 'package:basic/Uitilities/nointernet.dart';
import 'package:basic/Uitilities/router.dart';
import 'package:basic/owner/Acceptaccount_perm.dart';
import 'package:basic/owner/filteredpendingresult.dart';
import 'package:basic/owner/ownerfront.dart';
import 'package:connectivity/connectivity.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:excel/excel.dart' show Excel;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:velocity_x/velocity_x.dart';

class showpending extends StatefulWidget {
  const showpending({super.key});

  @override
  State<showpending> createState() => _showpendingState();
}

class _showpendingState extends State<showpending> {
  @override
  late DatabaseReference _orderRef;
  late List<dynamic> helper;
  List<String> helper2 = [""];
  late List<Order> orders = [];
  late List<Order> filterdorders = [];
  int mycomp(Order o1, Order o2) {
    if (o1.timestamp.isAfter(o2.timestamp)) {
      return -1;
    }

    return 1;
  }

  String namecustomer = 'All';

  List<List<dynamic>> data = [
    // Add more rows as needed
  ];

  Future<void> exportToCsv(List<List<dynamic>> rows) async {
    try {
      rows.clear();
      rows.add(
          ["Pending dispatch report", " ${formatTimestamp(DateTime.now())}"]);
      rows.add([" ", " "]);
      rows.add([" ", " "]);
      rows.add(["S.NO.", "Customer", "Ordered Time", "Item", "Quantity"]);
      var count = 1;
      for (int i = 0; i < filterdorders.length; i++) {
        Order temp = filterdorders[i];
        var customer = temp.orderId;
        var ordered_time = formatTimestamp(temp.timestamp);

        // rows.add(["Customer:", temp.orderId]);

        // rows.add(["Ordered Time:", formatTimestamp(temp.timestamp)]);
        // rows.add(["Items:", ""]);

        // rows.add(["S.No.", "Item Name", "Quantity"]);

        List<Item> items = temp.items;

        for (int j = 0; j < items.length; j++) {
          rows.add([
            count,
            customer,
            ordered_time,
            items[j].name,
            items[j].quantity,
          ]);
          count++;
        }
        // rows.add([" ", " "]);
        // rows.add([" ", " "]);
      }

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

      String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());

      final String excelPath = '$dir/pendingorderreport{$timestamp}.xlsx';
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
          // print(orderKey);
          customerList.customer.add(orderKey.toString());
        });
      }
      // print(mp);
    });

    await Future.delayed(Duration(seconds: 2));

    return true;
  }

  Future<bool> cal() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? ema = user?.email;

    await Future.delayed(Duration(seconds: 1));

    _orderRef = await FirebaseDatabase.instance.ref().child('orders');
    _orderRef.onValue.listen((event) {
      orders.clear();
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? data =
            event.snapshot.value as Map<dynamic, dynamic>?;
        data?.forEach((orderKey, orderData) async {
          await orderData.forEach((key, value) async {
            // if (helper2.contains(orderKey.toString().trim())) {
            List<dynamic> itemsData = value['items'];
            List<Item> items = itemsData
                .map((itemData) => Item(itemData['name'], itemData['quantity']))
                .toList();

            Order order = Order(
                orderKey, items, DateTime.parse(value['timestamp']), "gjhgh");
            orders.add(order);
          }
              // }
              );
        });
      }

      orders.sort(mycomp);
      filterdorders = orders;
    });
    await Future.delayed(Duration(seconds: 1));
    return true;
  }

  @override
  void initState() {
    super.initState();
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
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var heigh = size.height;
    var widt = size.width;
    return FutureBuilder(
        future: cal(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (orders.length != 0) {
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    exportToCsv(data);
                  },
                  backgroundColor: rang.always,
                  child: Icon(Icons.file_open),
                ),
                appBar: AppBar(
                  title: Text('Pending Dispatch Orders'),
                  backgroundColor: rang.always,
                ),
                body: RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed((Duration(seconds: 1)), () {
                      setState(() {});
                    });
                  },
                  child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.all(10),
                            height: 50,
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialog(orders: orders);
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
                            shrinkWrap: true,
                            itemCount: filterdorders.length,
                            itemBuilder: (BuildContext context, int index) {
                              Order order = filterdorders[index];

                              return Container(
                                  padding: EdgeInsets.all(15),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
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
                                        5.heightBox,
                                        Text(
                                          'Ordered Time: ${formatTimestamp(order.timestamp)}',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        SizedBox(height: 4),
                                        Text('Items:',
                                            style: TextStyle(fontSize: 13)),
                                        FittedBox(
                                          child: DataTable(
                                            dataRowHeight: 70,
                                            columns: [
                                              DataColumn(
                                                  label: Text('Item Name')),
                                              DataColumn(
                                                  label: Text('Quantity')),
                                              // DataColumn(label: Text('Remove'))
                                            ],
                                            rows: order.items
                                                .map(
                                                  (iteme) => DataRow(
                                                    cells: [
                                                      DataCell(Text(iteme.name,
                                                          style: TextStyle(
                                                              fontSize: 10))),
                                                      DataCell(Text(iteme
                                                          .quantity
                                                          .toString())),
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
                        ),
                      ]),
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
                  index: 1,
                  items: [
                    Icon(Icons.home),
                    Icon(Icons.pending_actions),
                    Icon(Icons.manage_accounts),
                  ],
                  onTap: (index) async {
                    if (index == 0) {
                      await Future.delayed(const Duration(seconds: 1));
                      index = 0;
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => Owner_front()),
                          (Route<dynamic> route) => false);
                      setState(() {
                        index = 0;
                      });
                    }

                    if (index == 1) {
                      await Future.delayed(const Duration(seconds: 1));
                      // index = 1;
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => showpending()),
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
                  title: Text('Pending Dispatch Orders'),
                  backgroundColor: rang.always,
                ),
                body: RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(Duration(seconds: 1), () {
                      setState(() {});
                    });
                  },
                  child: SingleChildScrollView(
                    child: Container(
                      height: heigh,
                      width: widt,
                      child: Center(
                        child: Text(
                          "Nothing to show",
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
                bottomNavigationBar: CurvedNavigationBar(
                  color: rang.always,
                  backgroundColor: Colors.white,
                  index: 1,
                  items: [
                    Icon(Icons.home),
                    Icon(Icons.pending_actions),
                    Icon(Icons.manage_accounts),
                  ],
                  onTap: (index) async {
                    if (index == 0) {
                      await Future.delayed(const Duration(seconds: 1));
                      index = 0;
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => Owner_front()),
                          (Route<dynamic> route) => false);
                      setState(() {
                        index = 0;
                      });
                    }

                    if (index == 1) {
                      await Future.delayed(const Duration(seconds: 1));
                      // index = 1;
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => showpending()),
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
            }
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('Pending Dispatch Orders'),
                backgroundColor: rang.always,
              ),
              body: RefreshIndicator(
                onRefresh: () {
                  return Future.delayed((Duration(milliseconds: 1)), () {
                    setState(() {});
                  });
                },
                child: Container(
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
                index: 1,
                items: [
                  Icon(Icons.home),
                  Icon(Icons.pending_actions),
                  Icon(Icons.manage_accounts),
                ],
                onTap: (index) async {
                  if (index == 0) {
                    await Future.delayed(const Duration(seconds: 1));
                    index = 0;
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Owner_front()),
                        (Route<dynamic> route) => false);
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

class CustomDialog extends StatefulWidget {
  final List<Order> orders;

  CustomDialog({
    Key? key,
    required this.orders,
  }) : super(key: key);

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  List<String> customer = customerList.customer;

  String selected_customer = "All";
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();

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
                        "${customerList.dateTimeRange.start.day}-${customerList.dateTimeRange.start.month}-${customerList.dateTimeRange.start.year}")),
                SizedBox(
                  width: 50,
                ),
                Text("TO:  "),
                Container(
                    child: Text(
                        "${customerList.dateTimeRange.end.day}-${customerList.dateTimeRange.end.month}-${customerList.dateTimeRange.end.year}")),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                pickDateRange();
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
                  return filteredresult(
                      orders: widget.orders,
                      selected_customer: selected_customer,
                      dateTimeRange: customerList.dateTimeRange);
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

  Future pickDateRange() async {
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
      customerList.dateTimeRange = newDateRange;
    });
  }
}

class customerList {
  static List<String> customer = [
    "All",
  ];

  static DateTimeRange dateTimeRange =
      new DateTimeRange(start: DateTime(2023, 1, 1), end: DateTime.now());
}
