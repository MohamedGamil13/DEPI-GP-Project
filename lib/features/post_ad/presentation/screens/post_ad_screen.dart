import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skillbridge/core/models/ad_model.dart';
import 'package:skillbridge/core/routing/app_navigator.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/utils/helpers/snackbar_manger.dart';
import 'package:skillbridge/core/utils/validator/app_validator.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/field_label.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/primary_button.dart';
import 'package:skillbridge/features/post_ad/presentation/viewModel/ad_posting_cubit.dart';
import 'package:skillbridge/features/post_ad/presentation/viewModel/ad_posting_state.dart';
import 'package:skillbridge/features/post_ad/presentation/widgets/category_dropdown.dart';
import 'package:skillbridge/features/post_ad/presentation/widgets/photo_upload_section.dart';
import 'package:skillbridge/features/post_ad/presentation/widgets/post_ad_app_bar.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
        if (state.error != null) {
          AppSnackBar.error(context, state.error!);
        } else if (!state.isLoading && state.error == null) {
          AppSnackBar.success(context, 'Ad published successfully!');
          context.popPage();
        }
      },
      builder: (context, state) {
        final cubit = context.read<PostCubit>();

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: const PostAdAppBar(),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // Photo upload section
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
                        'Describe your service in detail, including what\'s included and your experience.',
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

                  state.isLoading
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

  Future<void> _onPublish(BuildContext context, PostCubit cubit) async {
    if (!_formKey.currentState!.validate()) return;

    final state = cubit.state;

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
      category: AdCategories.values.firstWhere(
        (e) => e.name.toLowerCase() == state.selectedCategory!.toLowerCase(),
        orElse: () => AdCategories.services,
      ),
      relevantSkills: selectedSkills,
      adCity: AdCity.values.firstWhere(
        (e) =>
            e.name.toLowerCase() == _cityController.text.trim().toLowerCase(),
        orElse: () => AdCity.cairo,
      ),
      images: state.images,
    );

    await cubit.publishNewAd(adModel: ad);
  }

  Future<void> _pickImages(PostCubit cubit) async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      cubit.addImages(picked.map((xf) => File(xf.path)).toList());
    }
  }
}
