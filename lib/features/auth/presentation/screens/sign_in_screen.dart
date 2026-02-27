import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/auth_text_field.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/or_divider.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/primary_button.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/social_button.dart';

import 'forgot_password_screen.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // ── Top Back Arrow ──
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 18,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Title Row ──
              // const Text(
              //   'Sign In',
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.w700,
              //     color: AppColors.textDark,
              //   ),
              // ),
              const SizedBox(height: 28),

              // ── Logo ──
              const Text(
                'ServiMarket',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryColor,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your credentials to access your account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textMedium,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // ── Phone / Email ──
              const AuthTextField(
                hint: 'Phone or Email',
                prefixIcon: Icons.mail_outline,
              ),
              const SizedBox(height: 14),

              // ── Password ──
              const AuthTextField(
                hint: 'Password',
                prefixIcon: Icons.lock_outline,
                obscure: true,
                showToggle: true,
              ),
              const SizedBox(height: 10),

              // ── Forgot Password Link ──
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordScreen(),
                    ),
                  ),
                  child: const Text(
                    'Forgotten Password?',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Sign In Button ──
              PrimaryButton(label: 'Sign In', onTap: () {}),
              const SizedBox(height: 18),

              // ── Sign Up Link ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 13, color: AppColors.textMedium),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUpScreen()),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ── Divider ──
              const OrDivider(label: 'Or continue with'),
              const SizedBox(height: 20),

              // ── Social Buttons ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialButton(
                    onTap: () {},
                    child: const FaIcon(
                      FontAwesomeIcons.google,
                      size: 20,
                      color: Color(0xFFDB4437),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SocialButton(
                    onTap: () {},
                    child: const Icon(
                      Icons.facebook,
                      color: Color(0xFF1877F2),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  SocialButton(
                    onTap: () {},
                    child: const Text(
                      '𝕏',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
