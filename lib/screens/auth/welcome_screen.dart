import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.primaryLight,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: responsive.paddingAll(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // App Logo
                Container(
                  width: responsive.spacing(120),
                  height: responsive.spacing(120),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: responsive.spacing(20),
                        offset: Offset(0, responsive.spacing(10)),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/Applogo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: responsive.spaceLarge),
                // App Name
                Text(
                  context.tr('app_name'),
                  style: TextStyle(
                    fontSize: responsive.textXXLarge,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: responsive.spaceSmall),
                // App Subtitle
                Text(
                  context.tr('app_subtitle'),
                  style: TextStyle(
                    fontSize: responsive.textMedium,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  height: responsive.spacing(56),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(responsive.radiusMedium),
                      ),
                    ),
                    child: Text(
                      context.tr('sign_in'),
                      style: TextStyle(
                        fontSize: responsive.textLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: responsive.spaceMedium),
                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: responsive.spacing(56),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white, width: responsive.spacing(2)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(responsive.radiusMedium),
                      ),
                    ),
                    child: Text(
                      context.tr('sign_up'),
                      style: TextStyle(
                        fontSize: responsive.textLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: responsive.spaceLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
