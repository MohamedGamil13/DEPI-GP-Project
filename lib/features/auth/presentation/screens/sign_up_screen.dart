import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/auth_text_field.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/field_label.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/or_divider.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/primary_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ── Header ──
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
              const SizedBox(height: 28),

              // ── Title ──
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Join ServiMarket today and find the best local services.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textMedium,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),

              // ── Full Name ──
              const FieldLabel(label: 'Full Name'),
              const AuthTextField(
                hint: 'John Doe',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 18),

              // ── Email Address ──
              const FieldLabel(label: 'Email Address'),
              const AuthTextField(
                hint: 'john@example.com',
                prefixIcon: Icons.mail_outline,
              ),
              const SizedBox(height: 18),

              // ── Password ──
              const FieldLabel(label: 'Password'),
              const AuthTextField(
                hint: 'Create a password',
                prefixIcon: Icons.lock_outline,
                obscure: true,
                showToggle: true,
              ),
              const SizedBox(height: 28),

              // ── Sign Up Button ──
              PrimaryButton(label: 'Sign Up', onTap: () {}),
              const SizedBox(height: 18),

              // ── Login Link ──
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textMedium,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── Divider ──
              const OrDivider(label: 'OR CONTINUE WITH'),
              const SizedBox(height: 18),

              // ── Google Button ──
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.google,
                        size: 20,
                        color: Color(0xFFDB4437),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Google',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFDB4437),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Terms ──
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(fontSize: 11, color: AppColors.textLight),
                    children: [
                      TextSpan(text: 'By signing up, you agree to our '),
                      TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// class _GoogleIcon extends StatelessWidget {
//   const _GoogleIcon();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 22,
//       height: 22,
//       decoration: BoxDecoration(
//         color: AppColors.textDark,
//         borderRadius: BorderRadius.circular(3),
//       ),
//       child: const Center(
//         child: Text(
//           'G',
//           style: TextStyle(
//             color: AppColors.white,
//             fontSize: 13,
//             fontWeight: FontWeight.w800,
//           ),
//         ),
//       ),
//     );
//   }
//}
