import 'dart:io';

import 'package:skillbridge/core/utils/validator/result.dart';
import 'package:skillbridge/features/home/data/ad_model.dart';
import 'package:skillbridge/features/profile/data/models/user_profile_model.dart';

abstract interface class PostAdRepo {
  Future<Result<void>> publishAd(AdModel ad, List<File> images);
  Future<Result<UserProfileModel>> getUserDataById(String id);
}
