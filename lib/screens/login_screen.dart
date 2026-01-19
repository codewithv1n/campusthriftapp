import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginScreen extends StatefulWidget {
  final Function(bool)? onThemeChanged;

  const LoginScreen({super.key, this.onThemeChanged});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isDarkMode = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    studentIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final studentId = studentIdController.text.trim().toLowerCase();
      final password = passwordController.text.trim();

      // Query Firestore for user
      final userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('studentId', isEqualTo: studentId)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        if (!mounted) return;
        _showSnackBar(
            'Student ID not found', Colors.red.shade600, Icons.error_outline);
        setState(() => _isLoading = false);
        return;
      }

      final userData = userQuery.docs.first.data();
      final userId = userQuery.docs.first.id;

      if (userData['password'] != password) {
        if (!mounted) return;
        _showSnackBar(
            'Incorrect password', Colors.red.shade600, Icons.error_outline);
        setState(() => _isLoading = false);
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);
      await prefs.setString('studentId', studentId);
      await prefs.setString('fullName', userData['fullName'] ?? 'Student');
      await prefs.setString('email', userData['email'] ?? '');

      if (!mounted) return;

      setState(() => _isLoading = false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomeScreen(onThemeChanged: widget.onThemeChanged),
        ),
      );

      _showSnackBar('Welcome back, ${userData['fullName']}!',
          Colors.green.shade600, Icons.check_circle_outline);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnackBar(
          'Login failed: $e', Colors.red.shade600, Icons.error_outline);
    }
  }

  void _showSnackBar(String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _isDarkMode
                ? [Colors.grey.shade900, Colors.grey.shade900]
                : [const Color(0xFFFFF1B8), const Color(0xFF90C695)],
            stops: const [0.4, 0.6],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Circle Avatar with glow
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _isDarkMode
                                  ? Colors.white.withOpacity(0.25)
                                  : Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 2,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('lib/assets/images/logo.png'),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // App Title
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Campus",
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF90C695),
                              ),
                            ),
                            TextSpan(
                              text: "Thrift",
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: _isDarkMode
                                    ? Colors.white
                                    : const Color(0xFF161618),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Your Campus Marketplace",
                        style: TextStyle(
                          fontSize: 16,
                          color: _isDarkMode
                              ? Colors.grey.shade300
                              : Colors.grey.shade900,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Login Card
                      Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: _isDarkMode
                              ? Colors.grey.shade800.withOpacity(0.5)
                              : Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome Back!",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color:
                                    _isDarkMode ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Login to continue shopping",
                              style: TextStyle(
                                fontSize: 14,
                                color: _isDarkMode
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade900,
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Student ID Field
                            _buildTextField(
                              controller: studentIdController,
                              label: "Student ID",
                              hint: "Enter your student ID",
                              icon: Icons.badge_outlined,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Please enter your student ID';
                                if (!RegExp(r'^s\d+$')
                                    .hasMatch(value.toLowerCase())) {
                                  return 'Please start with "s" followed by numbers';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Password Field
                            _buildTextField(
                              controller: passwordController,
                              label: "Password",
                              hint: "Enter your password",
                              icon: Icons.lock_outline,
                              obscure: _obscurePassword,
                              toggleObscure: () {
                                setState(
                                    () => _obscurePassword = !_obscurePassword);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Please enter your password';
                                if (value.length < 6)
                                  return 'Password must be at least 6 characters';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Forgot Password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => _showSnackBar(
                                    'Password reset feature coming soon!',
                                    Colors.grey.shade400,
                                    Icons.info_outline),
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: _isDarkMode
                                        ? Colors.grey.shade300
                                        : Colors.grey.shade900,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),

                            // Login Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isDarkMode
                                      ? const Color(0xFF90C695)
                                      : Colors.black87,
                                  foregroundColor: Colors.white,
                                  elevation: 5,
                                  shadowColor: Colors.grey.withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  disabledBackgroundColor: Colors.grey[400],
                                ),
                                child: _isLoading
                                    ? ShaderMask(
                                        shaderCallback: (bounds) =>
                                            const LinearGradient(
                                          colors: [
                                            Color(0xFFFFF1B8), // yellow
                                            Color(0xFF90C695), // green
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ).createShader(bounds),
                                        child: LoadingAnimationWidget
                                            .threeRotatingDots(
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      )
                                    : const Text(
                                        "Login",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Sign Up Option
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: _isDarkMode
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade900,
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpScreen()),
                              );

                              if (result == true && mounted) {
                                _showSnackBar(
                                    'Account created successfully! Please login.',
                                    Colors.green.shade600,
                                    Icons.check_circle_outline);
                              }
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: _isDarkMode
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade900,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: _isDarkMode
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscure = false,
    VoidCallback? toggleObscure,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: TextStyle(
        fontSize: 16,
        color: _isDarkMode ? Colors.white : Colors.black87,
      ),
      cursorColor: Colors.white70,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(
          color: _isDarkMode ? Colors.grey.shade400 : Colors.black87,
        ),
        floatingLabelStyle:
            TextStyle(color: _isDarkMode ? Colors.white70 : Colors.black87),
        hintStyle: TextStyle(color: Colors.grey.shade500),
        prefixIcon: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _isDarkMode ? Colors.grey.shade700 : Colors.black12,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFFFFF1B8), // yellow
                Color(0xFF90C695), // green
              ],
              stops: const [0.5, 0.5],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
        suffixIcon: toggleObscure != null
            ? IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
                onPressed: toggleObscure,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: _isDarkMode ? Colors.grey.shade600 : Colors.grey.shade900,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: _isDarkMode ? Colors.white70 : Colors.black87,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: _isDarkMode ? Colors.grey.shade700 : Colors.white,
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
