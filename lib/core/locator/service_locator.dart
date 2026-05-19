import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:skillbridge/core/services/auth/auth_service.dart';
import 'package:skillbridge/core/services/auth/firebase_auth_service.dart';
import 'package:skillbridge/core/services/cloudinary/cloudinary_sotrage_service.dart';
import 'package:skillbridge/core/services/cloudinary/storage_service.dart';
import 'package:skillbridge/core/services/firestore/firestore_repo.dart';
import 'package:skillbridge/core/services/firestore/firestore_repo_service.dart';
import 'package:skillbridge/features/auth/data/models/auth_user_model.dart';
import 'package:skillbridge/features/auth/data/repos/auth_repo.dart';
import 'package:skillbridge/features/auth/data/repos/auth_repo_implementation.dart';
import 'package:skillbridge/features/auth/presentation/viewmodel/auth_cubit.dart';
import 'package:skillbridge/features/home/presentation/cubits/home_cubit.dart';
import 'package:skillbridge/features/messages/presentation/viewmodel/messages_cubit.dart';
import 'package:skillbridge/features/posts/data/repos/post_ad_repo.dart';
import 'package:skillbridge/features/posts/data/repos/post_ad_repo_impl.dart';
import 'package:skillbridge/features/posts/presentation/viewModel/ad_posting_cubit/ad_posting_cubit.dart';
import 'package:skillbridge/features/profile/data/models/user_profile_model.dart';

GetIt getIt = GetIt.instance;

void setupLocator() {
  // ── Layer 1: Infrastructure ──────────────────────────────────────────────
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  getIt.registerLazySingleton<Dio>(() => Dio());

  // ── Layer 2: Services ────────────────────────────────────────────────────
  // StoreService must come before AuthService (AuthService depends on it)
  getIt.registerLazySingleton<StoreService>(
    () => FirestoreService(db: getIt<FirebaseFirestore>()),
  );

  getIt.registerLazySingleton<AuthService>(
    () => FirebaseAuthService(
      getIt<FirebaseAuth>(),
      service: getIt<StoreService>(),
    ),
  );

  getIt.registerLazySingleton<StorageService>(
    () => CloudinaryStorageService(
      cloudName: 'dfgogg7jk',
      uploadPreset: 'ml_default',
    ),
  );

  // ── Layer 3: Repos ───────────────────────────────────────────────────────
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImplementation(authService: getIt<AuthService>()),
  );

  getIt.registerLazySingleton<PostAdRepo>(
    () => PostAdRepoImplementation(
      firestoreRepo: getIt<StoreService>(),
      storageService: getIt<StorageService>(),
    ),
  );

  // ── Layer 4: Cubits ──────────────────────────────────────────────────────
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepo>()));

  getIt.registerFactory<AdPostingCubit>(
    () => AdPostingCubit(getIt<PostAdRepo>()),
  );

  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(firestoreService: getIt<StoreService>()),
  );

  getIt.registerFactory<MessagesCubit>(() => MessagesCubit());
  getIt.registerLazySingleton<AuthUser>(
    () => AuthUser.fromFirebaseUser(FirebaseAuth.instance.currentUser!),
  );

  getIt.registerLazySingleton<UserProfileModel>(
    () => UserProfileModel.fromAuthUser(getIt<AuthUser>()),
  );
}
