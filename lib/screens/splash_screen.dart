import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart'; // For AuthWrapper

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AuthWrapper()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon or Logo
            const Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Colors.deepPurple,
            )
            .animate()
            .fade(duration: 600.ms)
            .scale(delay: 200.ms),
            
            const SizedBox(height: 20),

            // Main Title
            Text(
              'Todolist',
              style: GoogleFonts.poppins(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            )
            .animate()
            .fadeIn(delay: 400.ms, duration: 800.ms)
            .moveY(begin: 20, end: 0),

            const SizedBox(height: 10),

            // Subtitle
            Text(
              'by Wajeeha Javed',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.grey[600],
                letterSpacing: 1.2,
              ),
            )
            .animate()
            .fadeIn(delay: 800.ms, duration: 800.ms),
          ],
        ),
      ),
    );
  }
}
