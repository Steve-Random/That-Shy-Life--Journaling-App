import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'app_theme.dart';
import 'RegisterScreen.dart';
import 'LegalScreen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              //Logo Icon
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_stories_rounded,
                  size: 44,
                  color: AppTheme.primary,
                ),
              ),

              const SizedBox(height: 28),

              //App name
              Text(
                'That Shy Life',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 24),

              Icon(
                Icons.air_rounded,
                size: 72,
                  color: AppTheme.primary.withValues(alpha: 0.4),
              ),

              const SizedBox(height: 8),

              // Tagline
              Text(
                'A quiet space to reflect, recharge, and track your energy.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 17),

              //Feature bullets
              _feature(Icons.lock_outline_rounded,
                  'Your journal, private and encrypted'),
              const SizedBox(height: 12),
              _feature(Icons.battery_charging_full_rounded,
                  'Track your social battery daily'),
              const SizedBox(height: 12),
              _feature(
                  Icons.insights_rounded, 'See your energy patterns over time'),

              const SizedBox(height: 24),

              //Get Started button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegisterScreen()),
                      ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              //Sign In button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 20),


          Center(
            child: TextButton(
              onPressed: () =>
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LegalScreen()),
                  ),
              child: const Text(
                'Privacy policy & Terms of Service',
                style: TextStyle(fontSize: 13, color: AppTheme.primary),
              ),
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _feature(IconData icon, String text){
    return Row(
      children: [
        Icon(icon, color: AppTheme.primary, size: 20),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(fontSize: 15, color: Colors.grey[700]),
        ),
      ],
    );
  }
}