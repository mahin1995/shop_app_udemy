import 'package:flutter/material.dart';
import '../providers/ordars.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatelessWidget {
  /// const OrderItem({ Key? key }) : super(key: key);
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${order.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy on:hh:mm').format(order.dateTime),
            ),
            trailing: IconButton(icon: Icon(Icons.expand_more), onPressed: () {  },)
          )
        ],
      ),
    );
  }
}
