import '../models/product.dart';

class FavoritesService {
  static final List<Product> favoriteItems = [];

  static void toggleFavorite(Product product) {
    if (favoriteItems.contains(product)) {
      favoriteItems.remove(product);
    } else {
      favoriteItems.add(product);
    }
  }

  static bool isFavorite(Product product) {
    return favoriteItems.contains(product);
  }

  static bool isProductFavorite(Product product) {
    return favoriteItems.contains(product);
  }
}
