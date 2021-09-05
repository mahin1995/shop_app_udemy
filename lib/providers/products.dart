import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product_m> _item = [
    Product_m(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product_m(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product_m(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product_m(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  var _showFavoritesOnly = false;

  List<Product_m> get items {
    // if (_showFavoritesOnly) {
    //   return _item.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._item];
  }

  List<Product_m> get favoriteItems {
    return _item.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product_m findById(String id) {
    return _item.firstWhere(
      (prod) => prod.id == id,
    );
  }

  Future<void> addProduct(Product_m product) async {
    final url = Uri.parse(
        "https://flutter-first-27064-default-rtdb.firebaseio.com/product");
        try{
    final response = await http.post(url,
        body: jsonEncode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl
        }));
    print(jsonDecode(response.body));
    final newProduct = Product_m(
        title: product.title,
        price: product.price,
        imageUrl: product.imageUrl,
        id: jsonDecode(response.body)["name"],
        description: product.description);
    _item.add(newProduct);
    notifyListeners();
 }catch(error){
   print(error.toString());
   throw error;
 }   // _item.insert(0, newProduct);///to add to first of list
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  void updateProduct(String id, Product_m newProduct) {
    final prodIndex = _item.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _item[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('no id');
    }
  }

  void deleteProduct(String id) {
    _item.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
