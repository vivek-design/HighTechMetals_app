import 'package:basic/DeliveryManagr/Confirmdispatch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:velocity_x/velocity_x.dart';

import '../Uitilities/col.dart';
import '../Uitilities/circularpro.dart';
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
                          Text('Timestamp: ${order.timestamp.toString()}'),
                          SizedBox(height: 4),
                          Text('Items:'),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: order.items
                                .map(
                                  (item) => Text(
                                    '- ${item.name}:    ${item.quantity}',
                                  ),
                                )
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
                            offset: Offset(0, 10),
                          )
                        ],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
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
                                "- ${temp.name}: ".text.make(),
                                " Ordered quantity= ${temp.quantity}".text.make(),
                                10.heightBox,
                                // Slider(
                                //   activeColor: rang.always,
                                //   inactiveColor: rang.always,
                                //   value: slider_values[index],
                                //   min: 0,
                                //   max: temp.quantity.toDouble(),
                                //   divisions: temp.quantity,
                                //   label: slider_values[index].round().toString(),
                                //   onChanged: (double value) {
                                //     setState(() {
                                //       slider_values[index] = value;
                                //     });
                                //   },
                                // ),
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
                                    .text
                                    .make(),
                                2.heightBox,
                                "Remaining quantity: ${(temp.quantity - (slider_values[index])>0)?(temp.quantity - (slider_values[index])):0}"
                                    .text
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
}
