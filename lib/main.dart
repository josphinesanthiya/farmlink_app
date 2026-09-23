import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'services/api_service.dart';

void main() {
  runApp(const FarmLinkApp());
}

// ============================================================
// APP
// ============================================================

class FarmLinkApp extends StatelessWidget {
  const FarmLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FarmLink',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const WelcomePage(),
    );
  }
}

// ============================================================
// COLORS
// ============================================================

class AppColors {
  // Dark Theme
  static const background = Color(0xFF0F172A);
  static const surface = Color(0xFF182235);
  static const surface2 = Color(0xFF202C42);

  // Brand Green
  static const deepGreen = Color(0xFF0B3D20);
  static const green = Color(0xFF4CAF50);
  static const lightGreen = Color(0xFF1D3B2A);

  // Accent Colors
  static const blue = Color(0xFF3B82F6);
  static const lightBlue = Color(0xFF172D4D);

  static const orange = Color(0xFFF97316);
  static const lightOrange = Color(0xFF3D281D);

  static const amber = Color(0xFFF59E0B);
  static const lightAmber = Color(0xFF3A301B);

  static const purple = Color(0xFF8B5CF6);
  static const lightPurple = Color(0xFF2C2145);

  // Text
  static const white = Color(0xFFF8FAFC);
  static const grey = Color(0xFF94A3B8);
  static const darkGrey = Color(0xFF64748B);
}

