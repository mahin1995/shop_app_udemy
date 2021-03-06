import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product_m with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product_m(
      {required this.title,
      required this.price,
      required this.imageUrl,
      required this.id,
      required this.description,
      this.isFavorite = false});

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggoleFavoirteStatus(String _authToken, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        "https://flutter-first-27064-default-rtdb.firebaseio.com/userfavourite/$userId/$id.json?auth=$_authToken");
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      print(error);
      _setFavValue(oldStatus);
    }
  }
}
