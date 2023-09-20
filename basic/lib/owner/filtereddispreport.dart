// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:basic/Uitilities/col.dart';
import 'package:basic/Uitilities/csvfiledownlaod.dart';
import 'package:basic/Uitilities/nointernet.dart';
import 'package:basic/owner/ownerfront.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:excel/excel.dart' show Excel;
import 'package:path_provider/path_provider.dart';

class filteredispres extends StatefulWidget {
  List<Orderfordispatch> orders = [];
  String selected_customer;
  DateTimeRange dateTimeRange;
  filteredispres({
    Key? key,
    required this.orders,
    required this.selected_customer,
    required this.dateTimeRange,
  }) : super(key: key);

  @override
  State<filteredispres> createState() => _filteredispresState();
}

class _filteredispresState extends State<filteredispres> {
  List<Orderfordispatch> filterdorders = [];
  List<Orderfordispatch> orders = [];
  String selected_customer = "All";
  late DateTimeRange dateTimeRange;
  ScrollController _scrollController = ScrollController();

  int _currentItemCount = 5;

  Future<bool> cal() async {
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

  Future<void> exportToCsv(List<List<dynamic>> rows) async {
    try {
      rows.add(["Dispatch report", " ${formatTimestamp(DateTime.now())}"]);
      rows.add([" ", " "]);
      rows.add([" ", " "]);
      for (int i = 0; i < filterdorders.length; i++) {
        Orderfordispatch temp = filterdorders[i];
      
        rows.add(["Customer:", temp.orderId]);
        rows.add(["Dispatch ID:", temp.dispatch_id]);
        rows.add(["Dispatch Time:", formatTimestamp(temp.timestamp)]);
        rows.add(["Ordered Time:", formatTimestamp(temp.order_timestamp)]);
        rows.add(["Items:", ""]);

        rows.add(["S.No.", "Item Name", "Dispatched", "Ordered", "Remaining"]);

        List<Itemfordispatchsummry> items = temp.items;

        for (int j = 0; j < items.length; j++) {
          rows.add([
            j + 1,
            items[j].name,
            items[j].dispatchedquantity,
            items[j].orderedquantity,
            items[j].remainingquantity
          ]);
        }
        rows.add([" ", " "]);
        rows.add([" ", " "]);
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

      final String excelPath = '$dir/dispatchreport{$timestamp}.xlsx';
      var excelFile = File(excelPath);
      print(excelPath);
      await excelFile.writeAsBytes(excel.encode() as List<int>);

      await OpenFile.open(excelPath);
    } catch (e) {
      print(e);
    }
  }

  int mycomp(Orderfordispatch d1, Orderfordispatch d2) {
    if (d1.timestamp.isBefore(d2.timestamp)) {
      return 1;
    }

    return -1;
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
List<List<dynamic>> data = [
    // Add more rows as needed
  ];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var heigh = size.height;
    var widt = size.width;
    return FutureBuilder(
        future: cal(),
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
                  child: Column(children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _currentItemCount <= filterdorders.length
                            ? _currentItemCount
                            : filterdorders.length,
                        itemBuilder: (BuildContext context, int index) {
                          Orderfordispatch order = filterdorders[index];

                          return Container(
                              padding: EdgeInsets.all(15),
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color.fromRGBO(143, 148, 251, 1),
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
                                                          iteme.orderedquantity
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
