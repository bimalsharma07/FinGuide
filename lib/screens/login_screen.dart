import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart'; // Make sure this exists in your project

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  final Color _primaryColor = const Color(0xFF0D1C2E);
  final double _elementSpacing = 24.0;
  final double _inputFieldHeight = 60.0;

  void _login() {
    // Hardcoded credentials validation
    const String correctEmail = 'FinGuide@gmail.com';
    const String correctPassword = 'FinGuide@2025';

    if (_emailController.text == correctEmail && 
        _passwordController.text == correctPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Invalid Credentials',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          content: Text('Please check your email and password',
              style: GoogleFonts.poppins()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK', style: GoogleFonts.poppins()),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildAppTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return SizedBox(
      height: _inputFieldHeight,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: GoogleFonts.poppins(
          color: _primaryColor,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.poppins(
            color: _primaryColor.withOpacity(0.7),
            fontSize: 14,
          ),
          floatingLabelStyle: GoogleFonts.poppins(
            color: _primaryColor,
            fontSize: 14,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _primaryColor, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: _primaryColor.withOpacity(0.5), width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _primaryColor, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          prefixIcon: Icon(prefixIcon, color: _primaryColor.withOpacity(0.7)),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 140,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      Text(
                        'FinGuide',
                        style: GoogleFonts.poppins(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: _primaryColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Complete solution to your finance',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: _primaryColor.withOpacity(0.8),
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(height: _elementSpacing * 2),

                  // Email Field
                  _buildAppTextField(
                    controller: _emailController,
                    labelText: 'Email Address',
                    prefixIcon: Icons.email_outlined,
                  ),
                  SizedBox(height: _elementSpacing),

                  // Password Field
                  _buildAppTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: !_showPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                        color: _primaryColor.withOpacity(0.7),
                      ),
                      onPressed: () => setState(() => _showPassword = !_showPassword),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Login Button
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Login',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
