import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/cart.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './screens/products_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.blue,
          accentColor: Colors.orange,
          fontFamily: "Lato",
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName:(ctx)=> ProductDetailScreen()
        },
      ),
    );
  }
}


