import 'dart:io';
import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product_details_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final List<Product> sampleProducts = [
    Product(
        name: "Scientific Calculator",
        price: 350,
        description: "Almost new calculator",
        imagePaths: []),
    Product(
        name: "Notebook Bundle",
        price: 120,
        description: "5 pcs notebooks",
        imagePaths: []),
    Product(
        name: "Used PE Uniform",
        price: 150,
        description: "Good condition",
        imagePaths: []),
    Product(
        name: "Textbook: Physics 101",
        price: 500,
        description: "Latest edition, minimal highlights",
        imagePaths: []),
    Product(
        name: "Desk Lamp",
        price: 200,
        description: "LED, adjustable brightness",
        imagePaths: []),
  ];

  String searchQuery = '';

  List<Product> get filteredProducts {
    if (searchQuery.isEmpty) return sampleProducts;
    return sampleProducts.where((product) {
      return product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : Colors.blue.shade900,
        title: const Text(
          'Available Items',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF121212), const Color(0xFF1E1E1E)]
                : [const Color(0xFFFFF1B8), const Color(0xFF90C695)],
            stops: const [0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Search Section
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.black.withOpacity(0.3)
                            : Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: TextField(
                        onChanged: (value) =>
                            setState(() => searchQuery = value),
                        style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87),
                        decoration: InputDecoration(
                          hintText: 'Search items...',
                          hintStyle: TextStyle(
                              color: isDark
                                  ? Colors.white30
                                  : Colors.grey.shade400),
                          prefixIcon: Icon(Icons.search_rounded,
                              color: isDark
                                  ? Colors.white70
                                  : Colors.blue.shade600),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(Icons.shopping_bag_outlined,
                            size: 22,
                            color:
                                isDark ? Colors.white70 : Colors.blue.shade600),
                        const SizedBox(width: 8),
                        Text(
                          '${filteredProducts.length} items available',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color:
                                isDark ? Colors.white70 : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Grid Content
              Expanded(
                child: filteredProducts.isEmpty
                    ? _buildEmptyState(isDark)
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          return _buildProductCard(
                              context, filteredProducts[index], index, isDark);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(
      BuildContext context, Product product, int index, bool isDark) {
    final iconColor = [
      Colors.blue.shade600,
      Colors.purple.shade600,
      Colors.orange.shade600,
      Colors.green.shade600,
      Colors.pink.shade600,
    ][index % 5];

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product)),
      ),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? Colors.black.withOpacity(0.4)
              : Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Display Area
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: product.imagePaths.isNotEmpty
                      ? Image.file(
                          File(product.imagePaths[0]),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.broken_image_outlined,
                              color: iconColor),
                        )
                      : Icon(Icons.shopping_bag_outlined,
                          size: 40, color: iconColor),
                ),
              ),
            ),
            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₱${product.price}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios,
                            size: 12,
                            color: isDark ? Colors.white24 : Colors.black26),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              size: 64, color: isDark ? Colors.white24 : Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No items found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
