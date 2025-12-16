import '../models/product.dart';

class ProductService {
  static final List<Product> _products = [];

  static List<Product> getAllProducts() {
    return [..._products];
  }

  static void addProduct(Product product) {
    _products.add(product);
  }

  static void removeProduct(Product product) {
    _products.remove(product);
  }
}
