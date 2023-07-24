import 'package:basic/DeliveryManagr/Confirmdispatch.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../Uitilities/col.dart';
import '../Uitilities/circularpro.dart';
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

  @override
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
    initializeSliderValues();
    super.initState();
  }

  void initializeSliderValues() {
    slider_values = List<int>.filled(ordred_item.length, 0);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalize order'),
        backgroundColor: rang.always,
        toolbarHeight: 100,
      ),
      body:Container(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
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
                      padding: EdgeInsets.all(5),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        'Order ID: ${order.orderId}'.text.bold.red600.make(),
                    5.heightBox,
                    Text('Timestamp: ${formatTimestamp(order.timestamp)}',style: TextStyle(fontSize: 13),),
                    SizedBox(height: 4),
                    Text('Items:',style: TextStyle(fontSize: 13)),
                          FittedBox(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      // children: order.items
                      //     .map((item) =>
                      //         Text('- ${item.name}: \n Quantity: ${item.quantity} \n              '),)
                      //     .toList(),
                   
                   child:   DataTable(
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
                                        style: TextStyle(fontSize: 10))),
                                    DataCell(Text(iteme.quantity.toString())),
                                   
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                    ),
                  ]),),
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
                                " Ordered quantity= ${temp.quantity}".text.size(13).make(),
                                10.heightBox,
                               
                                TextFormField(
                                  controller: texteditingController[index],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      labelText: 'Enter quantity ',
                                      constraints: BoxConstraints(maxWidth: 100)),
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
                                      slider_values[index] = int.tryParse(value)! ;
                                    });
                                  },
                                ),
                                10.heightBox,
                                "  Dispatching quantity: ${(slider_values[index])}"
                                    .text.size(13)
                                    .make(),
                                2.heightBox,
                                "Remaining quantity: ${(temp.quantity - (slider_values[index])>0)?(temp.quantity - (slider_values[index])):0}"
                                    .text.size(13)
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
                                    order: order, slider_values: slider_values))),
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(226, 53, 57, 1),
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
