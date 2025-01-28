import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  final Color _primaryColor = const Color(0xFFFFFFFF);
  final Color _accentColor = const Color(0xFF0D1C2E);
  final double _elementSpacing = 28.0;

  void _login() {
    const String correctEmail = 'FinGuide@gmail.com';
    const String correctPassword = 'FinGuide@2025';

    if (_emailController.text == correctEmail && 
        _passwordController.text == correctPassword) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, a, __, c) => 
              FadeTransition(opacity: a, child: c),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => _buildErrorDialog(),
      );
    }
  }

  Widget _buildErrorDialog() {
    return Dialog(
      backgroundColor: _primaryColor.withOpacity(0.95),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: _accentColor.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, 
                color: _accentColor, 
                size: 48),
            const SizedBox(height: 16),
            Text('Invalid Credentials',
                style: GoogleFonts.poppins(
                  color: const Color.fromRGBO(13, 28, 46, 1.0),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: 12),
            Text('Please check your email and password',
                style: GoogleFonts.poppins(color: const Color.fromRGBO(13, 28, 46, 1.0))),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Try Again',
                    style: GoogleFonts.poppins(
                      color: _primaryColor,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            _primaryColor.withOpacity(0.3),
            _primaryColor.withOpacity(0.1)
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: _accentColor.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: GoogleFonts.poppins(color: Color(0xFF0D1C2E), fontSize: 16),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.poppins(color: Color(0xFF0D1C2E)),
          floatingLabelStyle: GoogleFonts.poppins(color: _accentColor),
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: _accentColor.withOpacity(0.3), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: _accentColor, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          prefixIcon: Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: _accentColor.withOpacity(0.2))),
            ),
            child: Icon(prefixIcon, color: _accentColor),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    ).animate().fade(duration: 500.ms).slideY(begin: 0.2, end: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _primaryColor,
                const Color(0xFFFFFFFF),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  SizedBox(height: _elementSpacing * 2),
                  _buildAppTextField(
                    controller: _emailController,
                    labelText: 'Email Address',
                    prefixIcon: Icons.email_outlined,
                  ),
                  SizedBox(height: _elementSpacing),
                  _buildAppTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: !_showPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                        color: Color(0xFF0D1C2E),
                      ).animate().scale(duration: 100.ms),
                      onPressed: () => setState(() => _showPassword = !_showPassword),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildForgotPassword(),
                  SizedBox(height: _elementSpacing),
                  _buildLoginButton(),
                  const SizedBox(height: 24),
                  _buildSignUpSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [_accentColor, _primaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: _accentColor.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(Icons.auto_graph_rounded, size: 60, color: Colors.white),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 2000.ms, color: _accentColor.withOpacity(0.2)),
        const SizedBox(height: 4),
        Text(
          'FinGuide',
          style: GoogleFonts.poppins(
            fontSize: 40,
            fontWeight: FontWeight.w700,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: [Color(0xFF0D1C2E), _accentColor],
              ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Complete Solution to your finance',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Color(0xFF0D1C2E),
            height: 1.4,
          ),
        ),
      ],
    ).animate().fadeIn().slideY();
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: Text(
          'Forgot Password?',
          style: GoogleFonts.poppins(
            color: _accentColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: _accentColor,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: _accentColor.withOpacity(0.3),
        ),
        child: Text(
          'Login',
          style: GoogleFonts.poppins(
            color: _primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ).animate().scaleXY(delay: 300.ms);
  }

  Widget _buildSignUpSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'New to FinGuide? ',
          style: GoogleFonts.poppins(
            color: Color(0xFF0D1C2E),
            fontSize: 16,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Create Account',
            style: GoogleFonts.poppins(
              color: _accentColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }
}