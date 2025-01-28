import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart'; // Make sure this import is added

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF0D1C2E);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            color: primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.person,
                size: 40,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Bimal Sharma',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'FinGuide@gmail.com',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: primaryColor.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 32),
            _buildProfileItem(
              icon: Icons.location_on,
              title: 'Location',
              value: 'Liverpool, UK',
            ),
            const Divider(height: 40),
            _buildProfileItem(
              icon: Icons.phone,
              title: 'Phone',
              value: '+441234567890',
            ),
            const Divider(height: 40),
            _buildProfileItem(
              icon: Icons.verified_user,
              title: 'Account Status',
              value: 'Verified',
              valueColor: Colors.green,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Updated logout navigation
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false, // Remove all previous routes
                  );
                },
                child: Text(
                  'Logout',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF0D1C2E), size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF0D1C2E).withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.poppins(
                  color: valueColor ?? const Color(0xFF0D1C2E),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}