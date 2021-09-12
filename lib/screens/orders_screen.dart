import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drwar.dart';

import '../providers/ordars.dart' show Orders;
import '../widgets/order_item.dart' as ord;

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _orderFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _orderFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Your orders"),
        ),
        drawer: AppDrwar(),
        body: FutureBuilder(
          future: _orderFuture,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (dataSnapshot.error != null) {
              return Center(
                child: Text("Something wrong"),
              );
            } else {
              return Consumer<Orders>(
                  builder: (ctx, orderData, child) => ListView.builder(
                        itemBuilder: (ctx, i) {
                          return ord.OrderItem(orderData.orders[i]);
                        },
                        itemCount: orderData.orders.length,
                      ));
            }
          },
        ));
  }
}












// class OrdersScreen extends StatefulWidget {
//   static const routeName = '/orders';

//   @override
//   _OrdersScreenState createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
//   var _isLoading = false;

//   /// const OrdersScreen({ Key? key }) : super(key: key);
//   // @override
//   // void initState() {
//   //   Future.delayed(Duration.zero).then(
//   //     (_) async {
//   //       setState(() {
//   //         _isLoading = true;
//   //       });
//   //       await Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((value) {
//   //         setState(() {
//   //           _isLoading = false;
//   //         });
//   //       });
//   //     },
//   //   );
//   //   super.initState();
//   // }

//   // @override
//   // void initState() {
//   //   _isLoading = true;
//   //   Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((value) {
//   //     setState(() {
//   //       _isLoading = false;
//   //     });
//   //   });
//   //   super.initState();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     // final orderData = Provider.of<Orders>(context);
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Your orders"),
//         ),
//         drawer: AppDrwar(),
//         body: FutureBuilder(
//           future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
//           builder: (ctx, dataSnapshot) {
//             if (dataSnapshot.connectionState == ConnectionState.waiting) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             if (dataSnapshot.error != null) {
//               return Center(
//                 child: Text("Something wrong"),
//               );
//             } else {
//               return Consumer<Orders>(
//                   builder: (ctx, orderData, child) => ListView.builder(
//                         itemBuilder: (ctx, i) {
//                           return ord.OrderItem(orderData.orders[i]);
//                 },
//                         itemCount: orderData.orders.length,
//                       ));
//             }
//           },
//         ));
//   }
// }
