import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellListingScreen extends StatefulWidget {
  const SellListingScreen({super.key});

  @override
  State<SellListingScreen> createState() => _SellListingScreenState();
}

class _SellListingScreenState extends State<SellListingScreen>
    with SingleTickerProviderStateMixin {
  String? sellerId;
  String? sellerName;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadSellerInfo();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSellerInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      sellerId = prefs.getString('studentId');
      sellerName = prefs.getString('fullName');
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (sellerId == null) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [Colors.black, Colors.grey.shade900]
                : [const Color(0xFFFFF1B8), const Color(0xFF90C695)],
          ),
        ),
        child: const Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [Colors.black, Colors.grey.shade900]
              : [const Color(0xFFFFF1B8), const Color(0xFF90C695)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'Seller Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.black87,
            labelColor: isDark ? Colors.white : Colors.black87,
            unselectedLabelColor:
                isDark ? Colors.grey.shade500 : Colors.black54,
            isScrollable: false,
            tabs: const [
              Tab(text: 'My Listings'),
              Tab(text: 'Pending'),
              Tab(text: 'Confirmed'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _myListingsTab(isDark),
            _ordersTab(isDark, 'pending'),
            _ordersTab(isDark, 'confirmed'),
            _completedOrdersTab(isDark),
          ],
        ),
      ),
    );
  }

  Widget _myListingsTab(bool isDark) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('sellerId', isEqualTo: sellerId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildEmpty(isDark, 'Error loading listings');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmpty(isDark, 'No items listed yet');
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;
            return _buildProductCard(doc.id, data, isDark);
          },
        );
      },
    );
  }

  Widget _buildProductCard(
      String productId, Map<String, dynamic> data, bool isDark) {
    final name = data['name'] ?? 'Unknown';
    final price = data['price'] ?? 0;
    final stock = data['stock'] ?? 0;
    final imageUrl = data['imageUrl'] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image, size: 30),
                      ),
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image, size: 30),
                    ),
            ),
            const SizedBox(width: 12),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₱${price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Stock: $stock',
                    style: TextStyle(
                      fontSize: 12,
                      color: stock > 0 ? Colors.blue : Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            IconButton(
              onPressed: () => _editProduct(productId, data),
              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
              iconSize: 20,
            ),
            IconButton(
              onPressed: () => _deleteProduct(productId, name),
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              iconSize: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _ordersTab(bool isDark, String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('sellerId', isEqualTo: sellerId)
          .where('status', isEqualTo: status)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildEmpty(isDark, 'Error loading orders');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmpty(isDark,
              'No ${status == 'pending' ? 'pending' : 'confirmed'} orders');
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;
            return _buildOrderCard(doc.id, data, isDark, status);
          },
        );
      },
    );
  }

  Widget _completedOrdersTab(bool isDark) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('sellerId', isEqualTo: sellerId)
          .where('status', isEqualTo: 'completed')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildEmpty(isDark, 'Error loading orders');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmpty(isDark, 'No completed orders');
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;
            return _buildCompletedOrderCard(doc.id, data, isDark);
          },
        );
      },
    );
  }

  Widget _buildCompletedOrderCard(
      String orderId, Map<String, dynamic> data, bool isDark) {
    final productName = data['productName'] ?? 'Unknown';
    final productImage = data['productImage'] ?? '';
    final buyerName = data['buyerName'] ?? 'Unknown';
    final quantity = data['quantity'] ?? 1;
    final totalPrice = data['totalPrice'] ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: productImage.isNotEmpty
                  ? Image.network(
                      productImage,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image, size: 30),
                      ),
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image, size: 30),
                    ),
            ),
            const SizedBox(width: 12),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Buyer: $buyerName',
                    style: TextStyle(
                      fontSize: 13,
                      color:
                          isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₱${totalPrice.toStringAsFixed(2)} • Qty: $quantity',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'DONE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ),

            // Delete button
            IconButton(
              onPressed: () => _deleteCompletedOrder(orderId, productName),
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              iconSize: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(
      String orderId, Map<String, dynamic> data, bool isDark, String status) {
    final productName = data['productName'] ?? 'Unknown';
    final productImage = data['productImage'] ?? '';
    final buyerName = data['buyerName'] ?? 'Unknown';
    final contactNumber = data['contactNumber'] ?? 'N/A';
    final meetupLocation = data['meetupLocation'] ?? 'Not specified';
    final quantity = data['quantity'] ?? 1;
    final totalPrice = data['totalPrice'] ?? 0;
    final notes = data['notes'] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: productImage.isNotEmpty
                      ? Image.network(
                          productImage,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image, size: 30),
                          ),
                        )
                      : Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image, size: 30),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₱${totalPrice.toStringAsFixed(2)} • Qty: $quantity',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Divider(
            height: 1,
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
          ),

          // Buyer Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow(Icons.person, buyerName, isDark),
                const SizedBox(height: 6),
                _infoRow(Icons.phone, contactNumber, isDark),
                const SizedBox(height: 6),
                _infoRow(Icons.location_on, meetupLocation, isDark),
                if (notes.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  _infoRow(Icons.note, notes, isDark),
                ],
              ],
            ),
          ),

          // Actions based on status
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: status == 'pending'
                ? Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _rejectOrder(orderId),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('Reject'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () => _confirmOrder(orderId),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Confirm'),
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _completeOrder(orderId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.check_circle, size: 20),
                      label: const Text('Mark as Completed'),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty(bool isDark, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  void _editProduct(String productId, Map<String, dynamic> data) {
    final nameController = TextEditingController(text: data['name']);
    final priceController =
        TextEditingController(text: data['price'].toString());
    final stockController =
        TextEditingController(text: data['stock'].toString());
    final descController =
        TextEditingController(text: data['description'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
          title: Text(
            'Edit Product',
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    labelStyle: TextStyle(
                        color: isDark ? Colors.grey.shade400 : Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: isDark
                              ? Colors.grey.shade700
                              : Colors.grey.shade300),
                    ),
                  ),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Price',
                    labelStyle: TextStyle(
                        color: isDark ? Colors.grey.shade400 : Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: isDark
                              ? Colors.grey.shade700
                              : Colors.grey.shade300),
                    ),
                  ),
                ),
                TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Stock',
                    labelStyle: TextStyle(
                        color: isDark ? Colors.grey.shade400 : Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: isDark
                              ? Colors.grey.shade700
                              : Colors.grey.shade300),
                    ),
                  ),
                ),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(
                        color: isDark ? Colors.grey.shade400 : Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: isDark
                              ? Colors.grey.shade700
                              : Colors.grey.shade300),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('products')
                      .doc(productId)
                      .update({
                    'name': nameController.text,
                    'price': double.tryParse(priceController.text) ?? 0,
                    'stock': int.tryParse(stockController.text) ?? 0,
                    'description': descController.text,
                  });

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Product updated!'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _confirmOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({'status': 'confirmed'});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order confirmed!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _rejectOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({'status': 'cancelled'});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order rejected'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _completeOrder(String orderId) async {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
          title: Text(
            'Complete Order',
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
          content: Text(
            'Have you delivered the item to the buyer?',
            style: TextStyle(
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Not Yet'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('orders')
                      .doc(orderId)
                      .update({'status': 'completed'});

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order completed!'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Yes, Complete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(String productId, String productName) {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
          title: Text(
            'Delete Product',
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
          content: Text(
            'Delete "$productName"?',
            style: TextStyle(
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('products')
                    .doc(productId)
                    .delete();
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Product deleted'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _deleteCompletedOrder(String orderId, String productName) {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
          title: Text(
            'Delete Order',
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
          content: Text(
            'Delete this completed order for "$productName"?\n\nThis action cannot be undone.',
            style: TextStyle(
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('orders')
                      .doc(orderId)
                      .delete();
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order deleted'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
