import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    studentIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFF1B8), // creamy yellow :>
              const Color(0xFF90C695) // soft green :>
            ],
            stops: const [
              0.4, // blending ng kulay
              0.6,
            ],
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
                      // Logo/Image
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('lib/assets/images/logo.png'),
                        ),
                      ),

                      const SizedBox(height: 10),

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
                                color: Color.fromARGB(255, 22, 24, 22),
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
                          color: Colors.grey.shade900,
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Login Card
                      Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
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
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Login to continue shopping",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade900,
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Student ID Field
                            TextFormField(
                              controller: studentIdController,
                              keyboardType: TextInputType.text,
                              style: const TextStyle(fontSize: 16),
                              cursorColor: Colors.blueGrey.shade600,
                              decoration: InputDecoration(
                                labelText: "Student ID",
                                hintText: "Enter your student ID",
                                labelStyle: TextStyle(
                                  color: Colors.blueGrey.shade600,
                                ),
                                floatingLabelStyle: TextStyle(
                                  color: Colors.blueGrey.shade600,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                                prefixIcon: Container(
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ShaderMask(
                                    shaderCallback: (bounds) {
                                      return const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFFFFF1B8),
                                          Color(0xFF90C695),
                                        ],
                                        stops: [0.5, 0.5],
                                      ).createShader(bounds);
                                    },
                                    child: const Icon(
                                      Icons.badge_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade900),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.blueGrey.shade600,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.red.shade400,
                                    width: 2,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.red.shade400,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your student ID';
                                }

                                value = value.trim();

                                if (!RegExp(r'^s\d+$')
                                    .hasMatch(value.toLowerCase())) {
                                  return 'Please start with "s" followed by numbers';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Password Field
                            TextFormField(
                              controller: passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(fontSize: 16),
                              cursorColor: Colors.blueGrey.shade600,
                              decoration: InputDecoration(
                                labelText: "Password",
                                hintText: "Enter your password",
                                labelStyle: TextStyle(
                                  color: Colors.blueGrey.shade600,
                                ),
                                floatingLabelStyle: TextStyle(
                                  color: Colors.blueGrey.shade600,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                ),

                                prefixIcon: Container(
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ShaderMask(
                                    shaderCallback: (bounds) {
                                      return const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFFFFF1B8),
                                          Color(0xFF90C695),
                                        ],
                                        stops: [0.5, 0.5],
                                      ).createShader(bounds);
                                    },
                                    child: const Icon(
                                      Icons.lock_outline,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                // Show / Hide Password
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.grey.shade800,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),

                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade900),
                                ),

                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.blueGrey.shade600,
                                    width: 2,
                                  ),
                                ),

                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.red.shade400,
                                    width: 2,
                                  ),
                                ),

                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.red.shade400,
                                    width: 2,
                                  ),
                                ),

                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Forgot Password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Row(
                                        children: [
                                          Icon(Icons.info_outline,
                                              color: Colors.black),
                                          SizedBox(width: 12),
                                          Text(
                                            'Password reset feature coming soon!',
                                            style:
                                                TextStyle(color: Colors.black),
                                          )
                                        ],
                                      ),
                                      backgroundColor: Colors.grey.shade400,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: Colors.grey.shade900,
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
                                  backgroundColor: Colors.black87,
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
                                            LinearGradient(
                                          colors: [
                                            const Color(0xFFFFF1B8),
                                            const Color(0xFF90C695),
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
                              color: Colors.grey.shade900,
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );

                              if (result == true && mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Row(
                                      children: [
                                        Icon(Icons.check_circle_outline,
                                            color: Colors.white),
                                        SizedBox(width: 12),
                                        Text(
                                            'Account created successfully! Please login.'),
                                      ],
                                    ),
                                    backgroundColor: Colors.green.shade600,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
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
                                color: Colors.grey.shade900,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.grey.shade900,
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
}
