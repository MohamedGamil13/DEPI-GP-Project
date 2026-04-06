// import 'dart:io';

// import 'package:skillbridge/core/errors/app_exception.dart';
// import 'package:skillbridge/core/errors/database_exception.dart';
// import 'package:skillbridge/core/models/ad_model.dart';
// import 'package:skillbridge/core/utils/services/firestore/firestore_repo.dart';
// import 'package:skillbridge/core/utils/services/storage/storage_service.dart';
// import 'package:skillbridge/core/utils/validator/result.dart';
// import 'package:skillbridge/features/post_ad/data/repos/post_ad_repo.dart';

// class PostAdRepoImplementation implements PostAdRepo {
//   final FirestoreServiceRepo _firestoreRepo;
//   final StorageService _storageService;

//   PostAdRepoImplementation({
//     required FirestoreServiceRepo firestoreRepo,
//     required StorageService storageService,
//   }) : _firestoreRepo = firestoreRepo,
//        _storageService = storageService;

//   @override
//   Future<Result<void>> publishAd(AdModel ad, List<File> images) async {
//     try {
//       List<String> uploadedImageUrls = [];

//       if (images.isNotEmpty) {
//         final Result<List<String>> uploadResult = await _storageService
//             .uploadImages(images, 'ads/images');

//         if (uploadResult is Failure) return uploadResult;
//         uploadedImageUrls = (uploadResult as Success<List<String>>).data;
//       }

//       final updatedAd = ad.copyWith(photos: uploadedImageUrls);
//       return await _firestoreRepo.addPost(updatedAd);
//     } on AppException catch (e) {
//       return Failure(e);
//     } catch (e) {
//       return Failure(
//         UnknownDatabaseException(
//           code: 'publish-failed',
//           message: 'An unexpected error occurred while publishing the ad.',
//         ),
//       );
//     }
//   }
// }
