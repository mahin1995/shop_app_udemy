import 'package:flutter/material.dart';
import '../screens/user_product_screen.dart';
import '../screens/orders_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class AppDrwar extends StatelessWidget {
  const AppDrwar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text(""),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Orders"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.edit),
            title: Text("User Product"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.logout),
            title: Text("LOGOUT"),
            onTap: () {
              Navigator.of(context).pop();//because drware is open
              Provider.of<Auth>(context).logout();
            },
          ),
        ],
      ),
    );
  }
}
