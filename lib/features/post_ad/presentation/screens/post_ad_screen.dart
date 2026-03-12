import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/field_label.dart';
import 'package:skillbridge/features/auth/presentation/screens/widgets/primary_button.dart';
import 'package:skillbridge/features/post_ad/data/models/skill_tag.dart';
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
  // ── Form ───────────────────────────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _cityController = TextEditingController();

  // ── UI State ───────────────────────────────────────────────────────────────
  // TODO(bloc-dev): replace _selectedImages with state.selectedImages from PostAdUpdated
  final List<File> _selectedImages = [];

  // TODO(bloc-dev): replace _selectedCategory with state.selectedCategory from PostAdUpdated
  String? _selectedCategory;

  // TODO(bloc-dev): replace _skills with state.skills from PostAdUpdated
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

  // TODO(bloc-dev): replace with (state is PostAdLoading) inside BlocBuilder
  bool _isLoading = false;

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

  // ── Dispose ────────────────────────────────────────────────────────────────
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  // TODO(bloc-dev): replace body with → cubit.addImages(files)
  void _onAddImages(List<File> files) {
    setState(() {
      final remaining = _maxImages - _selectedImages.length;
      _selectedImages.addAll(files.take(remaining));
    });
  }

  // TODO(bloc-dev): replace body with → cubit.removeImage(index)
  void _onRemoveImage(int index) {
    setState(() => _selectedImages.removeAt(index));
  }

  // TODO(bloc-dev): replace body with → cubit.selectCategory(value)
  void _onCategoryChanged(String? value) {
    setState(() => _selectedCategory = value);
  }

  // TODO(bloc-dev): replace body with → cubit.toggleSkill(index)
  void _onToggleSkill(int index) {
    setState(() {
      _skills = List.of(_skills)
        ..[index] = _skills[index].copyWith(
          isSelected: !_skills[index].isSelected,
        );
    });
  }

  // TODO(bloc-dev): replace entire method with → cubit.publishAd()
  // Loading + success + error handled by BlocListener — delete _showSuccess/_showError
  Future<void> _onPublish() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      _showError('Please select a category');
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // remove — BLoC handles
    setState(() => _isLoading = false);
    if (mounted) _showSuccess('Ad published successfully!');
  }

  // TODO(bloc-dev): delete — move to BlocListener reacting to PostAdSuccess
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

  // TODO(bloc-dev): delete — move to BlocListener reacting to PostAdFailure
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

  // TODO(bloc-dev): wire real image_picker here then call cubit.addImages()
  Future<void> _pickImages() async {
    // final picker = ImagePicker();
    // final picked = await picker.pickMultiImage();
    // if (picked.isNotEmpty) {
    //   _onAddImages(picked.map((xf) => File(xf.path)).toList());
    // }
    _showError('Add image_picker to pubspec.yaml to enable this');
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    // TODO(bloc-dev): wrap Scaffold with BlocConsumer<PostAdCubit, PostAdState>
    // listener → PostAdSuccess: navigate away, PostAdFailure: _showError
    // builder  → extract isLoading / selectedImages / selectedCategory / skills from state

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

              // ── 1. Photo Upload ────────────────────────────────────────────
              // TODO(bloc-dev): images: state.selectedImages
              PhotoUploadSection(
                images: _selectedImages,
                onSelectImages: _pickImages,
                onRemoveImage: _onRemoveImage,
              ),
              SizedBox(height: 24.h),

              // ── 2. Service Title ───────────────────────────────────────────
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

              // ── 3. Category ────────────────────────────────────────────────
              // TODO(bloc-dev): selectedCategory: state.selectedCategory
              const FieldLabel(label: 'Category'),
              CategoryDropdown(
                selectedCategory: _selectedCategory,
                categories: _categories,
                onChanged: _onCategoryChanged,
              ),
              SizedBox(height: 18.h),

              // ── 4. Description ─────────────────────────────────────────────
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

              // ── 5. Price + City ────────────────────────────────────────────
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
                          keyboardType: const TextInputType.numberWithOptions(
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

              // ── 6. Skills ──────────────────────────────────────────────────
              // TODO(bloc-dev): skills: state.skills
              const FieldLabel(label: 'Relevant Skills'),
              SkillsSection(skills: _skills, onToggle: _onToggleSkill),
              SizedBox(height: 32.h),

              // ── 7. Publish Button ──────────────────────────────────────────
              // TODO(bloc-dev): replace _isLoading with (state is PostAdLoading)
              _isLoading
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
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AppBar — separated widget
// ─────────────────────────────────────────────────────────────────────────────
class _PostAdAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight + 1);

  // ignore: unused_element
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
