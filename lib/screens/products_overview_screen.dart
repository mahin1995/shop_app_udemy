import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import '../providers/cart.dart';

// import 'package:provider/provider.dart';
// import '../providers/products.dart';

enum FilterOptions { Faviorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  // const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavourite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop app"),
        backgroundColor: Theme.of(context).accentColor,
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectValue) {
              setState(() {
                if (selectValue == FilterOptions.Faviorites) {
                  _showOnlyFavourite = true;
                } else {
                  _showOnlyFavourite = false;
                }
                print(selectValue);
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Only Favorites"),
                value: FilterOptions.Faviorites,
              ),
              PopupMenuItem(
                child: Text("Show Alll"),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      body: ProductGrid(_showOnlyFavourite),
    );
  } 
}



// class ProductsOverviewScreen extends StatelessWidget {
//   // const ProductsOverviewScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final productContainer = Provider.of<Products>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Shop app"),
//         backgroundColor: Theme.of(context).accentColor,
//         actions: [
//           PopupMenuButton(
//             onSelected: (FilterOptions selectValue) {
//               if (selectValue == FilterOptions.Faviorites) {
//                 productContainer.showFavoritesOnly();
//               } else {
//                 productContainer.showAll();
//               }
//               print(selectValue);
//             },
//             icon: Icon(Icons.more_vert),
//             itemBuilder: (_) => [
//               PopupMenuItem(
//                 child: Text("Only Favorites"),
//                 value: FilterOptions.Faviorites,
//               ),
//               PopupMenuItem(
//                 child: Text("Show Alll"),
//                 value: FilterOptions.All,
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: ProductGrid(),
//     );
//   }
// }
