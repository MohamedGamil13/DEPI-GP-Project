import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillbridge/core/routing/app_navigator.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/utils/helpers/snackbar_manger.dart';
import 'package:skillbridge/core/utils/validator/app_validator.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/auth_text_field.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/field_label.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/primary_button.dart';
import 'package:skillbridge/features/auth/presentation/viewmodel/auth_cubit.dart';
import 'package:skillbridge/generated/l10n.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              AppSnackBar.error(context, state.errorMessage);
            }

            if (state is AuthSendPasswordSuccess) {
              AppSnackBar.success(context, S.of(context).resetLinkSentMessage);
              context.gosignIn();
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // ── Back to Login ──
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => context.gosignIn(),
                      child: Container(
                        width: 38.w,
                        height: 38.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          size: 18.sp,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),

                  // ── Lock Icon ──
                  Center(
                    child: Container(
                      width: 72.w,
                      height: 72.h,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.lock_reset_outlined,
                          color: AppColors.primaryColor,
                          size: 34.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // ── Title ──
                  Center(
                    child: Text(
                      S.of(context).forgotPasswordTitle,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // ── Description ──
                  Center(
                    child: Text(
                      S.of(context).forgotPasswordDescription,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMedium,
                        height: 1.6,
                      ),
                    ),
                  ),
                  SizedBox(height: 36.h),

                  // ── Email Field ──
                  FieldLabel(label: S.of(context).emailAddressLabel),
                  AuthTextField(
                    controller: _emailController,
                    hint: S.of(context).emailHint,
                    prefixIcon: Icons.mail_outline,
                    validator: AppValidator.validateEmail,
                  ),
                  SizedBox(height: 24.h),

                  // ── Send Reset Link Button ──
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
                        label: S.of(context).sendResetLinkButton,
                        trailingIcon: Icons.send_outlined,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().sendPasswordResetEmail(
                              _emailController.text.trim(),
                            );
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 24.h),

                  // ── Help Text ──
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textMedium,
                        ),
                        children: [
                          TextSpan(text: S.of(context).didNotReceiveEmail),
                          TextSpan(
                            text: S.of(context).checkSpamText,
                            style: const TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const TextSpan(text: ' '), // spacing
                          TextSpan(text: S.of(context).orText),
                          const TextSpan(text: ' '), // spacing
                          TextSpan(
                            text: S.of(context).tryAgainText,
                            style: const TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 60.h),

                  // ── Watermark ──
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      S.of(context).watermarkText,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: AppColors.watermark,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
