import 'package:flutter/material.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/auth_text_field.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/field_label.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/primary_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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

              // ── Back to Login ──
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
              const SizedBox(height: 40),

              // ── Lock Icon ──
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.lock_reset_outlined,
                      color: AppColors.primaryColor,
                      size: 34,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Title ──
              const Center(
                child: Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ── Description ──
              const Center(
                child: Text(
                  "Enter your email address and we'll send you a link to reset your password and get back to ServiMarket.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textMedium,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // ── Email Field ──
              const FieldLabel(label: 'Email Address'),
              const AuthTextField(
                hint: 'name@company.com',
                prefixIcon: Icons.mail_outline,
              ),
              const SizedBox(height: 24),

              // ── Send Reset Link Button ──
              PrimaryButton(
                label: 'Send Reset Link',
                trailingIcon: Icons.send_outlined,
                onTap: () {},
              ),
              const SizedBox(height: 24),

              // ── Help Text ──
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(fontSize: 13, color: AppColors.textMedium),
                    children: [
                      TextSpan(text: "Didn't receive the email? "),
                      TextSpan(
                        text: 'Check your spam',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: ' or '),
                      TextSpan(
                        text: 'Try again',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 60),

              // ── Watermark ──
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'ServiMarket',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: AppColors.watermark,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
