import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:skillbridge/core/routing/app_router.dart';
import 'package:skillbridge/core/services/auth/auth_service.dart';
import 'package:skillbridge/core/services/auth/firebase_auth_service.dart';
import 'package:skillbridge/core/services/chat/chat_service.dart';
import 'package:skillbridge/core/services/cloudinary/cloudinary_sotrage_service.dart';
import 'package:skillbridge/core/services/cloudinary/storage_service.dart';
import 'package:skillbridge/core/services/firestore/firestore_repo.dart';
import 'package:skillbridge/core/services/firestore/firestore_repo_service.dart';
import 'package:skillbridge/core/services/location/location_service.dart';
import 'package:skillbridge/core/services/notifications/app_push_service.dart';
import 'package:skillbridge/features/auth/data/repos/auth_repo.dart';
import 'package:skillbridge/features/auth/data/repos/auth_repo_implementation.dart';
import 'package:skillbridge/features/auth/presentation/viewmodel/auth_cubit.dart';
import 'package:skillbridge/features/home/presentation/cubits/home_cubit.dart';
import 'package:skillbridge/features/messages/presentation/viewmodel/messages_cubit.dart';
import 'package:skillbridge/features/posts/data/repos/post_ad_repo.dart';
import 'package:skillbridge/features/posts/data/repos/post_ad_repo_impl.dart';
import 'package:skillbridge/features/posts/presentation/viewModel/ad_posting_cubit/ad_posting_cubit.dart';
import 'package:skillbridge/core/utils/locale_cubit.dart';

GetIt getIt = GetIt.instance;

void setupLocator() {
  // ── Layer 1: Infrastructure ──────────────────────────────────────────────
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  getIt.registerLazySingleton<Dio>(() => Dio());

  // ── Layer 2: Services ────────────────────────────────────────────────────
  getIt.registerLazySingleton<StoreService>(
    () => FirestoreService(db: getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<LocationService>(() => LocationService());

  getIt.registerLazySingleton<AuthService>(
    () => FirebaseAuthService(
      getIt<FirebaseAuth>(),
      service: getIt<StoreService>(),
      locationService: getIt<LocationService>(),
    ),
  );

  getIt.registerLazySingleton<StorageService>(
    () => CloudinaryStorageService(
      cloudName: 'dfgogg7jk',
      uploadPreset: 'ml_default',
    ),
  );

  // ChatService is a singleton — one Firestore connection shared app-wide.
  getIt.registerLazySingleton<IChatService>(
    () => ChatService(firestore: getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<AppPushService>(
    () => AppPushService(
      messaging: FirebaseMessaging.instance,
      storeService: getIt<StoreService>(),
      authService: getIt<AuthService>(),
      router: router,
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

  getIt.registerLazySingleton<HomeCubit>(
    () => HomeCubit(
      firestoreService: getIt<StoreService>(),
      locationService: getIt<LocationService>(),
    ),
  );

  getIt.registerLazySingleton<LocaleCubit>(() => LocaleCubit());

  // Factory so each route gets a fresh cubit with its own stream subscriptions.
  // IChatService is a singleton so no duplicate Firestore listeners are opened.
  getIt.registerFactory<MessagesCubit>(
    () => MessagesCubit(chatService: getIt<IChatService>()),
  );
}
