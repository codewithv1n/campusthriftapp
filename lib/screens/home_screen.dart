import 'package:flutter/material.dart';
import 'product_list_screen.dart';
import 'sell_item_screen.dart';
import 'settings_screen.dart';
import '../screens/favorites_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sell_listing_screen.dart';
import 'orders_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final Function(bool)? onThemeChanged;

  const HomeScreen({super.key, this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [Colors.grey.shade900, Colors.grey.shade900]
                : [const Color(0xFFFFF1B8), const Color(0xFF90C695)],
            stops: const [0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              Padding(
                padding: EdgeInsets.all((screenWidth * 0.05).clamp(16.0, 24.0)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Campus",
                                      style: GoogleFonts.poppins(
                                        fontSize: (screenWidth * 0.07)
                                            .clamp(26.0, 34.0),
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF90C695),
                                      ),
                                    ),
                                    TextSpan(
                                      text: "Thrift",
                                      style: GoogleFonts.poppins(
                                        fontSize: (screenWidth * 0.07)
                                            .clamp(26.0, 34.0),
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white
                                            : const Color.fromARGB(
                                                255, 22, 24, 22),
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Buy & Sell on Campus',
                                style: TextStyle(
                                  fontSize:
                                      (screenWidth * 0.035).clamp(14.0, 17.0),
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? Colors.grey.shade400
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final hasSpace = constraints.maxHeight > 600;

                    return SingleChildScrollView(
                      physics: hasSpace
                          ? const NeverScrollableScrollPhysics()
                          : const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: hasSpace ? constraints.maxHeight : 0,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  (screenWidth * 0.06).clamp(20.0, 32.0)),
                          child: Column(
                            mainAxisAlignment: hasSpace
                                ? MainAxisAlignment.center
                                : MainAxisAlignment.start,
                            children: [
                              if (!hasSpace)
                                SizedBox(height: screenHeight * 0.03),

                              // Hero Image/Icon
                              Container(
                                width: (screenWidth * 0.4).clamp(150.0, 210.0),
                                height: (screenWidth * 0.4).clamp(150.0, 210.0),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.grey.shade800
                                      : Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white
                                          .withOpacity(isDark ? 0.5 : 0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'lib/assets/images/logo.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              SizedBox(
                                  height:
                                      (screenHeight * 0.04).clamp(25.0, 50.0)),

                              // Welcome Text
                              Text(
                                'Welcome to Your',
                                style: TextStyle(
                                  fontSize:
                                      (screenWidth * 0.055).clamp(22.0, 28.0),
                                  color: isDark
                                      ? Colors.grey.shade200
                                      : Colors.grey.shade700,
                                ),
                              ),

                              Text(
                                'Campus Marketplace',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize:
                                      (screenWidth * 0.068).clamp(26.0, 34.0),
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? const Color(0xFF90C695)
                                      : Colors.grey.shade800,
                                ),
                              ),

                              SizedBox(
                                  height:
                                      (screenHeight * 0.015).clamp(10.0, 20.0)),

                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.05),
                                child: Text(
                                  'Find great deals or sell items you no longer need',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize:
                                        (screenWidth * 0.038).clamp(15.0, 19.0),
                                    color: isDark
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ),

                              SizedBox(
                                  height:
                                      (screenHeight * 0.03).clamp(20.0, 35.0)),

                              // Browse Button
                              _buildActionButton(
                                context,
                                icon: Icons.search_rounded,
                                label: 'Buy Items',
                                description: 'Explore amazing deals',
                                color: isDark
                                    ? const Color(0xFF90C695)
                                    : Colors.black,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ProductListScreen(),
                                    ),
                                  );
                                },
                              ),

                              SizedBox(
                                  height:
                                      (screenHeight * 0.015).clamp(12.0, 18.0)),

                              // Sell Button
                              _buildActionButton(
                                context,
                                icon: Icons.add_circle_outline_rounded,
                                label: 'Sell an Item',
                                description: 'List your item in seconds',
                                color: isDark
                                    ? const Color(0xFF90C695)
                                    : Colors.black,
                                onTap: () async {
                                  final newProduct = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SellItemScreen()),
                                  );

                                  if (newProduct != null) {
                                    myItems.add(newProduct);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Item added to My Sell Items!')),
                                    );
                                  }
                                },
                              ),

                              if (!hasSpace)
                                SizedBox(height: screenHeight * 0.03),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom Navigation
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: (screenWidth * 0.06).clamp(20.0, 28.0),
                  vertical: (screenHeight * 0.015).clamp(10.0, 16.0),
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      context,
                      icon: Icons.home,
                      label: 'Home',
                      isActive: true,
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.person,
                      label: 'User',
                      isActive: false,
                      onTap: () => _showProfileOptions(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxWidth: 500),
        padding: EdgeInsets.all((screenWidth * 0.045).clamp(18.0, 24.0)),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade800 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(isDark ? 0.1 : 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all((screenWidth * 0.035).clamp(14.0, 20.0)),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: color,
                size: (screenWidth * 0.075).clamp(30.0, 38.0),
              ),
            ),
            SizedBox(width: (screenWidth * 0.04).clamp(18.0, 24.0)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: (screenWidth * 0.048).clamp(20.0, 24.0),
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.grey.shade900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: (screenWidth * 0.035).clamp(14.0, 17.0),
                      color:
                          isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: color,
              size: (screenWidth * 0.045).clamp(19.0, 24.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    final activeGradient = isDark
        ? const [const Color(0xFFFFF1B8), Color.fromARGB(255, 91, 209, 104)]
        : [const Color(0xFFFFF1B8), Color.fromARGB(255, 91, 209, 104)];

    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: (screenWidth * 0.08).clamp(28.0, 36.0),
          vertical: (screenWidth * 0.03).clamp(10.0, 14.0),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: isActive
              ? LinearGradient(
                  colors: activeGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.3, 1.0],
                )
              : null,
          color: isActive ? null : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.white,
              size: (screenWidth * 0.065).clamp(24.0, 30.0),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: (screenWidth * 0.03).clamp(11.0, 14.0),
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileOptions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),

            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 20),

            // Profile Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [Colors.orange.shade400, Colors.red.shade400]
                            : [
                                const Color(0xFFFFF1B8),
                                const Color(0xFF90C695)
                              ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Campus Student',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.grey.shade900,
                          ),
                        ),
                        Text(
                          'student@campus.edu',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),
            _buildBottomSheetTile(
              context,
              icon: Icons.receipt_long_outlined,
              label: 'My Orders',
              color: Colors.orange,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyOrdersPage(),
                  ),
                );
              },
            ),
            _buildBottomSheetTile(
              context,
              icon: Icons.shopping_bag_outlined,
              label: 'My Sell Items',
              color: Colors.blue,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SellItemsPage(),
                  ),
                );
              },
            ),

            _buildBottomSheetTile(
              context,
              icon: Icons.favorite_border,
              label: 'Favorites',
              color: Colors.red,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FavoritesScreen()));
              },
            ),

            _buildBottomSheetTile(
              context,
              icon: Icons.settings,
              label: 'Settings',
              color: Colors.orange,
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                      onThemeChanged: onThemeChanged,
                    ),
                  ),
                );
              },
            ),

            Divider(
                height: 1,
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),

            _buildBottomSheetTile(
              context,
              icon: Icons.logout,
              label: 'Logout',
              color: Colors.red,
              onTap: () {
                Navigator.pop(context);

                _showLogoutDialog(context);
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetTile(BuildContext context,
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(label,
          style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style:
                    TextStyle(color: isDark ? Colors.white : Colors.black87)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
