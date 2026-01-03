import 'dart:io';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/sell_item_screen.dart';

List<Product> myItems = [];

class SellItemsPage extends StatefulWidget {
  const SellItemsPage({super.key});
  @override
  State<SellItemsPage> createState() => _SellItemsPageState();
}

class _SellItemsPageState extends State<SellItemsPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        title: const Text(
          'My Sell Items',
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
          child:
              myItems.isNotEmpty ? _buildItemsList() : _buildEmptyState(isDark),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToSellItem,
        backgroundColor: const Color(0xFF90C695),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Sell Item'),
      ),
    );
  }

  void _navigateToSellItem() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SellItemScreen()),
    );

    if (!mounted) return;

    print("RECEIVED DATA: $result");

    if (result != null) {
      setState(() {
        myItems.insert(0, result as Product);
      });
      print("SUCCESS: Item added to list. Count: ${myItems.length}");
    } else {
      print(
          "FAILED: Result is null. Check if Navigator.pop(context, data) was used.");
    }
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined,
              size: 80, color: isDark ? Colors.white70 : Colors.grey.shade700),
          const SizedBox(height: 24),
          Text(
            'No items yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start selling by adding your first item',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: myItems.length,
      itemBuilder: (context, index) {
        final item = myItems[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: item.imagePaths.isNotEmpty
                ? Image.file(
                    File(item.imagePaths.first),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image, size: 60),
            title: Text(item.name),
            subtitle: Text('₱${item.price.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  myItems.removeAt(index);
                });
              },
            ),
          ),
        );
      },
    );
  }
}
