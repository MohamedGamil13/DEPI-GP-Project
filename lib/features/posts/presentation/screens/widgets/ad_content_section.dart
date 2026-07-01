import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/theme/app_styles.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/posts/presentation/screens/all_reviews_screen.dart';
import 'package:skillbridge/features/posts/presentation/screens/widgets/ad_details_widget.dart';
import 'package:skillbridge/features/posts/presentation/screens/widgets/review_item_widget.dart';
import 'package:skillbridge/features/posts/presentation/viewModel/ad_details_cubit/ad_details_cubit.dart';
import 'package:skillbridge/generated/l10n.dart';

class ContentSection extends StatelessWidget {
  const ContentSection({super.key, required this.ad});
  final AdModel ad;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        const SizedBox(height: 20),
        SellerCard(authorId: ad.userId),
          const SizedBox(height: 24),
          _DescriptionSection(description: ad.description),
          const SizedBox(height: 24),
          const SizedBox(height: 24),
          _ReviewsSection(ad: ad),
        ],
      ),
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  final String description;

  const _DescriptionSection({required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.of(context).serviceDescription, style: AppStyles.font17Bold),
        const SizedBox(height: 8),
        Text(
          description,
          style: AppStyles.font14Regular.copyWith(
            color: AppColors.textMedium,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  final AdModel ad;

  const _ReviewsSection({required this.ad});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdDetailsCubit, AdDetailsState>(
      builder: (context, state) {
        final reviews = state is AdDetailsLoaded ? state.reviews : const [];
        final previewReviews = reviews.take(3).toList();

        final totalReviews = state is AdDetailsLoaded
            ? state.ad.totalReviews
            : ad.totalReviews;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${S.of(context).reviews} ($totalReviews)',
                  style: AppStyles.font17Bold,
                ),
                if (reviews.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => BlocProvider.value(
                            value: context.read<AdDetailsCubit>(),
                            child: AllReviewsScreen(ad: ad),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      S.of(context).seeAll,
                      style: AppStyles.font14Regular.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
            if (state is AdDetailsLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
              )
            else if (reviews.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  S.of(context).noReviewsYet,
                  style: AppStyles.font14Regular.copyWith(
                    color: AppColors.textMedium,
                  ),
                ),
              )
            else
              ...previewReviews.map(
                (review) => ReviewItemWidget(review: review),
              ),
          ],
        );
      },
    );
  }
}
