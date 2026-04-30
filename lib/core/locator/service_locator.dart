import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:skillbridge/core/services/auth/auth_service.dart';
import 'package:skillbridge/core/services/auth/firebase_auth_service.dart';
import 'package:skillbridge/core/services/firestore/firestore_repo.dart';
import 'package:skillbridge/core/services/firestore/firestore_repo_service.dart';
import 'package:skillbridge/core/services/storage/cloudinary_sotrage_service.dart';
import 'package:skillbridge/core/services/storage/storage_service.dart';
import 'package:skillbridge/features/auth/data/repos/auth_repo.dart';
import 'package:skillbridge/features/auth/data/repos/auth_repo_implementation.dart';
import 'package:skillbridge/features/auth/presentation/viewmodel/auth_cubit.dart';
import 'package:skillbridge/features/home/presentation/cubits/home_cubit.dart';
import 'package:skillbridge/features/messages/presentation/viewmodel/messages_cubit.dart';
import 'package:skillbridge/features/post_ad/data/repos/post_ad_repo.dart';
import 'package:skillbridge/features/post_ad/data/repos/post_ad_repo_impl.dart';
import 'package:skillbridge/features/post_ad/presentation/viewModel/ad_posting_cubit.dart';

GetIt getIt =
    GetIt.instance; //take an intance from get_it => i use this package for DI

void setupLocator() {
  // Firebase instances
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // Services
  getIt.registerLazySingleton<AuthService>(
    () => FirebaseAuthService(getIt<FirebaseAuth>()),
  );
  getIt.registerLazySingleton<StoreService>(
    () => FirestoreService(db: getIt<FirebaseFirestore>()),
  );

  //dio
  getIt.registerLazySingleton<Dio>(() => Dio());
  //cloudinary
  getIt.registerLazySingleton<StorageService>(
    () => CloudinaryStorageService(
      cloudName: 'dfgogg7jk',
      uploadPreset: 'ml_default',
    ),
  );

  // Repos
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImplementation(authService: getIt<AuthService>()),
  );
  getIt.registerLazySingleton<PostAdRepo>(
    () => PostAdRepoImplementation(
      firestoreRepo: getIt<StoreService>(),
      storageService: getIt<StorageService>(),
    ),
  );

  // Cubits
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepo>()));
  getIt.registerFactory<AdPostingCubit>(
    () => AdPostingCubit(getIt<PostAdRepo>()),
  );
  getIt.registerFactory<MessagesCubit>(() => MessagesCubit());
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(
      firestoreService: getIt<StoreService>(),
    ), // review this line — use StoreService not FirestoreService
  );
}

//our flow => auth methods(firebase or something else) >  AuthService(deal with any authsevice from any source) => Auth repo(deal with authService only) => Auth cubit(deal with repo only) => UI
//and this flow will be implemented for any another service
