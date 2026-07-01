part of 'ad_details_cubit.dart';

@immutable
sealed class AdDetailsState {}

final class AdDetailsLoading extends AdDetailsState {}

final class AdDetailsLoaded extends AdDetailsState {
  final AdModel ad;
  final List<ReviewModel> reviews;
  final bool isFavorite;
  final bool isSubmittingReview;
  final bool isCreatingConversation;
  final bool isTogglingFavorite;

  AdDetailsLoaded({
    required this.ad,
    required this.reviews,
    required this.isFavorite,
    this.isSubmittingReview = false,
    this.isCreatingConversation = false,
    this.isTogglingFavorite = false,
  });

  AdDetailsLoaded copyWith({
    AdModel? ad,
    List<ReviewModel>? reviews,
    bool? isFavorite,
    bool? isSubmittingReview,
    bool? isCreatingConversation,
    bool? isTogglingFavorite,
  }) {
    return AdDetailsLoaded(
      ad: ad ?? this.ad,
      reviews: reviews ?? this.reviews,
      isFavorite: isFavorite ?? this.isFavorite,
      isSubmittingReview: isSubmittingReview ?? this.isSubmittingReview,
      isCreatingConversation:
          isCreatingConversation ?? this.isCreatingConversation,
      isTogglingFavorite: isTogglingFavorite ?? this.isTogglingFavorite,
    );
  }
}

final class AdDetailsFailure extends AdDetailsState {
  final String message;

  AdDetailsFailure(this.message);
}

final class AdDetailsConversationReady extends AdDetailsState {
  final ConversationModel conversation;

  AdDetailsConversationReady(this.conversation);
}

final class AdDetailsInitial extends AdDetailsState {}
