import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillbridge/core/routing/app_navigator.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/utils/constants/app_images.dart';
import 'package:skillbridge/core/utils/helpers/snackbar_manger.dart';
import 'package:skillbridge/core/utils/validator/app_validator.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/auth_text_field.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/primary_button.dart';
import 'package:skillbridge/features/auth/presentation/viewmodel/auth_cubit.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              AppSnackBar.error(context, state.errorMessage);
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 40.h),

                          const Text(
                            'ServiMarket',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryColor,
                            ),
                          ),

                          SizedBox(height: 50.h),

                          AuthTextField(
                            controller: _emailController,
                            hint: 'Email Address',
                            prefixIcon: Icons.mail_outline,
                            validator: AppValidator.validateEmail,
                          ),

                          SizedBox(height: 20.h),

                          AuthTextField(
                            controller: _passwordController,
                            hint: 'Password',
                            prefixIcon: Icons.lock_outline,
                            obscure: true,
                            showToggle: true,
                            validator: AppValidator.validatePassword,
                          ),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => context.goForgetPassword(),
                              child: const Text(
                                'Forgotten Password?',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 32.h),

                          PrimaryButton(
                            label: 'Sign In',
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthCubit>().signIn(
                                  _emailController.text.trim(),
                                  _passwordController.text,
                                );
                              }
                            },
                          ),

                          // ── Google Section ──
                          SizedBox(height: 16.h),

                          Row(
                            children: [
                              const Expanded(
                                child: Divider(color: AppColors.textLight),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  'OR',
                                  style: TextStyle(
                                    color: AppColors.textMedium,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(color: AppColors.textLight),
                              ),
                            ],
                          ),

                          SizedBox(height: 16.h),

                          InkWell(
                            onTap: () {
                              context.read<AuthCubit>().signInWithGoogle();
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.textLight),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 10.w),
                                  Text(
                                    'Continue with ',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  Image.asset(
                                    AppImages.googleLogo,
                                    height: 30.h,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // ── Sign Up Link ──
                          SizedBox(height: 10.h),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textMedium,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.gosignUp(),
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

                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Loading Overlay ──
                if (state is AuthLoading)
                  Container(
                    color: Colors.black.withOpacity(0.2),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
