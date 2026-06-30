import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillbridge/core/routing/app_navigator.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/widgets/ad_image_widget.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/posts/presentation/screens/widgets/add_review_sheet.dart';
import 'package:skillbridge/features/posts/presentation/viewModel/ad_details_cubit/ad_details_cubit.dart';
import 'package:skillbridge/features/posts/presentation/viewModel/user_data_cubit/user_data_cubit.dart';

class AdImageHeader extends StatelessWidget {
  const AdImageHeader({
    super.key,
    required this.adId,
    required this.imageUrl,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  final int adId;
  final String imageUrl;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AdHeroImage(
          adId: adId,
          imageUrl: imageUrl,
          height: 300,
          borderRadius: BorderRadius.zero,
        ),
        Positioned(
          top: 40,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: Colors.black26,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.popPage(),
                ),
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black26,
                    child: IconButton(
                      icon: const Icon(Icons.share, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.black26,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? AppColors.errorColor : Colors.white,
                      ),
                      onPressed: onFavoriteToggle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SellerCard extends StatelessWidget {
  final String authorId;

  const SellerCard({super.key, required this.authorId});

  @override
  Widget build(BuildContext context) {
    context.read<UserDataCubit>().fetchUserData(authorId);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: BlocBuilder<UserDataCubit, UserDataState>(
        builder: (context, state) {
          if (state is UserDataLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserDataFailure) {
            return Center(child: Text(state.errMessage));
          }

          if (state is UserDataSuccess) {
            final user = state.user;
            return Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(user.avatarUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.orange,
                            size: 16,
                          ),
                          Text(
                            " ${user.rating} (${user.reviews} reviews)",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () => context.goProfile(userId: authorId),
                  child: const Text("View Profile"),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class ContactButtons extends StatelessWidget {
  final AdModel ad;
  final bool isSubmittingReview;
  final bool isCreatingConversation;

  const ContactButtons({
    super.key,
    required this.ad,
    required this.isSubmittingReview,
    required this.isCreatingConversation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isSubmittingReview
                    ? null
                    : () => AddReviewSheet.show(
                        context,
                        isSubmitting: isSubmittingReview,
                        onSubmit: (rating, comment) => context
                            .read<AdDetailsCubit>()
                            .submitReview(rating: rating, comment: comment),
                      ),
                icon: isSubmittingReview
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.rate_review_outlined),
                label: const Text("Review"),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: isCreatingConversation
                    ? null
                    : () => context.read<AdDetailsCubit>().messagePoster(),
                icon: isCreatingConversation
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.chat),
                label: const Text("Message Poster"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
