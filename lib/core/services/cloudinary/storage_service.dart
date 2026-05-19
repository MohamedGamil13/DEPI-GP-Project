import 'dart:io';

import 'package:skillbridge/core/utils/validator/result.dart';

abstract class StorageService {
  Future<Result<List<String>>> uploadImages(List<File> images, String path);
}
