import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product_m> _item = [];
  //  var authToken;///option no1
  String? _authToken;
  String? userId;

  set authToken(String value) {
    _authToken = value;
  }

  // final String userId;
  Products(this._authToken, this._item, this.userId);

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

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    // final filterString =filterByUser? 'orderBy="creatorId"&equalTo="$userId"' :'';
    var _params;
    if (filterByUser) {
      _params = <String, String>{
        'auth': '$_authToken',
        'orderBy': json.encode("creatorId"),
        'equalTo': json.encode(userId),
      };
    }
    if (filterByUser == false) {
      _params = <String, String>{
        'auth': '$_authToken',
      };
    }
    var url = Uri.parse(
      'https://flutter-first-27064-default-rtdb.firebaseio.com/product.json?auth=$_authToken"',
    );
    try {
      final response = await http.get(url);
      Map<String, dynamic> extractedData = jsonDecode(response.body);
      // final extractedData = json.decode(response.body) as Map<String, dynamic>;

      url = Uri.parse(
          "https://flutter-first-27064-default-rtdb.firebaseio.com/userfavourite/$userId.json?auth=$_authToken");

      final favoriteResponse = await http.get(url);
      final favoriteData = jsonDecode(favoriteResponse.body);
      print(favoriteData);
      final List<Product_m> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product_m(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: favoriteData == null ? false : favoriteData[prodId] ?? false,
          imageUrl: prodData['imageUrl'],
        ));
      });
      _item = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product_m product) async {
    print("product send on api $product");
    final url = Uri.parse("https://flutter-first-27064-default-rtdb.firebaseio.com/product.json?auth=$_authToken");
    try {
      final response = await http.post(url,
          body: jsonEncode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            "creatorId": userId
          }));
      // print(jsonDecode(response.body));
      final newProduct = Product_m(
          title: product.title,
          price: product.price,
          imageUrl: product.imageUrl,
          id: jsonDecode(response.body)["name"],
          description: product.description);
      _item.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    } // _item.insert(0, newProduct);///to add to first of list
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> updateProduct(String id, Product_m newProduct) async {
    final prodIndex = _item.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          Uri.parse("https://flutter-first-27064-default-rtdb.firebaseio.com/product/$id.json?auth=$_authToken");
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            'isFavorite': newProduct.isFavorite
          }));
      _item[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('no id');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse("https://flutter-first-27064-default-rtdb.firebaseio.com/product/$id.json?auth=$_authToken");
    final existingProductIndex = _item.indexWhere((prod) => prod.id == id);
    Product_m? existingPdoduct = _item[existingProductIndex];
    _item.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    print(response.statusCode);
    if (response.statusCode >= 400) {
      _item.insert(existingProductIndex, existingPdoduct);
      notifyListeners();
      throw HttpException("Didn't delete it");
    }
    existingPdoduct = null;

    /// _item.removeWhere((prod) => prod.id == id);
  }
}
