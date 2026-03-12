import 'dart:io';
import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/features/post_ad/data/models/post_ad_model.dart';

abstract interface class PostAdRepo {
  Future<Result<void>> publishAd(PostAdModel ad, List<File> images);
}
