// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:basic/Uitilities/col.dart';
import 'package:basic/owner/ownerfront.dart';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class csvfiledownload extends StatefulWidget {
  List<Orderfordispatch> orders;
  csvfiledownload({
    Key? key,
    required this.orders,
  }) : super(key: key);

  @override
  State<csvfiledownload> createState() => _csvfiledownloadState();
}

Future<void> exportToCsv(List<List<dynamic>> rows) async {
  try {
    List<List<dynamic>> csvData = List.from(rows);
    String csv = ListToCsvConverter().convert(csvData);

    final String dir = (await getExternalStorageDirectory())!.path;
    final String path = '$dir/data2.csv';

    File file = File(path);
    await file.writeAsString(csv);

    // Optionally, you can open the file using a file explorer app
    // on the device:
    await OpenFile.open(path);
  } catch (e) {
    print(e);
  }
}

class _csvfiledownloadState extends State<csvfiledownload> {
  Future<void> exportToCsv(List<List<dynamic>> rows) async {
    try {
      List<Orderfordispatch> order = widget.orders;

      for (int i = 0; i < order.length; i++) {
        Orderfordispatch temp = order[i];

        rows.add(["Customer:", temp.orderId]);
        rows.add(["Dispatch ID:", temp.dispatch_id]);
        rows.add(["Dispatch Time:", formatTimestamp(temp.timestamp)]);
        rows.add(["Ordered Time:", formatTimestamp(temp.order_timestamp)]);
        rows.add(["Items:", ""]);

        rows.add(["Item Name", "Dispatched", "Ordered", "Remaining"]);

        List<Itemfordispatchsummry> items = temp.items;

        for (int j = 0; j < items.length; j++) {
          rows.add([
            items[j].name,
            items[j].dispatchedquantity,
            items[j].orderedquantity,
            items[j].remainingquantity
          ]);
        }
        rows.add([" ", " "]);
        rows.add([" ", " "]);
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

      final String excelPath = '$dir/data2.xlsx';
      var excelFile = File(excelPath);
      print(excelPath);
      await excelFile.writeAsBytes(excel.encode() as List<int>);

      await OpenFile.open(excelPath);
    } catch (e) {
      print(e);
    }
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

  List<List<dynamic>> data = [
    // Add more rows as needed
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var heigh = size.height;
    var widt = size.width;
    return FutureBuilder(
        future: exportToCsv(data),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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
        });
  }
}
