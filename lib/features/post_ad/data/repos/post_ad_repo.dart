import 'dart:io';

import 'package:skillbridge/core/models/ad_model.dart';
import 'package:skillbridge/core/utils/validator/result.dart';

abstract interface class PostAdRepo {
  Future<Result<void>> publishAd(AdModel ad, List<File> images);
}
