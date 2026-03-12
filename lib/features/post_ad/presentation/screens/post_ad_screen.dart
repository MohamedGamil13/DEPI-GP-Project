import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skillbridge/core/models/ad_model.dart';
import 'package:skillbridge/core/routing/app_navigator.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';
import 'package:skillbridge/core/utils/helpers/snackbar_manger.dart';
import 'package:skillbridge/core/utils/validator/app_validator.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/field_label.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/primary_button.dart';
import 'package:skillbridge/features/post_ad/presentation/viewModel/ad_posting_cubit.dart';
import 'package:skillbridge/features/post_ad/presentation/widgets/category_dropdown.dart';
import 'package:skillbridge/features/post_ad/presentation/widgets/photo_upload_section.dart';
import 'package:skillbridge/features/post_ad/presentation/widgets/post_ad_text_field.dart';
import 'package:skillbridge/features/post_ad/presentation/widgets/skills_section.dart';

class PostAdScreen extends StatefulWidget {
  const PostAdScreen({super.key});

  @override
  State<PostAdScreen> createState() => _PostAdScreenState();
}

class _PostAdScreenState extends State<PostAdScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _cityController = TextEditingController();

  static const List<String> _categories = [
    'Technology',
    'Design',
    'Marketing',
    'Cleaning',
    'Gardening',
    'Education',
    'Health & Fitness',
    'Photography',
    'Writing',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _pickImages(AdPostingCubit cubit) async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      cubit.addImages(picked.map((xf) => File(xf.path)).toList());
    }
  }

  Future<void> _onPublish(BuildContext context, AdPostingCubit cubit) async {
    final state = cubit.state;
    if (!_formKey.currentState!.validate()) return;

    if (state.selectedCategory == null) {
      AppSnackBar.error(context, 'Please select a category');
      return;
    }

    final selectedSkills = state.skills
        .where((s) => s.isSelected)
        .map(
          (s) => RelevantSkills.values.firstWhere(
            (e) => e.name.toLowerCase() == s.label.toLowerCase(),
            orElse: () => RelevantSkills.web,
          ),
        )
        .toList();

    final ad = AdModel(
      adID: DateTime.now().millisecondsSinceEpoch,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      city: _cityController.text.trim(),
      photos: [],
      price: double.parse(_priceController.text.trim()),
      category: AdCategory.values.firstWhere(
        (e) => e.name.toLowerCase() == state.selectedCategory!.toLowerCase(),
        orElse: () => AdCategory.services,
      ),
      relevantSkills: selectedSkills,
      adCity: AdCity.values.firstWhere(
        (e) =>
            e.name.toLowerCase() == _cityController.text.trim().toLowerCase(),
        orElse: () => AdCity.cairo,
      ),
    );

    await cubit.publishNewAd(adModel: ad);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdPostingCubit, AdPostingState>(
      listener: (context, state) {
        if (state is AdPostingSuccess) {
          AppSnackBar.success(context, 'Ad published successfully!');
          context.pop();
        } else if (state is AdPostingError) {
          AppSnackBar.error(context, state.message);
        }
      },
      builder: (context, state) {
        final cubit = context.read<AdPostingCubit>();
        final isLoading = state is AdPostingLoading;

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: const _PostAdAppBar(),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  PhotoUploadSection(
                    images: state.images,
                    onSelectImages: () => _pickImages(cubit),
                    onRemoveImage: cubit.removeImage,
                  ),
                  SizedBox(height: 24.h),

                  const FieldLabel(label: 'Service Title'),
                  PostAdTextField(
                    controller: _titleController,
                    hint: 'e.g. Professional Web Development',
                    validator: AppValidator.validateService,
                  ),
                  SizedBox(height: 18.h),

                  const FieldLabel(label: 'Category'),
                  CategoryDropdown(
                    selectedCategory: state.selectedCategory,
                    categories: _categories,
                    onChanged: cubit.selectCategory,
                  ),
                  SizedBox(height: 18.h),

                  const FieldLabel(label: 'Description'),
                  PostAdTextField(
                    controller: _descriptionController,
                    hint:
                        'Describe your service in detail, including'
                        " what's included and your experience.",
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    validator: AppValidator.validateDescription,
                  ),
                  SizedBox(height: 18.h),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FieldLabel(label: 'Price (EGP)'),
                            PostAdTextField(
                              controller: _priceController,
                              hint: '0.00',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}'),
                                ),
                              ],
                              validator: AppValidator.validatePrice,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FieldLabel(label: 'City'),
                            PostAdTextField(
                              controller: _cityController,
                              hint: 'e.g. Cairo',
                              validator: AppValidator.validateCity,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),

                  const FieldLabel(label: 'Relevant Skills'),
                  SkillsSection(
                    skills: state.skills,
                    onToggle: cubit.toggleSkill,
                  ),
                  SizedBox(height: 32.h),

                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        )
                      : PrimaryButton(
                          label: 'Publish Ad',
                          onTap: () => _onPublish(context, cubit),
                        ),

                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PostAdAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight + 1);

  const _PostAdAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: Container(
          margin: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(Icons.arrow_back, size: 18.sp, color: AppColors.textDark),
        ),
      ),
      title: const Text('Post an Ad', style: AppStyles.font17Bold),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.border),
      ),
    );
  }
}
