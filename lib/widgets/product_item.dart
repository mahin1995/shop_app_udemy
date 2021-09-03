import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product_m>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black87,
          leading: Consumer<Product_m>(
              builder: (ctx, product, child) => IconButton(
                    icon: Icon(
                      product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      product.toggoleFavoirteStatus();
                    },
                  )),
          trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);

                /// ScaffoldMessenger.of(context).hideCurrentSnackBar()
                /// ScaffoldMessenger.of(context).showSnackbar(...)

                Scaffold.of(context).hideCurrentSnackBar();

                /// Scaffold.of(context).openDrawer();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Added Item to chart!!",
                    ),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ),
                );
              },
              color: Theme.of(context).accentColor),
        ),
      ),
    );
  }
}





// class ProductItem extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<Product_m>(
//       builder: (ctx, product, child) => ClipRRect(
//         borderRadius: BorderRadius.circular(10),
//         child: GridTile(
//           child: GestureDetector(
//             onTap: () {
//                     Navigator.of(context).pushNamed(
//                 ProductDetailScreen.routeName,
//                 arguments: product.id,
//               );
//             },
//             child: Image.network(
//                     product.imageUrl,
//               fit: BoxFit.cover,
//             ),
//           ),
//           footer: GridTileBar(
//             title: Text(
//                     product.title,
//               textAlign: TextAlign.center,
//             ),
//             backgroundColor: Colors.black87,
//             leading: IconButton(
//                     icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
//               color: Theme.of(context).accentColor,
//                     onPressed: () {
//                 product.toggoleFavoirteStatus();
//               },
//             ),
//             trailing: IconButton(
//                 icon: Icon(
//                   Icons.shopping_cart,
//                 ),
//                 onPressed: () {},
//                 color: Theme.of(context).accentColor),
//           ),
//         ),
//             ),
//     );
//   }
// }


// class ProductItem extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final product = Provider.of<Product_m>(context);
//     print(product);

//     return ClipRRect(
//       borderRadius: BorderRadius.circular(10),
//       child: GridTile(
//         child: GestureDetector(
//           onTap: () {
//             Navigator.of(context).pushNamed(
//               ProductDetailScreen.routeName,
//               arguments: product.id,
//             );
//           },
//           child: Image.network(
//             product.imageUrl,
//             fit: BoxFit.cover,
//           ),
//         ),
//         footer: GridTileBar(
//           title: Text(
//             product.title,
//             textAlign: TextAlign.center,
//           ),
//           backgroundColor: Colors.black87,
//           leading: IconButton(
//             icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
//             color: Theme.of(context).accentColor,
//             onPressed: () {
//               product.toggoleFavoirteStatus();
//             },
//           ),
//           trailing: IconButton(
//               icon: Icon(
//                 Icons.shopping_cart,
//               ),
//               onPressed: () {},
//               color: Theme.of(context).accentColor),
//         ),
//       ),
//     );
//   }
// }
