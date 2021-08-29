import 'package:flutter/material.dart';

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

  void toggoleFavoirteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
