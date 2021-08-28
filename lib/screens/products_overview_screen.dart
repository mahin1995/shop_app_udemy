import 'package:flutter/material.dart';
import '../widgets/products_grid.dart';
import '../models/product.dart';
import '../widgets/product_item.dart';


class ProductsOverviewScreen extends StatelessWidget {

  // const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shop app"),backgroundColor: Theme.of(context).accentColor,),
      body: ProductGrid(),
    );
  }
}

