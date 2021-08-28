class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product(
      {required this.title,
      required this.price,
      required this.imageUrl,
      required this.id,
      required this.description,
      this.isFavorite = false});
}