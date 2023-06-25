import 'package:basic/Uitilities/circularpro.dart';
import 'package:flutter/material.dart';
import 'package:basic/Uitilities/auth.dart';
import 'package:basic/Uitilities/col.dart';
import 'package:basic/Uitilities/router.dart';
import 'package:basic/pages/login.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:basic/Uitilities/router.dart';
import 'package:dio/dio.dart';
import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:input_quantity/input_quantity.dart';

class Invoice_front extends StatefulWidget {
  const Invoice_front({super.key});

  @override
  State<Invoice_front> createState() => _Invoice_frontState();
}

class _Invoice_frontState extends State<Invoice_front> {
//   // Future<Map<String, dynamic>> fetchJsonFromExcel(String excelUrl) async {
//   //   try {
//   //     // Make HTTP request to download the Excel file
//   //     Dio dio = Dio();
//   //     Response response = await dio.get(excelUrl);

//   //     // Parse the CSV content from the response
//   //     List<List<dynamic>> csvData = CsvToListConverter().convert(response.data);
//   //     // print(csvData);
//   //     // Convert CSV data to JSON
//   //     List<Map<String, dynamic>> jsonData = [];
//   //     List<String> headers = csvData[0].map((e) => e.toString()).toList();
//   //     // print(headers);
//   //     for (int i = 1; i < csvData.length; i++) {
//   //       List<dynamic> row = csvData[i];
//   //       Map<String, dynamic> jsonRow = {};
//   //       for (int j = 0; j < headers.length; j++) {
//   //         jsonRow[headers[j]] = row[j].toString();
//   //       }

//   //       print(jsonRow);
//   //       jsonData.add(jsonRow);
//   //     }
//   //     print(jsonData);
//   //     return {'data': jsonData};
//   //   } catch (e) {
//   //     print('Error fetching JSON from Excel: $e');
//   //     return {'error': 'Failed to fetch JSON from Excel'};
//   //   }
//   // }
//  List<String> fruits = ['Apple', 'Banana', 'Orange'];
//   List<String> colors = ['Red', 'Yellow', 'Orange'];
//   late String selectedFruit;
//   late String selectedColor;

  String selected_customer = 'Select Customer';

  String selected_item = 'Select Item';

  // List of items in our dropdown menu
  var customer = [
    'Select Customer',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  var products = [
    'Select Item',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  List<Item> item = [
    Item('-', 0),
  ];

  int quatity_count = 0;
  bool isremoved = false;

  late DatabaseReference _orderRef;

  @override
  void initState() {
    super.initState();

    _orderRef = FirebaseDatabase.instance.ref().child('orders');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: "invoimanager".text.make(),
        ),
        toolbarHeight: 90,
        backgroundColor: rang.always,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 300,
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
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: DropdownButton(
                          // Initial Value
                          value: selected_customer,

                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),
                          hint: "Select customer                          "
                              .text
                              .black
                              .make(),
                          // Array list of items
                          items: customer.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              selected_customer = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 300,
                height: 250,
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
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Container(
                    child: Column(
                      children: [
                        DropdownButton(
                          // Initial Value
                          value: selected_item,

                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),
                          hint: "Select customer                          "
                              .text
                              .black
                              .make(),
                          // Array list of items
                          items: products.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              selected_item = newValue!;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Row(
                            children: [
                              "    Quantity :".text.bold.make(),
                              40.widthBox,
                              InputQty(
                                btnColor1: rang
                                    .always, //color of the increase and decrease icon
                                maxVal: double.maxFinite, //max val to go
                                minVal: 1,
                                initVal: 1, //min starting val
                                onQtyChanged: (val) {
                                  //on value changed we may set the value
                                  //setstate could be called

                                  quatity_count = val as int;
                                },
                              ),
                            ],
                          ),
                        ),
                        20.heightBox,
                        Container(
                          child: InkWell(
                            onTap: () {
                              //this process returns the future so withput the use of await keywoed it will return the instance of future
                              setState(() {
                                item.add(Item(selected_item, quatity_count));
                                if (item.length > 1 && isremoved == false) {
                                  item.removeAt(0);
                                  isremoved = true;
                                }
                              });
                            },
                            child: Ink(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: rang.always,
                                  gradient: LinearGradient(colors: [
                                    Color.fromRGBO(143, 148, 251, 1),
                                    Color.fromRGBO(143, 148, 251, 6),
                                  ])),
                              child: Center(
                                child: Text("Add",
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              50.heightBox,
              Container(
                width: 300,
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
                  columns: [
                    DataColumn(label: Text('Item Name')),
                    DataColumn(label: Text('Quantity')),
                  ],
                  rows: item
                      .map(
                        (iteme) => DataRow(
                          cells: [
                            DataCell(Text(iteme.name)),
                            DataCell(Text(iteme.quantity.toString())),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
              50.heightBox,
              InkWell(
                onTap: () {
                  //this process returns the future so withput the use of await keywoed it will return the instance of future

                  List<Map<String, dynamic>> orderItems = [];
                  for (var iteme in item) {
                    orderItems.add({
                      'name': iteme.name,
                      'quantity': iteme.quantity,
                    });
                  }

                    _orderRef.child(selected_customer).push().set({
                      'items': orderItems,
                      'timestamp': DateTime.now().toString(),
                    });
                  
                  Navigator.pushNamed(context, router.successordrer);
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
              50.heightBox,
            ],
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
}

class Item {
  final String name;
  int quantity;

  Item(this.name, this.quantity);
}