// ============================================================
// WELCOME PAGE
// ============================================================

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF071A10),
              Color(0xFF0B3D20),
              Color(0xFF123D24),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LOGO
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.eco_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'FarmLink',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 75),

                    const Text(
                      'GROW • CONNECT • TRADE',
                      style: TextStyle(
                        color: Color(0xFF81C784),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.5,
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Connecting Farmers\nWith Better Opportunities',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 46,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 22),

                    const SizedBox(
                      width: 650,
                      child: Text(
                        'FarmLink brings farmers and dealers together in one smart marketplace.',
                        style: TextStyle(
                          color: Color(0xFFCBD5D0),
                          fontSize: 17,
                          height: 1.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    // BUTTONS
                    Wrap(
                      spacing: 14,
                      runSpacing: 14,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Get Started',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterPage(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.white38,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Create Account',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 55),

                    Wrap(
                      spacing: 14,
                      runSpacing: 14,
                      children: const [
                        FeatureCard(
                          icon: Icons.trending_up_rounded,
                          title: 'Live Market Prices',
                        ),
                        FeatureCard(
                          icon: Icons.location_on_outlined,
                          title: 'Nearby Dealers',
                        ),
                        FeatureCard(
                          icon: Icons.storefront_rounded,
                          title: 'Smart Marketplace',
                        ),
                        FeatureCard(
                          icon: Icons.verified_user_outlined,
                          title: 'Secure Trading',
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
    );
  }
}

// ============================================================
// FEATURE CARD
// ============================================================

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.10),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 25,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// ============================================================
// LOGIN PAGE
// ============================================================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscurePassword = true;
  bool isLoading = false;

  String selectedRole = 'Farmer';

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter email and password'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiService.login(
        email,
        password,
      );

      if (!mounted) return;

      final serverRole =
          response['role']?.toString().toUpperCase();

      final selectedServerRole =
          selectedRole.toUpperCase();

      // Make sure selected role matches backend role
      if (serverRole != selectedServerRole) {
        ApiService.logout();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'This account is registered as $serverRole',
            ),
          ),
        );

        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Welcome, ${response['name'] ?? 'User'}!',
          ),
        ),
      );

      if (serverRole == 'FARMER') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const FarmerDashboard(),
          ),
        );
      } else if (serverRole == 'DEALER') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const DealerDashboard(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unknown user role'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login failed: ${e.toString().replaceFirst('Exception: ', '')}',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 460,
            ),
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withOpacity(0.06),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.30),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.lightGreen,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.eco_rounded,
                      color: AppColors.green,
                      size: 38,
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Login to continue with FarmLink',
                    style: TextStyle(
                      color: AppColors.grey,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'I am a',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: RoleButton(
                          title: 'Farmer',
                          icon: Icons.agriculture_rounded,
                          selected: selectedRole == 'Farmer',
                          onTap: () {
                            setState(() {
                              selectedRole = 'Farmer';
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RoleButton(
                          title: 'Dealer',
                          icon: Icons.storefront_rounded,
                          selected: selectedRole == 'Dealer',
                          onTap: () {
                            setState(() {
                              selectedRole = 'Dealer';
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      color: AppColors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: const TextStyle(
                        color: AppColors.darkGrey,
                      ),
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: AppColors.grey,
                      ),
                      filled: true,
                      fillColor: AppColors.surface2,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    style: const TextStyle(
                      color: AppColors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                        color: AppColors.darkGrey,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.grey,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword =
                                !obscurePassword;
                          });
                        },
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.grey,
                        ),
                      ),
                      filled: true,
                      fillColor: AppColors.surface2,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            AppColors.green.withOpacity(0.5),
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const RegisterPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Create Account",
                      style: TextStyle(
                        color: AppColors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
//
// ============================================================
// REGISTER PAGE
// ============================================================

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String selectedRole = 'Farmer';

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
        ),
      );
      return;
    }

    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email'),
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password must contain at least 6 characters',
          ),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await ApiService.register(
        name: name,
        email: email,
        password: password,
        role: selectedRole.toUpperCase(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account created successfully! Please login.',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Registration failed: '
            '${e.toString().replaceFirst('Exception: ', '')}',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 480,
            ),
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withOpacity(0.06),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.30),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.lightGreen,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1_rounded,
                      color: AppColors.green,
                      size: 38,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Create Account',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 29,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Join the FarmLink community',
                    style: TextStyle(
                      color: AppColors.grey,
                    ),
                  ),

                  const SizedBox(height: 28),

                  Row(
                    children: [
                      Expanded(
                        child: RoleButton(
                          title: 'Farmer',
                          icon: Icons.agriculture_rounded,
                          selected: selectedRole == 'Farmer',
                          onTap: () {
                            setState(() {
                              selectedRole = 'Farmer';
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RoleButton(
                          title: 'Dealer',
                          icon: Icons.storefront_rounded,
                          selected: selectedRole == 'Dealer',
                          onTap: () {
                            setState(() {
                              selectedRole = 'Dealer';
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  TextField(
                    controller: nameController,
                    style: const TextStyle(
                      color: AppColors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Full Name',
                      hintStyle: const TextStyle(
                        color: AppColors.darkGrey,
                      ),
                      prefixIcon: const Icon(
                        Icons.person_outline_rounded,
                        color: AppColors.grey,
                      ),
                      filled: true,
                      fillColor: AppColors.surface2,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: emailController,
                    keyboardType:
                        TextInputType.emailAddress,
                    style: const TextStyle(
                      color: AppColors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: const TextStyle(
                        color: AppColors.darkGrey,
                      ),
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: AppColors.grey,
                      ),
                      filled: true,
                      fillColor: AppColors.surface2,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    style: const TextStyle(
                      color: AppColors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                        color: AppColors.darkGrey,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.grey,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword =
                                !obscurePassword;
                          });
                        },
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.grey,
                        ),
                      ),
                      filled: true,
                      fillColor: AppColors.surface2,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: confirmPasswordController,
                    obscureText: obscureConfirmPassword,
                    style: const TextStyle(
                      color: AppColors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      hintStyle: const TextStyle(
                        color: AppColors.darkGrey,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock_reset_rounded,
                        color: AppColors.grey,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureConfirmPassword =
                                !obscureConfirmPassword;
                          });
                        },
                        icon: Icon(
                          obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.grey,
                        ),
                      ),
                      filled: true,
                      fillColor: AppColors.surface2,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            AppColors.green.withOpacity(0.5),
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Already have an account? Login',
                      style: TextStyle(
                        color: AppColors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}S
// ============================================================
// ROLE BUTTON
// ============================================================

class RoleButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const RoleButton({
    super.key,
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.lightGreen
              : AppColors.surface2,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selected
                ? AppColors.green
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: selected
                  ? AppColors.green
                  : AppColors.grey,
              size: 28,
            ),
            const SizedBox(height: 7),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected
                    ? AppColors.green
                    : AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DARK FIELD
// ============================================================

class DarkField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool obscure;

  const DarkField({
    super.key,
    required this.hint,
    required this.icon,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure,
      style: const TextStyle(
        color: AppColors.white,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.darkGrey,
        ),
        prefixIcon: Icon(
          icon,
          color: AppColors.grey,
        ),
        filled: true,
        fillColor: AppColors.surface2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// ============================================================
// FARMER DASHBOARD
// ============================================================

class FarmerDashboard extends StatelessWidget {
  const FarmerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      title: 'Farmer Dashboard',
      name: 'Welcome back, Farmer 👋',
      subtitle: 'Grow smarter. Sell better. Earn more.',
      icon: Icons.agriculture_rounded,
      cards: const [
        DashboardCard(
          title: 'My Crops',
          subtitle: 'Manage your crops',
          icon: Icons.grass_rounded,
          color: AppColors.green,
          background: AppColors.lightGreen,
        ),
        DashboardCard(
          title: 'Market Prices',
          subtitle: 'Check latest prices',
          icon: Icons.trending_up_rounded,
          color: AppColors.amber,
          background: AppColors.lightAmber,
        ),
        DashboardCard(
          title: 'Sell Produce',
          subtitle: 'Reach more dealers',
          icon: Icons.storefront_rounded,
          color: AppColors.orange,
          background: AppColors.lightOrange,
        ),
        DashboardCard(
          title: 'My Orders',
          subtitle: 'Track your orders',
          icon: Icons.inventory_2_outlined,
          color: AppColors.blue,
          background: AppColors.lightBlue,
        ),
        DashboardCard(
          title: 'Earnings',
          subtitle: 'View your earnings',
          icon: Icons.account_balance_wallet_outlined,
          color: AppColors.amber,
          background: AppColors.lightAmber,
        ),
        DashboardCard(
          title: 'Nearby Dealers',
          subtitle: 'Find dealers around you',
          icon: Icons.location_on_outlined,
          color: AppColors.blue,
          background: AppColors.lightBlue,
        ),
      ],
    );
  }
}

// ============================================================
// DEALER DASHBOARD
// ============================================================

class DealerDashboard extends StatelessWidget {
  const DealerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      title: 'Dealer Dashboard',
      name: 'Welcome back, Dealer 👋',
      subtitle: 'Find quality produce. Connect directly.',
      icon: Icons.storefront_rounded,
      cards: const [
        DashboardCard(
          title: 'Find Farmers',
          subtitle: 'Discover nearby farmers',
          icon: Icons.people_outline_rounded,
          color: AppColors.blue,
          background: AppColors.lightBlue,
        ),
        DashboardCard(
          title: 'Browse Crops',
          subtitle: 'Explore available produce',
          icon: Icons.grass_rounded,
          color: AppColors.green,
          background: AppColors.lightGreen,
        ),
        DashboardCard(
          title: 'Place Orders',
          subtitle: 'Buy directly from farmers',
          icon: Icons.shopping_cart_outlined,
          color: AppColors.orange,
          background: AppColors.lightOrange,
        ),
        DashboardCard(
          title: 'My Orders',
          subtitle: 'Track your purchases',
          icon: Icons.inventory_2_outlined,
          color: AppColors.amber,
          background: AppColors.lightAmber,
        ),
        DashboardCard(
          title: 'Messages',
          subtitle: 'Chat with farmers',
          icon: Icons.chat_bubble_outline_rounded,
          color: AppColors.purple,
          background: AppColors.lightPurple,
        ),
        DashboardCard(
          title: 'Nearby Farmers',
          subtitle: 'Explore farmers around you',
          icon: Icons.location_on_outlined,
          color: AppColors.blue,
          background: AppColors.lightBlue,
        ),
      ],
    );
  }
}

// ============================================================
// DASHBOARD SCAFFOLD
// ============================================================

class DashboardScaffold extends StatelessWidget {
  final String title;
  final String name;
  final String subtitle;
  final IconData icon;
  final List<DashboardCard> cards;

  const DashboardScaffold({
    super.key,
    required this.title,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // APP BAR
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.lightGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.eco_rounded,
                color: AppColors.green,
                size: 23,
              ),
            ),
            const SizedBox(width: 9),
            const Text(
              'FarmLink',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.account_circle_outlined,
              color: AppColors.white,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      // BODY
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1150,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  // WELCOME BANNER
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF102A1A),
                          Color(0xFF1E5631),
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(26),
                      border: Border.all(
                        color: AppColors.green
                            .withOpacity(0.15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.30),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(17),
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            color: AppColors.green,
                            size: 40,
                          ),
                        ),

                        const SizedBox(width: 18),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 25,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                subtitle,
                                style: const TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  const Text(
                    'Quick Overview',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                    ),
                  ),

                  const SizedBox(height: 16),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      return GridView.count(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        crossAxisCount:
                            constraints.maxWidth > 750
                                ? 4
                                : 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 2.2,
                        children: const [
                          StatCard(
                            title: 'Active',
                            value: '06',
                            icon: Icons.bolt_rounded,
                            color: AppColors.green,
                            background:
                                AppColors.lightGreen,
                          ),
                          StatCard(
                            title: 'Orders',
                            value: '12',
                            icon: Icons
                                .shopping_bag_outlined,
                            color: AppColors.orange,
                            background:
                                AppColors.lightOrange,
                          ),
                          StatCard(
                            title: 'Messages',
                            value: '08',
                            icon: Icons
                                .chat_bubble_outline_rounded,
                            color: AppColors.purple,
                            background:
                                AppColors.lightPurple,
                          ),
                          StatCard(
                            title: 'Nearby',
                            value: '24',
                            icon: Icons
                                .location_on_outlined,
                            color: AppColors.blue,
                            background:
                                AppColors.lightBlue,
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  Text(
                    title == 'Farmer Dashboard'
                        ? 'Your Farm'
                        : 'Your Marketplace',
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                    ),
                  ),

                  const SizedBox(height: 16),

                  GridView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount: cards.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 330,
                      mainAxisExtent: 185,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      return cards[index];
                    },
                  ),

                  const SizedBox(height: 30),

                  // SMART TIP
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius:
                          BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.white
                            .withOpacity(0.06),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            color:
                                AppColors.lightAmber,
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons
                                .lightbulb_outline_rounded,
                            color: AppColors.amber,
                            size: 28,
                          ),
                        ),

                        const SizedBox(width: 15),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'FarmLink Smart Tip',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight:
                                      FontWeight.bold,
                                  color:
                                      AppColors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Compare nearby market prices before making your next trade.',
                                style: TextStyle(
                                  color:
                                      AppColors.grey,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.lightGreen,
        selectedIndex: 0,

        onDestinationSelected: (index) {
  if (index == 1) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SmartMapPage(),
      ),
    );
  }
},
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              color: AppColors.grey,
            ),
            selectedIcon: Icon(
              Icons.home_rounded,
              color: AppColors.green,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.map_outlined,
              color: AppColors.grey,
            ),
            selectedIcon: Icon(
              Icons.map_rounded,
              color: AppColors.blue,
            ),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.grey,
            ),
            selectedIcon: Icon(
              Icons.shopping_bag_rounded,
              color: AppColors.orange,
            ),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person_outline_rounded,
              color: AppColors.grey,
            ),
            selectedIcon: Icon(
              Icons.person_rounded,
              color: AppColors.purple,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DASHBOARD CARD
// ============================================================

class DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color background;

  const DashboardCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.20),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: background,
                borderRadius:
                    BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),

            const Spacer(),

            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// STAT CARD
