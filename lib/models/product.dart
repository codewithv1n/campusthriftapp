class Product {
  final String name;
  final double price;
  final String description;
  final List<String> imagePaths;

  Product({
    required this.name,
    required this.price,
    required this.description,
    this.imagePaths = const [],
  });

  Product copyWith({
    String? name,
    double? price,
    String? description,
    List<String>? imagePaths,
  }) {
    return Product(
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      imagePaths: imagePaths ?? this.imagePaths,
    );
  }
}
