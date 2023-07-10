// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:basic/InvoiceManager/invoicemanager.dart';
import 'package:basic/Uitilities/col.dart';
import 'package:basic/Uitilities/router.dart';
import 'package:basic/owner/ownerfront.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:excel/excel.dart';

import 'package:flutter/widgets.dart';

class dataUpdate extends StatefulWidget {
  final List<String> Customer;
  const dataUpdate({
    Key? key,
    required this.Customer,
  }) : super(key: key);

  @override
  State<dataUpdate> createState() => _dataUpdateState();
}

class _dataUpdateState extends State<dataUpdate> {
  String selected_customer = 'Select Customer';
  List<Item> item = [
    Item('-', 0),
  ];

  late List<String> customer = widget.Customer;
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: "Upload order  Data".text.bold.white.make(),
          backgroundColor: rang.always,
        ),
        bottomNavigationBar: CurvedNavigationBar(
          color: rang.always,
          backgroundColor: Colors.white,
          index: 1,
          items: [
            Icon(Icons.home),
            Icon(Icons.data_object_outlined),
          ],
          onTap: (index) async {
            if (index == 0) {
              await Future.delayed(const Duration(seconds: 1));
              index = 0;
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Invoice_front()),
                  (Route<dynamic> route) => false);
              setState(() {});
            }

            if (index == 1) {
              await Future.delayed(const Duration(seconds: 1));
              // index = 1;
              // Navigator.pushNamed(context, router.accept_acc_req);
              setState(() {});
            }
          },
        ),
        body: SingleChildScrollView(
            child: Container(
                width: double.infinity,
                child: Column(children: [
                  20.heightBox,
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(143, 148, 251, 1),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10))
                              ]),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Autocomplete<String>(
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text.isEmpty ||
                                      textEditingValue.selection.baseOffset ==
                                          0) {
                                    // Return the full customer list if the field is empty or focused
                                    return customer;
                                  }
                                  // Filter the customer list based on the user's input
                                  return customer.where((String option) {
                                    return option.toLowerCase().contains(
                                        textEditingValue.text.toLowerCase());
                                  });
                                },
                                onSelected: (String selectedValue) {
                                  setState(() {
                                    selected_customer = selectedValue;
                                  });
                                },
                                fieldViewBuilder: (context,
                                    textEditingController,
                                    focusNode,
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
                                          padding:
                                              EdgeInsets.fromLTRB(0, 12, 0, 0),
                                          onPressed:
                                              textEditingController.clear,
                                          icon: Icon(
                                            Icons.clear,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter customer ';
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
                                optionsViewBuilder:
                                    (context, onSelected, options) {
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
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final String option =
                                                options.elementAt(index);

                                            return GestureDetector(
                                              onTap: () {
                                                onSelected(option);
                                              },
                                              child: ListTile(
                                                title: Text(
                                                  option,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10),
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
                          ),
                        ),
                        25.heightBox,
                        Container(
                          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                          alignment: AlignmentDirectional.topStart,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "Note :".text.bold.make(),
                                "1. Uploded file should be in the appropriate formate ."
                                    .text
                                    .xs
                                    .make(),
                                "2. It is recommended to choose customer first ."
                                    .text
                                    .xs
                                    .make(),
                                "3. Only excel files are allowed ."
                                    .text
                                    .xs
                                    .make(),
                              ]),
                        ),
                        50.heightBox,
                        Container(
                            height: 80,
                            width: 80,
                            child: Center(
                              child: Image.asset(
                                  "assets/images/t_microsoft-excel-new-removebg-preview.png"),
                            )),
                        20.heightBox,
                        InkWell(
                          onTap: () {
                            //this process returns the future so withput the use of await keywoed it will return the instance of future
                            uploadFile();
                          },
                          child: Ink(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(colors: [
                                  Color.fromRGBO(226, 53, 57, 1),
                                  Color.fromRGBO(226, 53, 57, 5),
                                ])),
                            child: Center(
                              child: Text(" Upload ",
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ),
                        50.heightBox,
                        Container(
                          width: double.infinity,
                          // height: 250,
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

                          child: DataTable(
                            dataRowHeight: 70,
                            columns: [
                              DataColumn(label: Text('Item Name')),
                              DataColumn(label: Text('Quantity')),
                              DataColumn(label: Text('Remove'))
                            ],
                            rows: item
                                .map(
                                  (iteme) => DataRow(
                                    cells: [
                                      DataCell(Text(iteme.name,
                                          style: TextStyle(fontSize: 10))),
                                      DataCell(Text(iteme.quantity.toString())),
                                      DataCell(
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            // Add functionality to remove the item
                                            setState(() {
                                              item.remove(
                                                  iteme); // Remove the item from the list
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        40.heightBox,
                        InkWell(
                          onTap: () {
                            //this process returns the future so withput the use of await keywoed it will return the instance of future

                              if (selected_customer != 'Select Customer') {
                            List<Map<String, dynamic>> orderItems = [];
                            for (var iteme in item) {
                              orderItems.add({
                                'name': iteme.name,
                                'quantity': iteme.quantity,
                              });
                            }

                            DatabaseReference _orderRef2 =
                                FirebaseDatabase.instance.ref().child('orders');
                            _orderRef2.child(selected_customer).push().set({
                              'items': orderItems,
                              'timestamp': DateTime.now().toString(),
                            });

                            Navigator.pushNamed(context, router.successordrer);
                          } else {
                            displaytoast(
                                "Please select the customer first ", context);
                          }
                          },
                          child: Ink(
                            height: 50,
                            width: 300,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(colors: [
                                  Color.fromRGBO(226, 53, 57, 1),
                                  Color.fromRGBO(226, 53, 57, 5),
                                ])),
                            child: Center(
                              child: Text(" Order",
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]))));
  }

  void uploadFile() async {
 
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null && result.files.single.path != null) {
      // Read Excel file
      var bytes = await File(result.files.single.path!).readAsBytes();
      var excel = Excel.decodeBytes(bytes);

      // Convert Excel data to JSON
      var table = excel.tables[excel.tables.keys.first];
      var jsonData = <Map<String, dynamic>>[];

      // Get column names from the first row
      var columnNames = <String>[];
      for (var cell in table!.rows[0]) {
        columnNames.add(cell!.value!.toString());
      }
      //   print(columnNames); //[SN, Item No., Item Description]

      // Iterate over rows (starting from index 1)
      item.clear();
      for (var i = 1; i < table.rows.length; i++) {
        var rowData = <String, dynamic>{};
        var row = table.rows[i];
        // print(row);
        // Populate row data using column names
        String item_id = row[1]!.value.toString();
        String desecription = row[2]!.value.toString();
        String quantity = row[3]!.value.toString();
        int inteQuanti = int.parse(quantity);

        Item items = new Item(item_id +" "+ desecription, inteQuanti);
        item.add(items);

        for (var j = 0; j < row.length; j++) {
          rowData[columnNames[j]] = row[j]!.value.toString();
        }

        // jsonData.add(rowData);
      }

      displaytoast("File Uploaded successfully", context);

      if (item.isNotEmpty) {
        setState(() {});
      }
    }
  }

  void placeorder() {
    if (selected_customer != 'Select Customer') {
      List<Map<String, dynamic>> orderItems = [];
      for (var iteme in item) {
        orderItems.add({
          'name': iteme.name,
          'quantity': iteme.quantity,
        });
      }

      DatabaseReference _orderRef2 =
          FirebaseDatabase.instance.ref().child('orders');
      _orderRef2.child(selected_customer).push().set({
        'items': orderItems,
        'timestamp': DateTime.now().toString(),
      });

      Navigator.pushNamed(context, router.successordrer);
    } else {
      displaytoast("Please select the customer first ", context);
    }
  }

  displaytoast(String s, BuildContext context) {
    Fluttertoast.showToast(msg: s);
  }
}

class Item {
  final String name;
  int quantity;

  Item(this.name, this.quantity);
}
