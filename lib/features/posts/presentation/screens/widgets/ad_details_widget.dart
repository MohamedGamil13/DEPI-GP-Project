import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillbridge/core/routing/app_navigator.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/utils/helpers/snackbar_manger.dart';
import 'package:skillbridge/core/widgets/ad_image_widget.dart';
import 'package:skillbridge/features/posts/presentation/viewModel/call_cubit/call_cubit.dart';
import 'package:skillbridge/features/posts/presentation/viewModel/user_data_cubit/user_data_cubit.dart';

class AdImageHeader extends StatelessWidget {
  const AdImageHeader({
    super.key,
    required this.adId, // ← add this
    required this.imageUrl,
  });

  final int adId;
  final String imageUrl;

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
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                      ),
                      onPressed: () {},
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
                  onPressed: () {},
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
  const ContactButtons({super.key});

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
            BlocConsumer<CallCubit, CallState>(
              builder: (context, state) {
                if (state is CallLoading) {
                  return const CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  );
                }

                return Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.read<CallCubit>().call('01102535450');
                    },
                    icon: const Icon(Icons.call),
                    label: const Text("Call"),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                );
              },
              listener: (context, state) {
                if (state is CallFailure) {
                  AppSnackBar.error(context, state.errMessage);
                }
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chat),
                label: const Text("WhatsApp"),
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
