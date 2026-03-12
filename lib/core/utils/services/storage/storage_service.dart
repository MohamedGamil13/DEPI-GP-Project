import 'dart:io';

abstract class StorageService {
  Future<List<String>> uploadImages(List<File> images, String path);
}
