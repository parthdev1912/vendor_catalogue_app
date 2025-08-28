class ProductModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final String thumbnail;
  final String category;
  final double rating;
  final String brand;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.category,
    required this.rating,
    required this.brand,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      thumbnail: json['thumbnail'] ?? '',
      category: json['category'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      brand: json['brand'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'thumbnail': thumbnail,
      'category': category,
      'rating': rating,
      'brand': brand,
    };
  }
}