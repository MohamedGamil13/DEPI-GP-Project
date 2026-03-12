import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:skillbridge/core/models/ad_model.dart';
import 'package:skillbridge/core/utils/validator/result.dart';

import '../../data/repos/post_ad_repo.dart';

part 'ad_posting_state.dart';

class AdPostingCubit extends Cubit<AdPostingState> {
  final PostAdRepo _postAdRepo;

  AdPostingCubit(this._postAdRepo) : super(AdPostingInitial());

  Future<void> publishNewAd({
    required AdModel adModel,
    required List<File> images,
  }) async {
    emit(AdPostingLoading());

    final result = await _postAdRepo.publishAd(adModel, images);

    switch (result) {
      case Success(data: _):
        emit(AdPostingSuccess());
      case Failure(exception: var e):
        emit(AdPostingError(e.message));
    }
  }
}