// ============================================================

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color background;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: background,
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class SmartMapPage extends StatefulWidget {
  const SmartMapPage({super.key});

  @override
  State<SmartMapPage> createState() => _SmartMapPageState();
}
class _SmartMapPageState extends State<SmartMapPage> {
  StreamSubscription<Position>? _positionSubscription;
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStream;
  void _startLiveLocation() {
  const locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );

  _positionStream =
      Geolocator.getPositionStream(
    locationSettings: locationSettings,
  ).listen((Position position) {
    if (!mounted) return;

    setState(() {
      _currentPosition = position;
    });

    _mapController.move(
      LatLng(
        position.latitude,
        position.longitude,
      ),
      16,
    );
  });
}
  bool _isLoadingLocation = false;
  final List<LatLng> farmerLocations = [
  LatLng(10.7905, 78.7047),
  LatLng(10.8050, 78.6900),
  LatLng(10.7750, 78.7200),
];

final List<LatLng> dealerLocations = [
  LatLng(10.8000, 78.7150),
  LatLng(10.7800, 78.6950),
  LatLng(10.8150, 78.6800),
];
  final MapController _mapController = MapController();
  @override
void initState() {
  super.initState();
  _startLiveLocation();
}
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final position =
          await Geolocator.getCurrentPosition();

      setState(() {
        _currentPosition = position;
      });
      _mapController.move(
  LatLng(
    position.latitude,
    position.longitude,
  ),
  15,
);

      debugPrint(
        'Latitude: ${position.latitude}, '
        'Longitude: ${position.longitude}',
      );
    } catch (e) {
      debugPrint('Location error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }
   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Row(
          children: [
            Icon(
              Icons.map_rounded,
              color: AppColors.blue,
            ),
            SizedBox(width: 10),
            Text(
              'Smart Map',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: Stack(
        children: [

          // MAP AREA
         FlutterMap(
          mapController: _mapController,
  options: const MapOptions(
    initialCenter: LatLng(10.7905, 78.7047),
    initialZoom: 13,
  ),
  children: [
    TileLayer(
      urlTemplate:
          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.farmlink.app',
      maxZoom: 19,
    ),
    if (_currentPosition != null)
  MarkerLayer(
    markers: [
      Marker(
        point: LatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        ),
        width: 50,
        height: 50,
        child: const Icon(
          Icons.location_on,
          size: 45,
          color: Colors.blue,
        ),
      ),
    ],
  ),
  ],
),


          // SEARCH BAR
          Positioned(
            top: 18,
            left: 18,
            right: 18,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.30),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const TextField(
                style: TextStyle(
                  color: AppColors.white,
                ),
                decoration: InputDecoration(
                  hintText:
                      'Search farmers, dealers or crops...',
                  hintStyle: TextStyle(
                    color: AppColors.grey,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.blue,
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 17),
                ),
              ),
            ),
          ),

          // FILTER BUTTONS
          Positioned(
            top: 85,
            left: 18,
            right: 18,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _filterChip(
                    '🌾 Farmers',
                    AppColors.green,
                  ),
                  const SizedBox(width: 10),
                  _filterChip(
                    '🏪 Dealers',
                    AppColors.orange,
                  ),
                  const SizedBox(width: 10),
                  _filterChip(
                    '📍 Nearby',
                    AppColors.blue,
                  ),
                ],
              ),
            ),
          ),

          // FARMER MARKERS
          const Positioned(
            top: 230,
            left: 80,
            child: MapMarker(
              icon: Icons.agriculture_rounded,
              color: AppColors.green,
              label: 'Farmer',
            ),
          ),

          const Positioned(
            top: 340,
            right: 80,
            child: MapMarker(
              icon: Icons.storefront_rounded,
              color: AppColors.orange,
              label: 'Dealer',
            ),
          ),

          const Positioned(
            top: 470,
            left: 150,
            child: MapMarker(
              icon: Icons.agriculture_rounded,
              color: AppColors.green,
              label: 'Farmer',
            ),
          ),

          // CURRENT LOCATION
          Positioned(
            right: 20,
            bottom: 170,
            child: FloatingActionButton(
              heroTag: 'locationButton',
              backgroundColor: AppColors.surface,
              onPressed: () {
  _getCurrentLocation();
  _startLiveLocation();
},
              child: const Icon(
                Icons.my_location_rounded,
                color: AppColors.blue,
              ),
            ),
          ),

          // BOTTOM INFO CARD
          Positioned(
            left: 18,
            right: 18,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.07),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.eco_rounded,
                        color: AppColors.green,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'FarmLink Nearby',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Discover farmers and dealers around your location.',
                    style: TextStyle(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _filterChip(
    String title,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: color.withOpacity(0.5),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
class MapMarker extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const MapMarker({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 15,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 23,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
class MapGridPainter extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 1;

    const gridSize = 55.0;

    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}