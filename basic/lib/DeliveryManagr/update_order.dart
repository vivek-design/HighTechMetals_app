import 'package:basic/DeliveryManagr/Confirmdispatch.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../Uitilities/col.dart';

import '../Uitilities/nointernet.dart';
import 'delivery_front.dart';

class update_orderdetail extends StatefulWidget {
  final Order order;

  const update_orderdetail({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<update_orderdetail> createState() => _update_orderdetailState();
}

class _update_orderdetailState extends State<update_orderdetail> {
  late List<int> slider_values;
  late List<Item> ordred_item = widget.order.items;
  late List<Order> orders = [widget.order];
  List<TextEditingController> texteditingController = [];
  String selected_item = 'Select item';
  List<String> items = [
    'Select item',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  ScrollController _scrollController = ScrollController();
  @override
  @override
  void initState() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) {
          return No_internet();
        })));
      }
    });
    initializeSliderValues();
    fillist();
    super.initState();
  }

  void fillist() {
    items.clear();
    for (int i = 0; i < ordred_item.length; i++) {
      items.add(ordred_item[i].name);
    }
    setState(() {
      
    });
  }

  void initializeSliderValues() {
    slider_values = List<int>.filled(ordred_item.length, 0);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalize order'),
        backgroundColor: rang.always,
        toolbarHeight: 80,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
           controller: _scrollController,
          shrinkWrap: true,
          itemCount: orders.length,
          itemBuilder: (BuildContext context, int index) {
            Order order = orders[index];

            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20)),
                      child: Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty ||
                              textEditingValue.selection.baseOffset == 0) {
                            // Return the full customer list if the field is empty or focused
                            return items;
                          }
                          // Filter the customer list based on the user's input
                          return items.where((String option) {
                            return option
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (String selectedValue) {
                          List<Item> filteredItems = ordred_item
                              .where((item) => item.name
                                  .toLowerCase()
                                  .contains(selectedValue.toLowerCase()))
                              .toList();
                          print(filteredItems[0].name);
                          if (filteredItems.isNotEmpty) {
                            try {
                              int index =
                                  ordred_item.indexOf(filteredItems.first);
                              _scrollController.animateTo(
                                index *
                                    180, 
                                    // Replace itemHeight with actual item height
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );

                              print(index);
                            } catch (e) {
                              print(e);
                            }
                          }

                          setState(() {
                            selected_item = selectedValue;
                          });
                        },
                        fieldViewBuilder: (context, textEditingController,
                            focusNode, onFieldSubmitted) {
                          // You can use the next snip of code if you dont want the initial text to come when you use setState((){});
                          return Container(
                            child: TextFormField(
                              style: TextStyle(fontSize: 12),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: '   Search Item',
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final String option =
                                        options.elementAt(index);

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          onSelected(option);
                                          // isremoved = false;
                                        });
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
                    SizedBox(
                      height: 30,
                    ),
                    // Container(
                    //   padding: EdgeInsets.all(5),
                    //   width: 500,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(10),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Color.fromRGBO(143, 148, 251, 1),
                    //         blurRadius: 20.0,
                    //         offset: Offset(0, 10),
                    //       )
                    //     ],
                    //   ),
                    //   child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         'Order ID: ${order.orderId}'
                    //             .text
                    //             .bold
                    //             .red600
                    //             .make(),
                    //         5.heightBox,
                    //         Text(
                    //           'Timestamp: ${formatTimestamp(order.timestamp)}',
                    //           style: TextStyle(fontSize: 13),
                    //         ),
                    //         SizedBox(height: 4),
                    //         Text('Items:', style: TextStyle(fontSize: 13)),
                    //         FittedBox(
                    //           child: DataTable(
                    //             dataRowHeight: 70,
                    //             columns: [
                    //               DataColumn(label: Text('Item Name')),
                    //               DataColumn(label: Text('Quantity')),
                    //               // DataColumn(label: Text('Remove'))
                    //             ],
                    //             rows: order.items
                    //                 .map(
                    //                   (iteme) => DataRow(
                    //                     cells: [
                    //                       DataCell(Text(iteme.name,
                    //                           style: TextStyle(fontSize: 10))),
                    //                       DataCell(
                    //                           Text(iteme.quantity.toString())),
                    //                     ],
                    //                   ),
                    //                 )
                    //                 .toList(),
                    //           ),
                    //         ),
                    //       ]),
                    // ),
                    50.heightBox,
                    Container(
                      padding: EdgeInsets.all(10),
                      width: 500,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, 1),
                            blurRadius: 20.0,
                            offset: Offset(0, 10),
                          )
                        ],
                      ),
                      child: ListView.separated(
                        controller: _scrollController,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: ordred_item.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(color: Colors.grey, thickness: 3),
                        itemBuilder: (context, index) {
                          Item temp = ordred_item[index];

                          if (index >= texteditingController.length) {
                            texteditingController.add(TextEditingController());
                          }
                          return Container(
                            child: Column(
                              children: [
                                "- ${temp.name}: ".text.size(13).bold.make(),
                                " Ordered quantity= ${temp.quantity}"
                                    .text
                                    .size(13)
                                    .make(),
                                10.heightBox,
                                TextFormField(
                                  controller: texteditingController[index],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      labelText: 'Enter quantity ',
                                      constraints:
                                          BoxConstraints(maxWidth: 100)),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter a value';
                                    }
                                    if (int.tryParse(value) == null) {
                                      return 'Please enter a valid integer';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    // You can perform any additional logic here
                                    setState(() {
                                      slider_values[index] =
                                          int.tryParse(value)!;
                                    });
                                  },
                                ),
                                10.heightBox,
                                "  Dispatching quantity: ${(slider_values[index])}"
                                    .text
                                    .size(13)
                                    .make(),
                                2.heightBox,
                                "Remaining quantity: ${(temp.quantity - (slider_values[index]) > 0) ? (temp.quantity - (slider_values[index])) : 0}"
                                    .text
                                    .size(13)
                                    .make(),
                                20.heightBox,
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    50.heightBox,
                    InkWell(
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Confirm_order_update(
                                    order: order,
                                    slider_values: slider_values))),
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              rang.always,
                              Color.fromRGBO(226, 53, 57, 5),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Dispatch',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
