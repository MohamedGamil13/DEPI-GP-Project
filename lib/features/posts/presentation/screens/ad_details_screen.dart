import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillbridge/core/locator/service_locator.dart';
import 'package:skillbridge/core/routing/app_navigator.dart';
import 'package:skillbridge/core/services/auth/auth_service.dart';
import 'package:skillbridge/core/services/chat/chat_service.dart';
import 'package:skillbridge/core/services/firestore/firestore_repo.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/core/utils/helpers/snackbar_manger.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/posts/presentation/screens/widgets/ad_content_section.dart';
import 'package:skillbridge/features/posts/presentation/screens/widgets/ad_details_widget.dart';
import 'package:skillbridge/features/posts/presentation/screens/widgets/ad_header_section.dart';
import 'package:skillbridge/features/posts/presentation/viewModel/ad_details_cubit/ad_details_cubit.dart';

class AdDetailsScreen extends StatelessWidget {
  final AdModel ad;

  const AdDetailsScreen({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdDetailsCubit(
        storeService: getIt<StoreService>(),
        chatService: getIt<IChatService>(),
        authService: getIt<AuthService>(),
      )..init(ad),
      child: BlocConsumer<AdDetailsCubit, AdDetailsState>(
        listener: (context, state) {
          if (state is AdDetailsFailure) {
            AppSnackBar.error(context, state.message);
          }
          if (state is AdDetailsConversationReady) {
            context.goChatDetail(state.conversation);
          }
        },
        builder: (context, state) {
          final loadedAd = state is AdDetailsLoaded ? state.ad : ad;
          final isFavorite = state is AdDetailsLoaded
              ? state.isFavorite
              : ad.isFavorite;

          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderSection(
                          ad: loadedAd,
                          isFavorite: isFavorite,
                          onFavoriteToggle: () =>
                              context.read<AdDetailsCubit>().toggleFavorite(),
                        ),
                        ContentSection(ad: loadedAd),
                      ],
                    ),
                  ),
                ),
                ContactButtons(
                  ad: loadedAd,
                  isSubmittingReview: state is AdDetailsLoaded
                      ? state.isSubmittingReview
                      : false,
                  isCreatingConversation: state is AdDetailsLoaded
                      ? state.isCreatingConversation
                      : false,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
