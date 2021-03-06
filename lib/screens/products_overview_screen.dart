import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drwar.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

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
  var _isInit = false;
  var _isLoading = false;
  @override
  void initState() {
    _isInit = true;

    // Provider.of<Products>(context,listen: false).fetchaAndSetProduct(); //if listen false it can be use in init state
    // Future.delayed(Duration.zero).then((value) {
    //   Provider.of<Products>(context).fetchaAndSetProduct();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
      drawer: AppDrwar(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showOnlyFavourite),
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
