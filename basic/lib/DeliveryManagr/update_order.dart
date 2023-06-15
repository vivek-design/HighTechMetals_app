// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:velocity_x/velocity_x.dart';
import '../Uitilities/col.dart';
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
  double  slider_value = 0;
  @override
  Widget build(BuildContext context) {
    List<Item> ordred_item = widget.order.items;
    List<Order> orders = [widget.order];
    return Scaffold(
      appBar: AppBar(
        title: "Finalize order".text.make(),
        backgroundColor: rang.always,
        toolbarHeight: 100,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (BuildContext context, int index) {
            Order order = orders[index];

            return Container(
              padding: EdgeInsets.all(15),
              child: Column(children: [
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
                            offset: Offset(0, 10))
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      'Order ID: ${order.orderId}'.text.bold.red600.make(),
                      Text('Timestamp: ${order.timestamp.toString()}'),
                      SizedBox(height: 4),
                      Text('Items:'),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: order.items
                            .map((item) =>
                                Text('- ${item.name}: ${item.quantity}'))
                            .toList(),
                      ),
                      20.heightBox,
                    ],
                  ),
                ),
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
                              offset: Offset(0, 10))
                        ]),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: ordred_item.length,
                        itemBuilder: (context, index) {
                          Item temp = ordred_item[index];
                          return Container(
                            child: Column(
                              children: [
                                "- ${temp.name}:   quantity= ${temp.quantity}"
                                    .text
                                    .make(),
                                10.heightBox,
                                Slider(
                                  activeColor: rang.always,
                                  inactiveColor: rang.always,
                                  value: slider_value,
                                  min: 0,
                                  max: temp.quantity.toDouble(),
                                  label: slider_value.toString(),
                                  onChanged: (value) {
                                    setState(() {
                                      //update the value in array at the index
                                      // slider_value=
                                    });
                                    
                                  },
                                ),
                              ],
                            ),
                          );
                        })),
                50.heightBox,
                Ink(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(143, 148, 251, 1),
                        Color.fromRGBO(143, 148, 251, 6),
                      ])),
                  child: Center(
                    child: Text("Dispatch",
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  ),
                ),
              ]),
            );
          },
        ),
      ),
    );
  }
}
