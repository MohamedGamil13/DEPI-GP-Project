import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/posts/presentation/screens/widgets/review_item_widget.dart';
import 'package:skillbridge/features/posts/presentation/viewModel/ad_details_cubit/ad_details_cubit.dart';
import 'package:skillbridge/generated/l10n.dart';

class AllReviewsScreen extends StatelessWidget {
  final AdModel ad;

  const AllReviewsScreen({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.textDark,
        title: Text(S.of(context).allReviews),
      ),
      body: BlocBuilder<AdDetailsCubit, AdDetailsState>(
        builder: (context, state) {
          if (state is AdDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          if (state is AdDetailsLoaded) {
            if (state.reviews.isEmpty) {
              return Center(
                child: Text(
                  S.of(context).noReviewsYet,
                  style: AppStyles.font14Regular.copyWith(
                    color: AppColors.textMedium,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.reviews.length,
              itemBuilder: (context, index) {
                return ReviewItemWidget(review: state.reviews[index]);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
