import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/wealth_screen.dart';
import 'services/savings_service.dart';
import 'services/wealth_service.dart'; // <-- Import WealthService
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SavingsService()),
        ChangeNotifierProvider(create: (context) => WealthService()), 
        // ^ If you keep Wealth logic separate
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinGuide',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D1C2E),
          primary: const Color(0xFF0D1C2E),
          secondary: Colors.blue.shade800,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: GoogleFonts.poppins(
            color: const Color(0xFF0D1C2E),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          elevation: 2,
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/splash': (context) => const SplashScreen(),
        '/wealth': (context) => const WealthManagementScreen(),
      },
    );
  }
}
