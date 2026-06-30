import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:skillbridge/core/locator/service_locator.dart';
import 'package:skillbridge/core/services/auth/auth_service.dart';
import 'package:skillbridge/core/services/chat/chat_service.dart';
import 'package:skillbridge/core/services/firestore/firestore_repo.dart';
import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/features/home/presentation/cubits/home_cubit.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/messages/data/models/conversation_model.dart';
import 'package:skillbridge/features/posts/data/models/review_model.dart';
import 'package:skillbridge/features/profile/data/models/user_profile_model.dart';

part 'ad_details_state.dart';

class AdDetailsCubit extends Cubit<AdDetailsState> {
  AdDetailsCubit({
    required StoreService storeService,
    required IChatService chatService,
    required AuthService authService,
  }) : _storeService = storeService,
       _chatService = chatService,
       _authService = authService,
       super(AdDetailsInitial());

  final StoreService _storeService;
  final IChatService _chatService;
  final AuthService _authService;

  StreamSubscription<List<ReviewModel>>? _reviewsSub;
  AdModel? _ad;

  void _emitError(String message) {
    final previous = state;
    emit(AdDetailsFailure(message));
    if (previous is AdDetailsLoaded) {
      emit(previous);
    }
  }

  Future<void> init(AdModel ad) async {
    _ad = ad;
    emit(AdDetailsLoading());

    final favoriteResult = await _storeService.isFavorite(ad.adID);
    final isFavorite = switch (favoriteResult) {
      Success<bool>(:final data) => data,
      Failure<bool>() => ad.isFavorite,
    };

    emit(
      AdDetailsLoaded(
        ad: ad.copyWith(isFavorite: isFavorite),
        reviews: const [],
        isFavorite: isFavorite,
      ),
    );

    _reviewsSub?.cancel();
    _reviewsSub = _storeService.watchPostReviews(ad.adID).listen(
      (reviews) {
        final current = state;
        if (current is AdDetailsLoaded) {
          emit(current.copyWith(reviews: reviews));
        }
      },
      onError: (Object error) {
        _emitError('Failed to load reviews: $error');
      },
    );
  }

  Future<void> submitReview({
    required int rating,
    required String comment,
  }) async {
    final current = state;
    if (current is! AdDetailsLoaded || _ad == null) return;

    final user = _authService.currentUser;
    if (user == null) {
      _emitError('You must be signed in to leave a review.');
      return;
    }

    emit(current.copyWith(isSubmittingReview: true));

    UserProfileModel profile;
    final profileResult = await _storeService.getUserById(user.uid);
    profile = switch (profileResult) {
      Success<UserProfileModel>(:final data) => data,
      Failure<UserProfileModel>() => UserProfileModel.fromAuthUser(user),
    };

    final result = await _storeService.addReview(
      postId: _ad!.adID,
      userId: user.uid,
      userName: profile.name,
      userImage: profile.avatarUrl,
      rating: rating,
      comment: comment,
    );

    switch (result) {
      case Success<ReviewModel>():
        final refreshedPost = await _storeService.getPost(_ad!.adID);
        final updatedAd = switch (refreshedPost) {
          Success<AdModel>(:final data) => data.copyWith(
            isFavorite: current.isFavorite,
          ),
          Failure<AdModel>() => current.ad,
        };
        emit(
          current.copyWith(
            ad: updatedAd,
            isSubmittingReview: false,
          ),
        );
      case Failure<ReviewModel>(:final exception):
        emit(current.copyWith(isSubmittingReview: false));
        _emitError(exception.message);
    }
  }

  Future<void> toggleFavorite() async {
    final current = state;
    if (current is! AdDetailsLoaded) return;

    final postId = current.ad.adID;
    final nextValue = !current.isFavorite;

    emit(
      current.copyWith(
        isFavorite: nextValue,
        isTogglingFavorite: true,
        ad: current.ad.copyWith(isFavorite: nextValue),
      ),
    );

    final result = nextValue
        ? await _storeService.addFavorite(postId)
        : await _storeService.removeFavorite(postId);

    switch (result) {
      case Success<void>():
        final homeCubit = _tryReadHomeCubit();
        homeCubit?.syncFavoriteState(postId, nextValue);
        emit(
          (state as AdDetailsLoaded).copyWith(isTogglingFavorite: false),
        );
      case Failure<void>(:final exception):
        final homeCubit = _tryReadHomeCubit();
        homeCubit?.syncFavoriteState(postId, !nextValue);
        emit(
          current.copyWith(
            isFavorite: !nextValue,
            isTogglingFavorite: false,
            ad: current.ad.copyWith(isFavorite: !nextValue),
          ),
        );
        _emitError(exception.message);
    }
  }

  Future<void> messagePoster() async {
    final current = state;
    if (current is! AdDetailsLoaded || _ad == null) return;

    final user = _authService.currentUser;
    if (user == null) {
      _emitError('You must be signed in to send a message.');
      return;
    }

    if (user.uid == _ad!.userId) {
      _emitError('You cannot message yourself.');
      return;
    }

    emit(current.copyWith(isCreatingConversation: true));

    try {
      UserProfileModel customerProfile;
      final profileResult = await _storeService.getUserById(user.uid);
      customerProfile = switch (profileResult) {
        Success<UserProfileModel>(:final data) => data,
        Failure<UserProfileModel>() => UserProfileModel.fromAuthUser(user),
      };

      final serviceId = _ad!.adID.toString();
      final existing = await _chatService.findConversation(
        providerId: _ad!.userId,
        customerId: user.uid,
        serviceId: serviceId,
      );

      if (existing != null) {
        emit(current.copyWith(isCreatingConversation: false));
        emit(AdDetailsConversationReady(existing));
        return;
      }

      final conversation = await _chatService.createConversation(
        ConversationModel(
          id: '',
          providerId: _ad!.userId,
          customerId: user.uid,
          customerName: customerProfile.name,
          customerHandle: customerProfile.name,
          customerAvatarUrl: customerProfile.avatarUrl,
          serviceId: serviceId,
          serviceTitle: _ad!.title,
          serviceSummary: _ad!.description,
          serviceCategory: _ad!.category,
          serviceCity: _ad!.adCity,
          servicePrice: _ad!.price,
          status: ConversationStatus.newLead,
          unreadCount: 0,
          isOnline: false,
          createdAt: DateTime.now(),
        ),
      );

      emit(current.copyWith(isCreatingConversation: false));
      emit(AdDetailsConversationReady(conversation));
    } on ChatServiceException catch (e) {
      emit(current.copyWith(isCreatingConversation: false));
      _emitError(e.message);
    } catch (e) {
      emit(current.copyWith(isCreatingConversation: false));
      _emitError('Failed to start conversation: $e');
    }
  }

  @override
  Future<void> close() {
    _reviewsSub?.cancel();
    return super.close();
  }

  HomeCubit? _tryReadHomeCubit() {
    try {
      return getIt<HomeCubit>();
    } catch (_) {
      return null;
    }
  }
}
