import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skillbridge/core/models/ad_model.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/field_label.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/primary_button.dart';
import 'package:skillbridge/features/post_ad/data/models/skill_tag.dart';
import 'package:skillbridge/features/post_ad/presentation/viewmodel/ad_posting_cubit.dart';
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

  final List<File> _selectedImages = [];
  String? _selectedCategory;
  List<SkillTag> _skills = [
    const SkillTag(label: 'React', isSelected: true),
    const SkillTag(label: 'Python', isSelected: true),
    const SkillTag(label: 'Cleaning'),
    const SkillTag(label: 'JavaScript'),
    const SkillTag(label: 'Gardening'),
    const SkillTag(label: 'Design'),
    const SkillTag(label: 'Marketing'),
    const SkillTag(label: 'Education'),
  ];

  static const int _maxImages = 3;

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

  void _onAddImages(List<File> files) {
    setState(() {
      final remaining = _maxImages - _selectedImages.length;
      _selectedImages.addAll(files.take(remaining));
    });
  }

  void _onRemoveImage(int index) {
    setState(() => _selectedImages.removeAt(index));
  }

  void _onCategoryChanged(String? value) {
    setState(() => _selectedCategory = value);
  }

  void _onToggleSkill(int index) {
    setState(() {
      _skills = List.of(_skills)
        ..[index] = _skills[index].copyWith(
          isSelected: !_skills[index].isSelected,
        );
    });
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      _onAddImages(picked.map((xf) => File(xf.path)).toList());
    }
  }

  Future<void> _onPublish() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      _showError('Please select a category');
      return;
    }

    final selectedSkills = _skills
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
        (e) => e.name.toLowerCase() == _selectedCategory!.toLowerCase(),
        orElse: () => AdCategory.services,
      ),
      relevantSkills: selectedSkills,
      adCity: AdCity.cairo,
    );

    await context.read<AdPostingCubit>().publishNewAd(
      adModel: ad,
      images: _selectedImages,
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        content: Text(message, style: const TextStyle(color: AppColors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdPostingCubit, AdPostingState>(
      listener: (context, state) {
        if (state is AdPostingSuccess) {
          _showSuccess('Ad published successfully!');
          Navigator.of(context).pop();
        } else if (state is AdPostingError) {
          _showError(state.message);
        }
      },
      builder: (context, state) {
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
                    images: _selectedImages,
                    onSelectImages: _pickImages,
                    onRemoveImage: _onRemoveImage,
                  ),
                  SizedBox(height: 24.h),

                  const FieldLabel(label: 'Service Title'),
                  PostAdTextField(
                    controller: _titleController,
                    hint: 'e.g. Professional Web Development',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Service title is required';
                      }
                      if (value.trim().length < 5) {
                        return 'Title must be at least 5 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 18.h),

                  const FieldLabel(label: 'Category'),
                  CategoryDropdown(
                    selectedCategory: _selectedCategory,
                    categories: _categories,
                    onChanged: _onCategoryChanged,
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
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Description is required';
                      }
                      if (value.trim().length < 20) {
                        return 'Description must be at least 20 characters';
                      }
                      return null;
                    },
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
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Price is required';
                                }
                                if (double.tryParse(value.trim()) == null) {
                                  return 'Enter a valid price';
                                }
                                return null;
                              },
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
                              hint: 'e.g. New York',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'City is required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),

                  const FieldLabel(label: 'Relevant Skills'),
                  SkillsSection(skills: _skills, onToggle: _onToggleSkill),
                  SizedBox(height: 32.h),

                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        )
                      : PrimaryButton(label: 'Publish Ad', onTap: _onPublish),

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
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          margin: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(Icons.arrow_back, size: 18.sp, color: AppColors.textDark),
        ),
      ),
      title: Text(
        'Post an Ad',
        style: TextStyle(
          fontSize: 17.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.border),
      ),
    );
  }
}
