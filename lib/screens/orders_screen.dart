import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drwar.dart';

import '../providers/ordars.dart' show Orders;
import '../widgets/order_item.dart' as ord;

class OrdersScreen extends StatelessWidget {
  static const routeName='/orders';
  /// const OrdersScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData=Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Your orders"),),
      drawer: AppDrwar(),
      body: ListView.builder(itemBuilder: (ctx,i){
return ord.OrderItem(orderData.orders[i]);
      },itemCount: orderData.orders.length,),
      
    );
  }
}