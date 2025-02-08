import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Color _primaryColor = const Color(0xFF0D1C2E); 
  final Color _textColor = Colors.white;

  @override
  void initState() {
    super.initState();
    // Navigate to login after animations complete
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryColor, // Blue background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedTextKit(
              isRepeatingAnimation: false,
              animatedTexts: [
                TyperAnimatedText(
                  'FinGuide',
                  textStyle: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: _textColor, // White text
                    letterSpacing: -0.5,
                  ),
                  speed: const Duration(milliseconds: 150),
                ),
              ],
            ),
            const SizedBox(height: 8),
            AnimatedTextKit(
              isRepeatingAnimation: false,
              animatedTexts: [
                TypewriterAnimatedText(
                  'Complete solution to your finance',
                  textStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    color: _textColor.withOpacity(0.9),
                    height: 1.4,
                  ),
                  speed: const Duration(milliseconds: 50),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
