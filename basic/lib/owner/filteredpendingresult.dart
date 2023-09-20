// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:basic/DeliveryManagr/delivery_front.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';

import 'package:basic/Uitilities/nointernet.dart';

import 'package:connectivity/connectivity.dart';

import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'package:velocity_x/velocity_x.dart';

import 'package:basic/Uitilities/col.dart';

import 'package:flutter/cupertino.dart';

class filteredresult extends StatefulWidget {
  List<Order> orders;
  String selected_customer;
  DateTimeRange dateTimeRange;
  filteredresult({
    Key? key,
    required this.orders,
    required this.selected_customer,
    required this.dateTimeRange,
  }) : super(key: key);

  @override
  State<filteredresult> createState() => _filteredresultState();
}

class _filteredresultState extends State<filteredresult> {
  List<Order> filterdorders = [];
  List<Order> orders = [];
  String selected_customer = "All";
  late DateTimeRange dateTimeRange;

  Future<bool> cal2() async {
    filterdorders.clear();

    for (int i = 0; i < orders.length; i++) {
      DateTime timestamp = orders[i].timestamp;
      if ((orders[i].orderId.toString() == selected_customer.toString() ||
              selected_customer == "All") &&
          timestamp.isAfter(dateTimeRange.start.subtract(Duration(days: 1))) &&
          timestamp.isBefore(dateTimeRange.end.add(Duration(days: 1)))) {
        filterdorders.add(orders[i]);
      }
    }

    setState(() {});
    filterdorders.sort(mycomp);
    await Future.delayed(Duration(seconds: 1));
    return true;
  }

  int mycomp(Order d1, Order d2) {
    if (d1.timestamp.isBefore(d2.timestamp)) {
      return 1;
    }

    return -1;
  }

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

  @override
  void initState() {
    orders = widget.orders;
    selected_customer = widget.selected_customer;
    dateTimeRange = widget.dateTimeRange;

    super.initState();

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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var heigh = size.height;
    var widt = size.width;
    return FutureBuilder(
        future: cal2(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (filterdorders.length != 0) {
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    exportToCsv(data);
                  },
                  backgroundColor: rang.always,
                  child: Icon(Icons.file_open),
                ),
                appBar: AppBar(
                  title: Text('Filter result'),
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
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Filter result'),
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
              );
            }
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('Filtered result'),
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
