import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skillbridge/core/routing/app_navigator.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/utils/helpers/snackbar_manger.dart';
import 'package:skillbridge/core/utils/validator/app_validator.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/auth_text_field.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/field_label.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/or_divider.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/primary_button.dart';
import 'package:skillbridge/features/auth/presentation/viewmodel/auth_cubit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthFaliure) {
              AppSnackBar.error(context, state.errorMassege);
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40.h),

                  // ── Title ──
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  const Text(
                    'Join ServiMarket today and find the best local services.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textMedium,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // ── Full Name ──
                  const FieldLabel(label: 'Full Name'),
                  AuthTextField(
                    controller: _nameController,
                    hint: 'John Doe',
                    prefixIcon: Icons.person_outline,
                    validator: (value) =>
                        value!.isEmpty ? "Name is required" : null,
                  ),
                  SizedBox(height: 18.h),

                  // ── Email Address ──
                  const FieldLabel(label: 'Email Address'),
                  AuthTextField(
                    controller: _emailController,
                    validator: AppValidator.validateEmail,
                    hint: 'john@example.com',
                    prefixIcon: Icons.mail_outline,
                  ),
                  SizedBox(height: 18.h),

                  // ── Password ──
                  const FieldLabel(label: 'Password'),
                  AuthTextField(
                    controller: _passwordController,
                    validator: AppValidator.validatePassword,
                    hint: 'Create a password',
                    prefixIcon: Icons.lock_outline,
                    obscure: true,
                    showToggle: true,
                  ),
                  SizedBox(height: 32.h),

                  // ── Sign Up Button (With BlocBuilder) ──
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        );
                      }
                      return PrimaryButton(
                        label: 'Sign Up',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().signUp(
                              _emailController.text.trim(),
                              _passwordController.text,
                            );
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 18.h),

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
                          onTap: () => context.gosignIn(),
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
                  SizedBox(height: 28.h),

                  // ── Divider ──
                  const OrDivider(label: 'OR CONTINUE WITH'),
                  SizedBox(height: 18.h),

                  // ── Google Button ──
                  GestureDetector(
                    onTap: () {
                      // context.read<AuthCubit>().signInWithGoogle();
                    },
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
                  SizedBox(height: 20.h),

                  // ── Terms ──
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textLight,
                        ),
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
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
