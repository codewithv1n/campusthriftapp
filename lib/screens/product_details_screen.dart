import 'dart:io';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/favorites_service.dart';
import '../screens/checkout_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = FavoritesService.isProductFavorite(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: isDark ? Colors.black : Colors.blueGrey.shade50,
        child: CustomScrollView(
          slivers: [
            /// APP BAR
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              elevation: 0,
              backgroundColor:
                  isDark ? Colors.grey.shade800 : Colors.blue.shade600,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade800 : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: isDark ? Colors.white : Colors.black87),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade800 : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite
                          ? Colors.red
                          : (isDark ? Colors.white : Colors.black87),
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                        FavoritesService.toggleFavorite(widget.product);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isFavorite
                              ? 'Added to Favorites'
                              : 'Removed from Favorites'),
                          duration: const Duration(milliseconds: 700),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: widget.product.imagePaths.isNotEmpty
                    ? PageView.builder(
                        itemCount: widget.product.imagePaths.length,
                        itemBuilder: (context, index) {
                          return Image.file(
                            File(widget.product.imagePaths[index]),
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFFFF1B8),
                              Color(0xFF90C695),
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.shopping_bag_outlined,
                          size: 120,
                          color: Colors.white54,
                        ),
                      ),
              ),
            ),

            /// CONTENT
            SliverToBoxAdapter(
              child: Container(
                color: isDark
                    ? Colors.grey.shade900.withOpacity(0.8)
                    : Colors.white,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.product.name,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color:
                                  isDark ? Colors.white : Colors.grey.shade900,
                            ),
                          ),
                        ),
                        _buildStatusBadge(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildPriceCard(isDark),
                    const SizedBox(height: 30),
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.grey.shade900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.product.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildSellerInfo(isDark),
                    const SizedBox(height: 30),
                    _buildActionButtons(context),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// STATUS
  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: const [
          Icon(Icons.verified, size: 14, color: Colors.green),
          SizedBox(width: 4),
          Text(
            'Available',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  /// PRICE
  Widget _buildPriceCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade200.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.payments_outlined, color: Colors.green.shade600, size: 30),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Asking Price',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey.shade400 : Colors.green.shade700,
                ),
              ),
              Text(
                '₱${widget.product.price}',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// SELLER INFO (NO CHAT)
  Widget _buildSellerInfo(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: const [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Seller',
                  style: TextStyle(fontSize: 12, color: Colors.blue)),
              Text('Campus Student',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () => _showPurchaseDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5A8F60),
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          'Buy Now',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(product: widget.product),
      ),
    );
  }
}
