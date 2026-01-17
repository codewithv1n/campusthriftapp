import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool _isLoading = true;
  String _userId = '';
  int _totalListings = 0;
  int _soldItems = 0;
  int _activeListings = 0;
  double _totalRevenue = 0.0;
  List<Map<String, dynamic>> _recentSales = [];
  Map<String, int> _salesByCategory = {};

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      _userId = prefs.getString('userId') ?? '';

      if (_userId.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      final productsQuery = await FirebaseFirestore.instance
          .collection('products')
          .where('sellerId', isEqualTo: _userId)
          .get();

      int sold = 0;
      int active = 0;
      double revenue = 0.0;
      Map<String, int> categoryCount = {};

      for (var doc in productsQuery.docs) {
        final data = doc.data();
        final status = data['status'] ?? 'available';
        final category = data['category'] ?? 'Other';

        if (status == 'sold') {
          sold++;
          revenue += (data['price'] ?? 0.0);
          categoryCount[category] = (categoryCount[category] ?? 0) + 1;
        } else if (status == 'available') {
          active++;
        }
      }

      final salesQuery = await FirebaseFirestore.instance
          .collection('orders')
          .where('sellerId', isEqualTo: _userId)
          .orderBy('createdAt', descending: true)
          .limit(5)
          .get();

      List<Map<String, dynamic>> sales = [];
      for (var doc in salesQuery.docs) {
        sales.add({'id': doc.id, ...doc.data()});
      }

      setState(() {
        _totalListings = productsQuery.docs.length;
        _soldItems = sold;
        _activeListings = active;
        _totalRevenue = revenue;
        _recentSales = sales;
        _salesByCategory = categoryCount;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading analytics: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [Colors.grey.shade900, Colors.grey.shade800]
                  : [const Color(0xFFFFF1B8), const Color(0xFF90C695)],
            ),
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Sales Analytics',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : Colors.black87,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [Colors.grey.shade900, Colors.grey.shade800]
                : [const Color(0xFFFFF1B8), const Color(0xFF90C695)],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _loadAnalytics,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Cards 2-per-row
                  _buildStatsGrid(isDark),
                  const SizedBox(height: 24),

                  // Sales by Category Chart
                  if (_salesByCategory.isNotEmpty) ...[
                    _buildSectionTitle('Sales by Category', isDark),
                    const SizedBox(height: 12),
                    _buildCategoryChart(isDark),
                    const SizedBox(height: 24),
                  ],

                  // Recent Sales
                  _buildSectionTitle('Recent Sales', isDark),
                  const SizedBox(height: 12),
                  _buildRecentSales(isDark),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 2-per-row Stats Grid
  Widget _buildStatsGrid(bool isDark) {
    final cards = [
      _buildStatCard(
        icon: Icons.inventory_2_outlined,
        label: 'Total Listings',
        value: _totalListings.toString(),
        color: Colors.blue,
        isDark: isDark,
      ),
      _buildStatCard(
        icon: Icons.check_circle_outline,
        label: 'Items Sold',
        value: _soldItems.toString(),
        color: Colors.green,
        isDark: isDark,
      ),
      _buildStatCard(
        icon: Icons.store_outlined,
        label: 'Active Listings',
        value: _activeListings.toString(),
        color: Colors.orange,
        isDark: isDark,
      ),
      _buildStatCard(
        icon: Icons.attach_money,
        label: 'Total Revenue',
        value: '₱${_totalRevenue.toStringAsFixed(0)}',
        color: const Color(0xFF90C695),
        isDark: isDark,
      ),
    ];

    List<Widget> rows = [];
    for (int i = 0; i < cards.length; i += 2) {
      rows.add(Row(
        children: [
          Expanded(child: cards[i]),
          const SizedBox(width: 12),
          if (i + 1 < cards.length)
            Expanded(child: cards[i + 1])
          else
            Expanded(child: Container()),
        ],
      ));
      rows.add(const SizedBox(height: 12));
    }

    return Column(children: rows);
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withOpacity(0.3)
            : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black87),
    );
  }

  Widget _buildCategoryChart(bool isDark) {
    if (_salesByCategory.isEmpty) {
      return _emptyChartPlaceholder(isDark, 'No sales data yet');
    }

    final total = _salesByCategory.values.reduce((a, b) => a + b);
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal
    ];

    return Container(
      height: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withOpacity(0.3)
            : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: _salesByCategory.entries
                    .toList()
                    .asMap()
                    .entries
                    .map((entry) {
                  final index = entry.key;
                  final mapEntry = entry.value;
                  final count = mapEntry.value;
                  final percentage = (count / total * 100);
                  return PieChartSectionData(
                    color: colors[index % colors.length],
                    value: count.toDouble(),
                    title: '${percentage.toStringAsFixed(0)}%',
                    radius: 50,
                    titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children:
                _salesByCategory.entries.toList().asMap().entries.map((entry) {
              final index = entry.key;
              final mapEntry = entry.value;
              final category = mapEntry.key;
              final count = mapEntry.value;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                          color: colors[index % colors.length],
                          shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text('$category ($count)',
                      style: TextStyle(
                          fontSize: 12,
                          color:
                              isDark ? Colors.white70 : Colors.grey.shade700)),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _emptyChartPlaceholder(bool isDark, String text) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withOpacity(0.3)
            : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Center(
        child: Text(
          text,
          style:
              TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade700),
        ),
      ),
    );
  }

  Widget _buildRecentSales(bool isDark) {
    if (_recentSales.isEmpty)
      return _emptyChartPlaceholder(isDark, 'No sales yet');

    return Column(
      children: _recentSales.map((sale) {
        final productName = sale['productName'] ?? 'Unknown Product';
        final price = sale['price'] ?? 0.0;
        final buyerName = sale['buyerName'] ?? 'Unknown Buyer';
        final timestamp = sale['createdAt'] as Timestamp?;
        final date = timestamp?.toDate();
        final dateStr =
            date != null ? '${date.day}/${date.month}/${date.year}' : 'N/A';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.check_circle,
                    color: Colors.green, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: isDark ? Colors.white : Colors.black87)),
                    const SizedBox(height: 4),
                    Text('Buyer: $buyerName',
                        style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? Colors.white70
                                : Colors.grey.shade600)),
                    const SizedBox(height: 2),
                    Text(dateStr,
                        style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? Colors.white38
                                : Colors.grey.shade500)),
                  ],
                ),
              ),
              Text('₱${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
