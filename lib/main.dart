import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/splash_screen.dart';
import './providers/auth.dart';
import './providers/ordars.dart';
import './screens/cart_screen.dart';
import './providers/cart.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './screens/products_overview_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './helpers/custom_route.dart';

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
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
              create: (ctx) => Orders(null, null, []),
              update: (ctx, auth, priveousOrder) => Orders(
                  auth.token,
                  auth.userId,
                  priveousOrder == null ? [] : priveousOrder.orders)),
          ChangeNotifierProxyProvider<Auth, Products>(
            // create: (ctx) => Products(),
            // update: (ctx, auth, priveousProduct) => priveousProduct!..authToken = auth.token)

            create: (_) => Products(null, [],
                null), //error here saying 3 positional arguments expected,but 0 found.
            update: (ctx, auth, previusProducts) => Products(
                auth.token,
                previusProducts == null ? [] : previusProducts.items,
                auth.userId),
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CustoPageTransactionBulder(),
                  TargetPlatform.iOS: CustoPageTransactionBulder(),
                },
              ),
              primaryColor: Colors.purple,
              accentColor: Colors.orange,
              fontFamily: "Lato",
            ),
            home: auth.isAuthenticated
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authresultSnapshot) =>authresultSnapshot.connectionState ==ConnectionState.waiting? SplashScreen():AuthScreen()),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
